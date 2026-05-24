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

def get_compatible_car_types(car_type: CarType) -> list[CarType]:
    CAR_TYPE_RANK = {
        CarType.private: 1,
        CarType.trailer: 2,
        CarType.pickupTruck: 3,
        CarType.truck: 4,
    }
    rank = CAR_TYPE_RANK[car_type]
    return [ct for ct, r in CAR_TYPE_RANK.items() if r <= rank]


class UserRole(StrEnum):
    driver = "driver"
    logistics = "logistics"
    admin = "admin"
