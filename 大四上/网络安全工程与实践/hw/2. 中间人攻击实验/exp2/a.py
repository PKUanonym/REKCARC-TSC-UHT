#!/usr/bin/env python3

import io
from PIL import Image
from mitmproxy import http

def response(flow: http.HTTPFlow) -> None:
    # print(flow.response.headers)
    if flow.response.headers.get("content-type", "").startswith("image"):
        s = io.BytesIO(flow.response.content)
        img = Image.open(s).rotate(180)
        s2 = io.BytesIO()
        img.save(s2, "png")
        flow.response.content = s2.getvalue()
        flow.response.headers["content-type"] = "image/png"