from pydantic import BaseModel
from api.models.enums import UserRole, CarType


class DriverProfile(BaseModel):
    carType: CarType


class UserProfile(BaseModel):
    uid: str
    email: str
    name: str
    phone: str
    role: UserRole
    driverProfile: DriverProfile | None
    fcmToken: str | None
