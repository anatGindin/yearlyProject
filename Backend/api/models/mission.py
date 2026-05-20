from api.models.enums import MissionStatus, CarType
from pydantic import BaseModel
from datetime import datetime

# Building blocks


class Contact(BaseModel):
    fullName: str
    phoneNumber: str


class Location(BaseModel):
    name: str
    latitude: float
    longitude: float


# Mission models


class MissionBase(BaseModel):
    id: str
    source: Location
    destination: Location
    description: str
    sourceContact: Contact
    destinationContact: Contact
    creationTime: datetime
    status: MissionStatus
    carType: CarType
    cancellationReason: str = ""
    driverUid: str | None = None


class MissionInDB(MissionBase):
    lastUpdate: datetime
    assignedBy: str | None = None


# For logistics or admins calling /missions/{mission_id}/assign
# the assignedBy will be the derived from the JWT token
class AssignMissionRequest(BaseModel):
    driverUid: str


# /missions/{mission_id}/update-status
class StatusUpdateRequest(BaseModel):
    status: MissionStatus


# /missions/{mission_id}/cancel
class CancelMissionRequest(StatusUpdateRequest):
    cancellationReason: str = ""
