FROM python:3.10-slim-buster

RUN pip install --no-cache-dir pdm
ADD ./pyproject.toml ./pdm.lock ./
RUN pdm sync && pdm cache clear

# Load model in advance.
# Pre-fetch with urllib: deepdanbooru_onnx's own downloader saves the raw
# (now gzip-compressed) HTTP stream for text files, corrupting tags.txt.
# With valid files already present, its md5 check passes and it skips downloading.
RUN mkdir -p /root/.deepdanbooru_onnx && pdm run python3 -c "\
import urllib.request; \
urllib.request.urlretrieve('https://huggingface.co/chinoll/deepdanbooru/resolve/main/deepdanbooru.onnx', '/root/.deepdanbooru_onnx/deepdanbooru.onnx'); \
urllib.request.urlretrieve('https://huggingface.co/chinoll/deepdanbooru/resolve/main/tags.txt', '/root/.deepdanbooru_onnx/tags.txt')"
RUN pdm run python3 -c "from deepdanbooru_onnx import DeepDanbooru; DeepDanbooru()"

ADD ./main.py ./
CMD pdm run uvicorn --host 0.0.0.0 --port $PORT main:app

