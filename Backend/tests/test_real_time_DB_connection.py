import sys
import os
import pytest
from datetime import UTC, datetime

# Add Backend directory to path so we can import firebase_config
sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

from firebase_config import get_realtime_db

TEST_PATH = "test_connection_check"


@pytest.fixture
def realtime_db():
    return get_realtime_db(TEST_PATH)


def test_realtime_db_write_and_read(realtime_db):
    """Test that we can connect to Realtime Database, write data, and read it back.

    The test creates a temporary node in the database and
    deletes it when finished, regardless of whether assertions pass.
    """
    ref = realtime_db
    created_keys = []

    try:
        # Write a test entry
        doc_data = {
            "message": "Hello from backend test",
            "timestamp": datetime.now(UTC).isoformat(),
        }
        new_ref = ref.push(doc_data)
        created_keys.append(new_ref.key)

        assert new_ref.key, "Entry should have been created with a key"

        # Read it back
        snapshot = new_ref.get()
        assert snapshot is not None, "Entry should exist after writing"
        assert snapshot["message"] == "Hello from backend test"

    finally:
        # Clean up: delete all entries created during this test
        for key in created_keys:
            ref.child(key).delete()
