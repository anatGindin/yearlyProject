import os
import firebase_admin
from firebase_admin import credentials, firestore, db


def get_realtime_db_url() -> str:
    base_path = os.path.dirname(os.path.abspath(__file__))
    url_path = os.path.join(base_path, "realtime_db_url.txt")
    with open(url_path) as f:
        return f.read().strip()


def initialize_firebase():
    """Initialize Firebase Admin SDK if not already initialized."""
    try:
        return firebase_admin.get_app()
    except ValueError:
        base_path = os.path.dirname(os.path.abspath(__file__))
        key_path = os.path.join(base_path, "serviceAccountKey.json")

        if not os.path.exists(key_path):
            raise FileNotFoundError(
                f"Service account key not found at {key_path}. "
                "Download it from the Firebase Console and place it in the Backend directory."
            ) from None

        cred = credentials.Certificate(key_path)
        return firebase_admin.initialize_app(cred, {"databaseURL": get_realtime_db_url()})


def get_firestore_client():
    """Return a Firestore client, initializing Firebase if needed."""
    initialize_firebase()
    return firestore.client()


def get_realtime_db(path="users"):
    """Return a Realtime Database reference at the given path, initializing Firebase if needed."""
    initialize_firebase()
    return db.reference(path)
