from fastapi import FastAPI

app = FastAPI()

@app.get("/")
def root_api():
    return {"status": "ok"}
