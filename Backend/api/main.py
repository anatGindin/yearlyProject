import logging
import socket
from api.routers import missions
from fastapi import FastAPI
from firebase_config import initialize_firebase

old_getaddrinfo = socket.getaddrinfo


def new_getaddrinfo(*args, **kwargs):
    responses = old_getaddrinfo(*args, **kwargs)
    return [r for r in responses if r[0] == socket.AF_INET]


socket.getaddrinfo = new_getaddrinfo

logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s [%(levelname)s] %(name)s - %(message)s",
)


# FOR CORS: from fastapi.middleware.cors import CORSMiddleware
def create_app() -> FastAPI:
    app = FastAPI(title="Clean API")
    """
    #code for CORS
    origins = [#frontend URL]

    app.add_middleware(
        CORSMiddleware,
        allow_origins=origins,
        allow_credentials=True,
        allow_methods=["GET", "POST", "PUT", "DELETE"],
        allow_headers=["*"],
    )
    """
    app.include_router(missions.router)

    @app.on_event("startup")
    async def startup():
        initialize_firebase()

    @app.on_event("shutdown")
    async def shutdown():
        return

    return app


app = create_app()
