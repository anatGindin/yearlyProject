import logging
from fastapi import Request, HTTPException
from firebase_admin import auth

logger = logging.getLogger(__name__)


def verify_jwt(request: Request) -> str:
    token = request.headers.get("Firebase-JWT")
    if not token:
        raise HTTPException(status_code=401, detail="Missing JWT token")
    try:
        decoded = auth.verify_id_token(token, check_revoked=True)
        return decoded["uid"]
    except auth.RevokedIdTokenError as err:
        logger.warning("JWT rejected: token has been revoked. uid=%s", getattr(err, 'uid', 'unknown'))
        raise HTTPException(status_code=401, detail="Token has been revoked") from err
    except auth.ExpiredIdTokenError as err:
        logger.warning("JWT rejected: token is expired.")
        raise HTTPException(status_code=401, detail="Token expired") from err
    except auth.InvalidIdTokenError as err:
        logger.warning("JWT rejected: invalid token — %s", err)
        raise HTTPException(status_code=401, detail="Invalid JWT token") from err
    except Exception as err:
        logger.error("JWT verification failed with unexpected error: %s: %s", type(err).__name__, err)
        raise HTTPException(status_code=401, detail="Invalid JWT token") from err


def verify_request(request: Request) -> str:
    return verify_jwt(request)
