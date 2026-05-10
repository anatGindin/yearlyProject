import json
import os
import firebase_admin  # type: ignore[import-untyped]
from firebase_admin import credentials, firestore  # type: ignore[import-untyped]


# A script for migrating json mock data into firestore database
def migrate():
    # Path to service account key
    base_path = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
    key_path = os.path.join(base_path, "serviceAccountKey.json")

    if not os.path.exists(key_path):
        print(f"Error: Service account key not found at {key_path}")
        return

    # Initialize Firebase Admin SDK
    try:
        firebase_admin.get_app()
    except ValueError:
        cred = credentials.Certificate(key_path)
        firebase_admin.initialize_app(cred)

    db = firestore.client()

    # Path to mock data
    mock_data_path = os.path.join(base_path, "..", "Frontend", "hamal_transport_app", "assets", "mock_data.json")

    if not os.path.exists(mock_data_path):
        print(f"Error: Mock data not found at {mock_data_path}")
        return

    with open(mock_data_path, encoding="utf-8") as f:
        data = json.load(f)

    # 1. Clear existing missions
    print("Clearing existing missions...")
    missions_ref = db.collection("missions")
    docs = missions_ref.stream()
    for doc in docs:
        doc.reference.delete()

    # 2. Migrate Missions with Firebase-generated IDs
    print("Migrating missions...")
    missions_count = 0
    mission_categories = ["sampleMissions", "availableMissions", "adminMissions"]

    batch = db.batch()
    for category in mission_categories:
        if category in data:
            for mission in data[category]:
                # Let Firebase generate a document ID
                doc_ref = missions_ref.document()
                mission["id"] = doc_ref.id  # Sync the internal ID field

                batch.set(doc_ref, mission)
                missions_count += 1

                if missions_count % 500 == 0:
                    batch.commit()
                    batch = db.batch()

    # Final commit
    batch.commit()
    print(f"Successfully migrated {missions_count} missions to Firestore.")


if __name__ == "__main__":
    migrate()
