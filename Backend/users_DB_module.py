from firebase_config import get_realtime_db


def user_exists(user_id: str) -> bool:
    """Check if a user ID exists in the Realtime Database."""
    ref = get_realtime_db()
    return ref.child(user_id).get() is not None


def get_user_role(user_id: str):
    """Return user role if user exists, otherwise None."""
    if not user_exists(user_id):
        return None
    ref = get_realtime_db()
    return ref.child(user_id).get()["role"]


def get_user_car_type(user_id: str):
    """Return user car type if user exists and has driver role, otherwise None."""
    if not user_exists(user_id):
        return None
    if get_user_role(user_id) != "driver":
        return None
    ref = get_realtime_db()
    return ref.child(f"{user_id}/driverProfile").get()["carType"]
