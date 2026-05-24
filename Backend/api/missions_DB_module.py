from api import users_DB_module, missions_DB_module
from api.models import enums, mission
from firebase_config import get_firestore_client
from google.cloud.firestore_v1.base_query import FieldFilter

def get_missions(driver_uid: str):
    if users_DB_module.get_user_role(driver_uid) == enums.UserRole.driver:
        missions_raw = missions_DB_module.get_missions_for_driver(driver_uid)
    else:
        missions_raw = missions_DB_module.get_all_missions()

    missions = {}
    for doc in missions_raw:
        data = doc.to_dict()
        data["id"] = doc.id

        # Convert Firestore Timestamps to datetime if needed
        for field in ("time", "lastUpdate"):
            if field in data and hasattr(data[field], "toDatetime"):
                data[field] = data[field].toDatetime()

        missions[doc.id] = mission.MissionInDB(**data)

    return list(missions.values())


def get_missions_for_driver(driver_uid: str):
    firestore_client = get_firestore_client()
    missions_ref = firestore_client.collection("missions")

    assigned_by_driver = missions_ref.where(filter=FieldFilter("driverUid", "==", driver_uid)).stream()
    available_for_driver = missions_ref.where(filter=FieldFilter("status", "==", enums.MissionStatus.available)).where(
        filter=FieldFilter("carType", "in", enums.get_compatible_car_types(users_DB_module.get_user_car_type(driver_uid)))
        ).stream()

    return [*assigned_by_driver, *available_for_driver]
    


def get_all_missions():
    firestore_client = get_firestore_client()
    missions_ref = firestore_client.collection("missions")

    return missions_ref.stream()
    