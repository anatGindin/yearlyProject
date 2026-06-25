import logging
import time
from fastapi import Request, HTTPException
from firebase_admin import auth

logger = logging.getLogger(__name__)

_MAX_CERT_RETRIES = 3
_CERT_RETRY_DELAY = 1.0  # seconds between retries


def verify_jwt(request: Request) -> str:
    token = request.headers.get("Firebase-JWT")
    if not token:
        raise HTTPException(status_code=401, detail="Missing JWT token")

    last_err: Exception | None = None
    for attempt in range(1, _MAX_CERT_RETRIES + 1):
        try:
            decoded = auth.verify_id_token(token, check_revoked=True)
            return decoded["uid"]
        except auth.CertificateFetchError as err:
            # Transient network error on cold start — retry after a short delay
            last_err = err
            logger.warning(
                "CertificateFetchError on attempt %d/%d — retrying in %.1fs: %s",
                attempt, _MAX_CERT_RETRIES, _CERT_RETRY_DELAY, err,
            )
            if attempt < _MAX_CERT_RETRIES:
                time.sleep(_CERT_RETRY_DELAY)
        except auth.RevokedIdTokenError as err:
            logger.warning("JWT rejected: token has been revoked.")
            raise HTTPException(status_code=401, detail="Token has been revoked") from err
        except auth.ExpiredIdTokenError as err:
            logger.warning("JWT rejected: token is expired.")
            raise HTTPException(status_code=401, detail="Token expired") from err
        except auth.InvalidIdTokenError as err:
            logger.warning("JWT rejected: invalid token — %s", err)
            raise HTTPException(status_code=401, detail="Invalid JWT token") from err
        except Exception as err:
            logger.error("JWT verification unexpected error: %s: %s", type(err).__name__, err)
            raise HTTPException(status_code=401, detail="Invalid JWT token") from err

    logger.error("CertificateFetchError after %d retries — giving up.", _MAX_CERT_RETRIES)
    raise HTTPException(status_code=503, detail="Auth service temporarily unavailable") from last_err


def verify_request(request: Request) -> str:
    return verify_jwt(request)
