from api.security import verify_request
from api.models import mission, enums
from api import missions_DB_module, users_DB_module, notification_dispatcher
from fastapi import APIRouter, HTTPException, Query, Request
from datetime import datetime

router = APIRouter(prefix="/missions", tags=["missions"])


@router.post("/", response_model=mission.MissionInDB, status_code=201)
def create_mission(request: Request, new_mission: mission.MissionInDB):
    uid = verify_request(request)
    role = users_DB_module.get_user_role(uid)
    if role not in [enums.UserRole.logistics, enums.UserRole.admin]:
        raise HTTPException(status_code=403, detail="Permission denied. Only logistics or admin can create missions.")

    new_mission.lastUpdate = datetime.now()
    missions_DB_module.create_mission(new_mission)
    return missions_DB_module.get_mission_by_id(new_mission.id)


@router.put("/{mission_id}/update-status", response_model=mission.MissionInDB)
def update_mission_status(request: Request, mission_id: str, status_update: mission.StatusUpdateRequest):
    _ = verify_request(request)
    m = missions_DB_module.get_mission_by_id(mission_id)
    if not m:
        raise HTTPException(status_code=404, detail="Mission not found")

    status = status_update.status
    if status not in [
        enums.MissionStatus.assigned,
        enums.MissionStatus.pickedUp,
        enums.MissionStatus.delivered,
        enums.MissionStatus.cancelled,
        enums.MissionStatus.available,
    ]:
        raise HTTPException(status_code=400, detail="Invalid status value")

    missions_DB_module.update_mission_status(mission_id, status)
    updated = missions_DB_module.get_mission_by_id(mission_id)

    # Notify all logistics/admins when a mission is delivered
    if status == enums.MissionStatus.delivered and updated:
        notification_dispatcher.notify_all_logistics(
            title="משימה נמסרה",
            body=f"{updated.source.name} → {updated.destination.name}",
            data={"missionId": mission_id, "event": "mission_delivered"},
        )

    return updated


@router.post("/{mission_id}/claim", response_model=mission.MissionInDB)
def claim_mission(request: Request, mission_id: str):
    uid = verify_request(request)
    role = users_DB_module.get_user_role(uid)
    if role != enums.UserRole.driver:
        raise HTTPException(status_code=403, detail="Only drivers can claim missions")

    try:
        missions_DB_module.claim_mission(mission_id, uid)
    except ValueError as e:
        raise HTTPException(status_code=400, detail=str(e)) from e

    return missions_DB_module.get_mission_by_id(mission_id)


@router.post("/{mission_id}/assign", response_model=mission.MissionInDB)
def assign_mission(request: Request, mission_id: str, assign_req: mission.AssignMissionRequest):
    uid = verify_request(request)
    role = users_DB_module.get_user_role(uid)
    if role not in [enums.UserRole.logistics, enums.UserRole.admin]:
        raise HTTPException(status_code=403, detail="Only logistics or admin can assign missions")

    m = missions_DB_module.get_mission_by_id(mission_id)
    if not m:
        raise HTTPException(status_code=404, detail="Mission not found")

    missions_DB_module.assign_mission(mission_id, assign_req.driverUid, uid)
    updated = missions_DB_module.get_mission_by_id(mission_id)

    # Notify the driver that a mission was assigned to them
    if updated:
        notification_dispatcher.notify_driver(
            driver_uid=assign_req.driverUid,
            title="משימה חדשה שויכה אליך",
            body=f"{updated.source.name} → {updated.destination.name}",
            data={"missionId": mission_id, "event": "mission_assigned"},
        )

    return updated


@router.post("/{mission_id}/cancel", response_model=mission.MissionInDB)
def cancel_mission(request: Request, mission_id: str, cancel_req: mission.CancelMissionRequest):
    uid = verify_request(request)
    m = missions_DB_module.get_mission_by_id(mission_id)
    if not m:
        raise HTTPException(status_code=404, detail="Mission not found")

    role = users_DB_module.get_user_role(uid)
    # If it's a driver, they can only cancel missions assigned to them
    if role == enums.UserRole.driver and m.driverUid != uid:
        raise HTTPException(status_code=403, detail="Cannot cancel mission not assigned to you")

    missions_DB_module.cancel_mission(mission_id, cancel_req.cancellationReason)
    return missions_DB_module.get_mission_by_id(mission_id)


@router.post("/{mission_id}/abandon", response_model=mission.MissionInDB)
def abandon_mission(request: Request, mission_id: str):
    uid = verify_request(request)
    m = missions_DB_module.get_mission_by_id(mission_id)
    if not m:
        raise HTTPException(status_code=404, detail="Mission not found")

    if m.driverUid != uid:
        raise HTTPException(status_code=403, detail="Cannot abandon mission not assigned to you")

    missions_DB_module.abandon_mission(mission_id)
    return missions_DB_module.get_mission_by_id(mission_id)


@router.post("/{mission_id}/archive")
def archive_mission(request: Request, mission_id: str):
    uid = verify_request(request)
    role = users_DB_module.get_user_role(uid)
    if role not in [enums.UserRole.logistics, enums.UserRole.admin]:
        raise HTTPException(status_code=403, detail="Only logistics or admin can archive missions")

    try:
        missions_DB_module.archive_mission(mission_id)
    except ValueError as e:
        raise HTTPException(status_code=404, detail=str(e)) from e

    return {"status": "success"}


@router.delete("/{mission_id}", status_code=204)
def delete_mission(request: Request, mission_id: str):
    uid = verify_request(request)
    role = users_DB_module.get_user_role(uid)
    if role not in [enums.UserRole.logistics, enums.UserRole.admin]:
        raise HTTPException(status_code=403, detail="Only logistics or admin can delete missions")

    missions_DB_module.delete_mission(mission_id)
    return


@router.get("/", response_model=list[mission.MissionBase])
def list_missions(
    request: Request,
    status: enums.MissionStatus | None = Query(None, description="Filter by mission status"),  # noqa: B008
    driver_id: str | None = Query(None, description="Filter by driver"),
):
    uid = verify_request(request)
    return missions_DB_module.get_missions(uid, status, driver_id)
