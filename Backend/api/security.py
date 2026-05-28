from fastapi import Request, HTTPException
from firebase_admin import auth


def verify_jwt(request: Request) -> str:
    token = request.headers.get("Firebase-JWT")
    if not token:
        raise HTTPException(status_code=401, detail="Missing JWT token")
    try:
        decoded = auth.verify_id_token(token, check_revoked=True)
        return decoded["uid"]
    except Exception as err:
        raise HTTPException(status_code=401, detail="Invalid JWT token") from err


def verify_request(request: Request) -> str:
    return verify_jwt(request)
