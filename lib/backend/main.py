from fastapi import FastAPI, Query
from fastapi.middleware.cors import CORSMiddleware
from typing import Optional
import requests
import uuid

app = FastAPI()

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

RXIMAGE_BASE = "https://rximage.nlm.nih.gov/api/rximage/1"
RXNORM_BASE = "https://rxnav.nlm.nih.gov/REST"


def make_id():
    return str(uuid.uuid4())


def rxnorm_name_from_rxcui(rxcui):
    if not rxcui:
        return ""
    try:
        r = requests.get(
            RXNORM_BASE + "/rxcui/" + str(rxcui) + "/properties.json",
            timeout=6,
        )
        r.raise_for_status()
        return r.json().get("properties", {}).get("name", "")
    except Exception:
        return ""


@app.get("/search")
def search_pill(
    imprint: str = Query(..., min_length=1),
    color: Optional[str] = Query(None),
    shape: Optional[str] = Query(None),
):
    params = {"imprint": imprint}

    if color:
        params["color"] = color
    if shape:
        params["shape"] = shape

    try:
        r = requests.get(
            RXIMAGE_BASE + "/pill",
            params=params,
            timeout=8,
        )
        r.raise_for_status()
    except Exception:
        return {"results": []}

    pills = r.json().get("nlmRxImages", [])
    results = []

    for p in pills:
        rxcui = p.get("rxcui")
        name = rxnorm_name_from_rxcui(rxcui)

        results.append({
            "id": make_id(),
            "name": name or "Unknown drug",
            "strength": p.get("strength", ""),
            "imprint": p.get("imprint", ""),
            "color": p.get("color", ""),
            "shape": p.get("shape", ""),
            "image": p.get("imageUrl"),
            "rxcui": rxcui,
            "source": "rximage",
            "confidence": 0.9 if name else 0.6,
        })

    return {"results": results}
