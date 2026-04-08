import os
from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel

app = FastAPI(
    title="UMF-DevKit FastAPI Service",
    description="Polyglot template — Python / FastAPI / Uvicorn backend",
    version="1.0.0",
)

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)


class GreetRequest(BaseModel):
    name: str


class GreetResponse(BaseModel):
    greeting: str


class HelloResponse(BaseModel):
    message: str
    framework: str
    language: str


class HealthResponse(BaseModel):
    status: str
    service: str
    version: str


@app.get("/", response_model=HelloResponse)
async def root():
    return HelloResponse(
        message="UMF-DevKit FastAPI service is running.",
        framework="FastAPI",
        language="Python 3",
    )


@app.get("/health", response_model=HealthResponse)
async def health():
    return HealthResponse(status="ok", service="umf-fastapi", version="1.0.0")


@app.get("/hello", response_model=HelloResponse)
async def hello():
    return HelloResponse(
        message="Hello from FastAPI!",
        framework="FastAPI",
        language="Python 3",
    )


@app.post("/greet", response_model=GreetResponse)
async def greet(body: GreetRequest):
    if not body.name.strip():
        raise HTTPException(status_code=400, detail="name must not be empty")
    return GreetResponse(greeting=f"Hello, {body.name}! — from FastAPI (Python 3)")


if __name__ == "__main__":
    import uvicorn

    port = int(os.environ.get("PORT", 8004))
    uvicorn.run("main:app", host="0.0.0.0", port=port, reload=False)
