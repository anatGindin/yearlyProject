import logging

from api.routers import missions
from fastapi import FastAPI

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
        #await """connect to the database"""
        print("connect to database")

    @app.on_event("shutdown")
    async def shutdown():
        #await """close the database connection"""
        print("disconnect from database")

    return app


app = create_app()
