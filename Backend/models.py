from pydantic import BaseModel
from enum import Enum

class CarType(Enum):
    Private = 1
    Trailer = 2
    PickupTruck = 3
    Truck = 4

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
    carType: CarType
    cancellationReason: str
    comments: list[str]

