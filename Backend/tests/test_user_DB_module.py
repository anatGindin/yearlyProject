import sys
import os
import pytest

sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

from firebase_config import get_realtime_db
from users_DB_module import user_exists, get_user_role, get_user_car_type

TEST_USER_ID = "test_user_temp"
TEST_DRIVER_ID = "test_driver_temp"

TEST_USER_DATA = {"role": "admin"}
TEST_DRIVER_DATA = {
    "role": "driver",
    "driverProfile": {
        "carType": "private"
    }
}


@pytest.fixture(autouse=True)
def setup_and_teardown():
    """Create test users before each test and delete them after."""
    ref = get_realtime_db()
    ref.child(TEST_USER_ID).set(TEST_USER_DATA)
    ref.child(TEST_DRIVER_ID).set(TEST_DRIVER_DATA)

    yield  # test runs here

    ref.child(TEST_USER_ID).delete()
    ref.child(TEST_DRIVER_ID).delete()


# --- user_exists tests ---

def test_user_exists_returns_true_for_existing_user():
    assert user_exists(TEST_USER_ID) is True


def test_user_exists_returns_false_for_missing_user():
    assert user_exists("nonexistent_user_xyz") is False


# --- get_user_role tests ---

def test_get_user_role_returns_correct_role():
    assert get_user_role(TEST_USER_ID) == "admin"


def test_get_user_role_returns_none_for_missing_user():
    assert get_user_role("nonexistent_user_xyz") is None


# --- get_user_car_type tests ---

def test_get_user_car_type_returns_car_type_for_driver():
    assert get_user_car_type(TEST_DRIVER_ID) == "private"


def test_get_user_car_type_returns_none_for_non_driver():
    assert get_user_car_type(TEST_USER_ID) is None  # admin role, not driver


def test_get_user_car_type_returns_none_for_missing_user():
    assert get_user_car_type("nonexistent_user_xyz") is None