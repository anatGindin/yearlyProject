from enum import StrEnum


class MissionStatus(StrEnum):
    available = "available"
    assigned = "assigned"
    pickedUp = "pickedUp"
    delivered = "delivered"
    cancelled = "cancelled"


class CarType(StrEnum):
    private = "private"
    trailer = "trailer"
    pickupTruck = "pickupTruck"
    truck = "truck"


class UserRole(StrEnum):
    driver = "driver"
    logistics = "logistics"
    admin = "admin"
