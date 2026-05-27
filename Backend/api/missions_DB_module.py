from api import users_DB_module, missions_DB_module
from api.models import enums, mission
from firebase_config import get_firestore_client
from google.cloud.firestore_v1.base_query import FieldFilter


def get_missions(requester_uid: str, status: enums.MissionStatus | None, driver_uid: str | None):
    if users_DB_module.get_user_role(requester_uid) == enums.UserRole.driver:
        missions_raw = missions_DB_module.get_missions_for_driver(requester_uid, status)
    else:
        missions_raw = missions_DB_module.get_missions_for_logistic(status, driver_uid)

    missions = []
    for doc in missions_raw:
        data = doc.to_dict()
        missions.append(mission.MissionBase(**data))

    return missions


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
