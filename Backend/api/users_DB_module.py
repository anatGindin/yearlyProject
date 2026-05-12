from firebase_config import get_realtime_db
from api.models.enums import UserRole, CarType
import logging

logger = logging.getLogger(__name__)


def user_exists(user_id: str) -> bool:
    """Check if a user ID exists in the Realtime Database."""
    ref = get_realtime_db()
    return ref.child(user_id).get() is not None


def get_user_role(user_id: str) -> UserRole | None:
    """Return user role if user exists, otherwise None."""
    if not user_exists(user_id):
        logger.warning("User %s does not exist", user_id)
        return None
    ref = get_realtime_db()
    try:
        role_data = ref.child(user_id).get()["role"]
        return UserRole(role_data)
    except (ValueError, KeyError) as e:
        logger.warning("Invalid role for user %s: %r — %s", user_id, role_data, e)
        return None


def get_user_car_type(user_id: str) -> CarType | None:
    """Return user car type if user exists and has driver role, otherwise None."""
    if not user_exists(user_id):
        logger.warning("User %s does not exist", user_id)
        return None
    if get_user_role(user_id) != UserRole.driver:
        logger.warning("User %s does not have driver role", user_id)
        return None
    ref = get_realtime_db()
    try:
        car_type_data = ref.child(f"{user_id}/driverProfile").get()["carType"]
        return CarType(car_type_data)
    except (ValueError, KeyError) as e:
        logger.warning("Invalid carType for user %s: %r — %s", user_id, car_type_data, e)
        return None
