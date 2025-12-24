from fastapi import APIRouter, HTTPException
from typing import List
import json
import os

from app.models import Mission

router = APIRouter(prefix="/missions", tags=["missions"])

# TEMP storage (replace with DB later)
file_path = "/Frontend/hamal_transport_app/assets/mock_data.json"

if os.path.exists(file_path):
    with open(file_path, "r") as f:
        missions = [Mission(**m) for m in json.load(f)]
else:
    missions = []

def save_missions():
    with open(file_path, "w") as f:
        json.dump([m.dict() for m in missions], f)


@router.post("/", response_model=Mission, status_code=201)
def create_mission(new_mission: Mission):
    missions.append(new_mission)
    save_missions()
    return new_mission

@router.put("/{mission_id}", response_model=Mission)
def update_mission(mission_id: str, updated_mission: Mission):
    for index, mission in enumerate(missions):
        if mission.id == mission_id:
            missions[index] = updated_mission
            save_missions()
            return updated_mission
    raise HTTPException(status_code=404, detail="Mission not found")

@router.delete("/{mission_id}", status_code=204)
def delete_mission(mission_id: str):
    for index, mission in enumerate(missions):
        if mission.id == mission_id:
            missions.pop(index)
            save_missions()
            return
    raise HTTPException(status_code=404, detail="Mission not found")

@router.get("/", response_model=List[Mission])
def list_missions(
    status: Optional[str] = Query(None, description="Filter by mission status"),
    driver_id: Optional[str] = Query(None, description="Filter by driver"),
):
    result = missions
    #TODO: change when given DB
    if status:
        result = [m for m in result if m.status == status]

    if driver_id:
        result = [m for m in result if getattr(m, "driver_id", None) == driver_id]

    return result
