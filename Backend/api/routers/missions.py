import json
import os
from api.models import mission, enums
from fastapi import APIRouter, HTTPException, Query
from datetime import datetime

router = APIRouter(prefix="/missions", tags=["missions"])

# TEMP storage (replace with DB later)
file_path = "/Backend/mock_data.json"

if os.path.exists(file_path):
    with open(file_path) as f:
        missions = [mission.MissionInDB(**m) for m in json.load(f)]
else:
    missions = []


def save_missions():
    with open(file_path, "w") as f:
        json.dump([m.dict() for m in missions], f)


@router.post("/", response_model=mission.MissionInDB, status_code=201)
def create_mission(new_mission: mission.MissionInDB):
    missions.append(new_mission)
    save_missions()
    return new_mission


@router.put("/{mission_id}/{status}", response_model=mission.MissionInDB)
def update_mission_status(mission_id: str, status: str):
    for m in missions:
        if m.id == mission_id:
            # check if status is valid
            if status not in ["assigned", "pickedUp", "delivered", "cancelled", "available"]:
                raise HTTPException(status_code=400, detail="Invalid status value")
            if m.status == "available" and status != "assigned":
                raise HTTPException(status_code=400, detail="Invalid status transition from available")
            if m.status == "assigned" and status not in ["pickedUp", "cancelled"]:
                raise HTTPException(status_code=400, detail="Invalid status transition from assigned")
            if m.status == "pickedUp" and status not in ["delivered", "cancelled"]:
                raise HTTPException(status_code=400, detail="Invalid status transition from pickedUp")
            m.status = enums.MissionStatus(status)
            m.lastUpdate = datetime.now()
            save_missions()
            return m
    raise HTTPException(status_code=404, detail="Mission not found")


@router.delete("/{mission_id}", status_code=204)
def delete_mission(mission_id: str):
    for index, m in enumerate(missions):
        if m.id == mission_id:
            missions.pop(index)
            save_missions()
            return
    raise HTTPException(status_code=404, detail="Mission not found")


@router.get("/", response_model=list[mission.MissionBase])
def list_missions(
    status: str | None = Query(None, description="Filter by mission status"),
    driver_id: str | None = Query(None, description="Filter by driver"),
):
    result = missions
    # TODO: change when given DB
    if status:
        result = [m for m in result if m.status == status]

    if driver_id:
        result = [m for m in result if getattr(m, "driver_id", None) == driver_id]

    return result
