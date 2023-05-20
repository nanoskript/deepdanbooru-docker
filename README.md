# deepdanbooru-docker

[Docker Hub](https://hub.docker.com/r/nanoskript/deepdanbooru)
| [API documentation](https://deepdanbooru.nanoskript.dev/docs)
| [Web tool](https://nanoskript.dev/tools/deepdanbooru/)

Docker service for <https://github.com/KichangKim/DeepDanbooru>.

This uses the [deepdanbooru-onnx](https://pypi.org/project/deepdanbooru-onnx/) library
([GitHub repository](https://github.com/chinoll/deepdanbooru_onnx)) which has converted
the original TensorFlow model into an ONNX model.

## Installation

```
docker run --publish $PORT:$PORT --env PORT=$PORT --detach nanoskript/deepdanbooru
```

## Configuration

### Threshold

The confidence threshold for which results are filtered by can be configured
with the `DEEPDANBOORU_THRESHOLD` environment variable:

```
docker run --env DEEPDANBOORU_THRESHOLD=0.0 ... 
```

By default, this is set to `0.5`.
