import os
import firebase_admin
from firebase_admin import credentials, firestore


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
            )

        cred = credentials.Certificate(key_path)
        return firebase_admin.initialize_app(cred)


def get_firestore_client():
    """Return a Firestore client, initializing Firebase if needed."""
    initialize_firebase()
    return firestore.client()
