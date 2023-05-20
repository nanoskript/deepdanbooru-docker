import io
import os

from fastapi import FastAPI, File
from pydantic import BaseModel
from starlette.middleware.cors import CORSMiddleware
from starlette.responses import RedirectResponse
from deepdanbooru_onnx import DeepDanbooru
from PIL import Image

app = FastAPI(title="deepdanbooru-docker")
app.add_middleware(CORSMiddleware, allow_origins=["*"])
threshold = float(os.environ.get("DEEPDANBOORU_THRESHOLD") or "0.5")
deepdanbooru = DeepDanbooru(threshold=threshold)


class Result(BaseModel):
    tag: str
    score: float


@app.get("/", include_in_schema=False)
async def route_index():
    return RedirectResponse("/docs")


@app.post("/deepdanbooru", summary="Extract Danbooru tags from an image.")
async def route_deepdanbooru(image: bytes = File()) -> list[Result]:
    results = deepdanbooru(Image.open(io.BytesIO(image)))
    results = [Result(tag=tag, score=score.item()) for tag, score in results.items()]
    results.sort(key=lambda result: result.score, reverse=True)
    return results
