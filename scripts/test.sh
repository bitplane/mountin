#!/usr/bin/env bash

source .venv/bin/activate

pytest -m "not external_tools" .
