import sys
import os
import pytest
from datetime import UTC, datetime

# Add Backend directory to path so we can import firebase_config
sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

from firebase_config import get_firestore_client

TEST_COLLECTION = "test_connection_check"


@pytest.fixture
def firestore_client():
    return get_firestore_client()


def test_firestore_write_and_read(firestore_client):
    """Test that we can connect to Firestore, write data, and read it back.

    The test creates documents in a temporary test collection and
    deletes them when finished, regardless of whether assertions pass.
    """
    db = firestore_client
    collection_ref = db.collection(TEST_COLLECTION)
    created_doc_ids = []

    try:
        # Write a test document
        doc_data = {
            "message": "Hello from backend test",
            "timestamp": datetime.now(UTC).isoformat(),
        }
        _, doc_ref = collection_ref.add(doc_data)
        created_doc_ids.append(doc_ref.id)

        assert doc_ref.id, "Document should have been created with an ID"

        # Read it back
        doc_snapshot = doc_ref.get()
        assert doc_snapshot.exists, "Document should exist after writing"
        assert doc_snapshot.to_dict()["message"] == "Hello from backend test"

    finally:
        # Clean up: delete all documents created during this test
        for doc_id in created_doc_ids:
            collection_ref.document(doc_id).delete()

        for doc in collection_ref.stream():
            doc.reference.delete()
