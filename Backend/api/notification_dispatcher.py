"""
Notification Dispatcher Module
==============================
Sends Firebase Cloud Messaging (FCM) push notifications to users.

Usage in routers:
    from api.notification_dispatcher import notify_driver, notify_all_logistics
    notify_driver(driver_uid, title, body)
    notify_all_logistics(title, body)

Each function is fire-and-forget safe — errors are logged, never raised,
so that a failed notification never blocks a mission operation.
"""

import logging
from firebase_admin import messaging
from firebase_config import get_realtime_db
from api.models.enums import UserRole

logger = logging.getLogger(__name__)


# ---------------------------------------------------------------------------
# Low-level helpers
# ---------------------------------------------------------------------------


def _get_user_fcm_token(user_id: str) -> str | None:
    """Fetch the FCM token for a single user from Realtime Database."""
    ref = get_realtime_db()
    user_data = ref.child(user_id).get()
    if user_data is None:
        return None
    return user_data.get("fcmToken")


def _get_all_users_by_role(role: UserRole) -> list[dict]:
    """Return a list of dicts for every user with the given role.

    Each dict contains at minimum {"uid": ..., "fcmToken": ...}.
    Users without an fcmToken are excluded.
    """
    ref = get_realtime_db()
    all_users = ref.get() or {}
    results = []
    for uid, data in all_users.items():
        if not isinstance(data, dict):
            continue
        if data.get("role") != role.value:
            continue
        token = data.get("fcmToken")
        if token:
            results.append({"uid": uid, "fcmToken": token, **data})
    return results


def _send_to_token(token: str, title: str, body: str, data: dict | None = None) -> bool:
    """Send a single FCM notification. Returns True on success."""
    message = messaging.Message(
        notification=messaging.Notification(title=title, body=body),
        data=data or {},
        token=token,
    )
    try:
        response = messaging.send(message)
        logger.info("FCM sent successfully: %s", response)
        return True
    except messaging.UnregisteredError:
        logger.warning("FCM token is unregistered (stale): %s…", token[:20])
        return False
    except Exception:
        logger.exception("FCM send failed for token %s…", token[:20])
        return False


def _send_to_tokens(tokens: list[str], title: str, body: str, data: dict | None = None) -> int:
    """Send the same notification to multiple tokens using batch.

    Returns the number of successfully sent messages.
    """
    if not tokens:
        return 0

    message = messaging.MulticastMessage(
        notification=messaging.Notification(title=title, body=body),
        data=data or {},
        tokens=tokens,
    )
    try:
        response = messaging.send_each_for_multicast(message)
        logger.info(
            "FCM multicast: %d success, %d failure",
            response.success_count,
            response.failure_count,
        )
        return response.success_count
    except Exception:
        logger.exception("FCM multicast send failed")
        return 0


# ---------------------------------------------------------------------------
# Public API — high-level notification dispatchers
# ---------------------------------------------------------------------------


def notify_driver(driver_uid: str, title: str, body: str, data: dict | None = None) -> bool:
    """Send a notification to a specific driver by UID.

    Returns True if the notification was sent successfully.
    Silently returns False on any error.
    """
    token = _get_user_fcm_token(driver_uid)
    if not token:
        logger.info("No FCM token for driver %s — skipping notification", driver_uid)
        return False
    return _send_to_token(token, title, body, data)


def notify_all_logistics(title: str, body: str, data: dict | None = None) -> int:
    """Send a notification to every logistics user who has an FCM token.

    Returns the count of successfully delivered notifications.
    """
    logistics_users = _get_all_users_by_role(UserRole.logistics)
    admin_users = _get_all_users_by_role(UserRole.admin)
    all_staff = logistics_users + admin_users

    tokens = [u["fcmToken"] for u in all_staff]
    if not tokens:
        logger.info("No logistics/admin users with FCM tokens — skipping notification")
        return 0

    # Deduplicate in case a user appears twice
    tokens = list(set(tokens))
    return _send_to_tokens(tokens, title, body, data)


def notify_user(user_uid: str, title: str, body: str, data: dict | None = None) -> bool:
    """Send a notification to any user by UID (role-agnostic).

    Returns True if the notification was sent successfully.
    """
    token = _get_user_fcm_token(user_uid)
    if not token:
        logger.info("No FCM token for user %s — skipping notification", user_uid)
        return False
    return _send_to_token(token, title, body, data)
