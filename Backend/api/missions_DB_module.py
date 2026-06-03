from api import users_DB_module
from api.models import enums, mission
from firebase_config import get_firestore_client
from google.cloud.firestore_v1.base_query import FieldFilter
from google.cloud import firestore


def get_missions(requester_uid: str, status: enums.MissionStatus | None, driver_uid: str | None):
    if users_DB_module.get_user_role(requester_uid) == enums.UserRole.driver:
        missions_raw = get_missions_for_driver(requester_uid, status)
    else:
        missions_raw = get_missions_for_logistic(status, driver_uid)

    missions = []
    for doc in missions_raw:
        data = doc.to_dict()
        missions.append(mission.MissionBase(**data))

    return missions


def get_mission_by_id(mission_id: str) -> mission.MissionInDB | None:
    firestore_client = get_firestore_client()
    doc = firestore_client.collection("missions").document(mission_id).get()
    if not doc.exists:
        return None
    data = doc.to_dict()
    return mission.MissionInDB(**data)


def get_missions_for_driver(driver_uid: str, status: enums.MissionStatus | None):
    firestore_client = get_firestore_client()
    missions_ref = firestore_client.collection("missions")
    if status is None:
        assigned_to_driver = missions_ref.where(filter=FieldFilter("driverUid", "==", driver_uid)).stream()
        return assigned_to_driver
    car_type = users_DB_module.get_user_car_type(driver_uid)
    if car_type is None:  # default car type
        car_type = enums.CarType.private

    available_for_driver = (
        missions_ref.where(filter=FieldFilter("status", "==", enums.MissionStatus.available))
        .where(filter=FieldFilter("carType", "in", get_compatible_car_types(car_type)))
        .stream()
    )

    return available_for_driver


def get_missions_for_logistic(status: enums.MissionStatus | None, driver_uid: str | None):
    firestore_client = get_firestore_client()
    missions_ref = firestore_client.collection("missions")
    if status is not None:
        missions_ref = missions_ref.where(filter=FieldFilter("status", "==", status))
    if driver_uid is not None:
        missions_ref = missions_ref.where(filter=FieldFilter("driverUid", "==", driver_uid))
    return missions_ref.stream()


def get_compatible_car_types(car_type: enums.CarType) -> list[enums.CarType]:
    CAR_TYPE_RANK = {
        enums.CarType.private: 1,
        enums.CarType.trailer: 2,
        enums.CarType.pickupTruck: 3,
        enums.CarType.truck: 4,
    }
    rank = CAR_TYPE_RANK[car_type]
    return [ct for ct, r in CAR_TYPE_RANK.items() if r <= rank]


def create_mission(mission_data: mission.MissionInDB):
    firestore_client = get_firestore_client()
    data = mission_data.model_dump(by_alias=True)
    firestore_client.collection("missions").document(mission_data.id).set(data)


def update_mission_status(mission_id: str, status: enums.MissionStatus):
    firestore_client = get_firestore_client()
    mission_ref = firestore_client.collection("missions").document(mission_id)
    mission_ref.update({"status": status.value})


@firestore.transactional
def claim_mission_transaction(transaction, mission_ref, driver_uid):
    snapshot = mission_ref.get(transaction=transaction)
    if not snapshot.exists:
        raise ValueError("Mission not found")
    if snapshot.get("status") != enums.MissionStatus.available.value:
        raise ValueError("Mission is not available")

    transaction.update(mission_ref, {"status": enums.MissionStatus.assigned.value, "driverUid": driver_uid})


def claim_mission(mission_id: str, driver_uid: str):
    firestore_client = get_firestore_client()
    transaction = firestore_client.transaction()
    mission_ref = firestore_client.collection("missions").document(mission_id)
    claim_mission_transaction(transaction, mission_ref, driver_uid)


@firestore.transactional
def assign_mission_transaction(transaction, mission_ref, driver_uid, assigner_uid):
    snapshot = mission_ref.get(transaction=transaction)
    if not snapshot.exists:
        raise ValueError("Mission not found")

    transaction.update(
        mission_ref, {"status": enums.MissionStatus.assigned.value, "driverUid": driver_uid, "assignedBy": assigner_uid}
    )


def assign_mission(mission_id: str, driver_uid: str, assigner_uid: str):
    firestore_client = get_firestore_client()
    transaction = firestore_client.transaction()
    mission_ref = firestore_client.collection("missions").document(mission_id)
    assign_mission_transaction(transaction, mission_ref, driver_uid, assigner_uid)


def cancel_mission(mission_id: str, reason: str):
    firestore_client = get_firestore_client()
    mission_ref = firestore_client.collection("missions").document(mission_id)
    mission_ref.update({"status": enums.MissionStatus.available.value, "cancellationReason": reason, "driverUid": None})


def abandon_mission(mission_id: str):
    firestore_client = get_firestore_client()
    mission_ref = firestore_client.collection("missions").document(mission_id)
    mission_ref.update({"status": enums.MissionStatus.available.value, "driverUid": None})


def delete_mission(mission_id: str):
    firestore_client = get_firestore_client()
    firestore_client.collection("missions").document(mission_id).delete()


@firestore.transactional
def archive_mission_transaction(transaction, mission_ref, archive_ref):
    snapshot = mission_ref.get(transaction=transaction)
    if not snapshot.exists:
        raise ValueError("Mission not found")

    data = snapshot.to_dict()
    transaction.set(archive_ref, data)
    transaction.delete(mission_ref)


def archive_mission(mission_id: str):
    firestore_client = get_firestore_client()
    transaction = firestore_client.transaction()
    mission_ref = firestore_client.collection("missions").document(mission_id)
    archive_ref = firestore_client.collection("archived_missions").document(mission_id)
    archive_mission_transaction(transaction, mission_ref, archive_ref)
