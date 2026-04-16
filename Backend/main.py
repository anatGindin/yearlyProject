from app.routers import missions
from fastapi import FastAPI


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
        await """connect to the database"""

    @app.on_event("shutdown")
    async def shutdown():
        await """close the database connection"""

    return app


app = create_app()
