from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
from typing import List
import json
import os

app = FastAPI()

#class definitions
class Contact(BaseModel):
    fullName: str
    phoneNumber: str
class Mission(BaseModel):
    id: str
    location: str
    description: str
    contact: Contact
    time: str
    status: str

#get missions from /Frontend/hamal_transport_app/assets/mock_data.dart
#change when given DB
file_path = '/Frontend/hamal_transport_app/assets/mock_data.dart'
if os.path.exists(file_path):
    with open(file_path, 'r') as f:
        missions = json.load(f)
else:
    missions = []
    
@app.get("/Missions/{Mission_id}", response_model=Mission)
def get_mission(Mission_id: str):
    for mission in missions:
        if mission.id == Mission_id:
            return mission
    raise HTTPException(status_code=404, detail="Mission not found")

@app.delete("/Missions/{Mission_id}", status_code=204)
def delete_mission(Mission_id: str):
    for index, mission in enumerate(missions):
        if mission.id == Mission_id:
            missions.pop(index)
            #change when given DB
            with open(file_path, 'w') as f:
                json.dump(missions, f)
            return
    raise HTTPException(status_code=404, detail="Mission not found")

@app.put("/Missions/{Mission_id}", response_model=Mission)
def update_mission(Mission_id: str, updated_mission: Mission):
    for index, mission in enumerate(missions):
        if mission.id == Mission_id:
            missions[index] = updated_mission
            #change when given DB
            with open(file_path, 'w') as f:
                json.dump(missions, f)
            return missions[index]
    raise HTTPException(status_code=404, detail="Mission not found")

@app.post("/Missions/", response_model=Mission, status_code=201)
def create_mission(new_mission: Mission):
    missions.append(new_mission)
    #change when given DB
    with open(file_path, 'w') as f:
        json.dump(missions, f)
    return new_mission

@app.get("/Missions/", response_model=List[Mission])
def get_all_missions():
    return missions

#get the available missions
@app.get("/Missions/available", response_model=List[Mission])
def get_available_missions():
    available_missions = [mission for mission in missions if mission.status == "available"]
    return available_missions

#get the missions assigned to a specific driver
@app.get("/Missions/driver/{driver_id}", response_model=List[Mission])
def get_missions_by_driver(driver_id: str):
    #change when given DB
    driver_missions = []
    return driver_missions


