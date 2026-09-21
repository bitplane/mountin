"""Host unit tests may spawn Python, but not external executables."""

import subprocess
import sys
from pathlib import Path

import pytest


@pytest.fixture(autouse=True)
def python_only_host_tests(request, monkeypatch):
    if request.node.get_closest_marker("external_tools"):
        return

    original_popen = subprocess.Popen

    def python_process_only(*args, **kwargs):
        command = args[0] if args else kwargs.get("args")
        executable = command[0] if isinstance(command, (list, tuple)) else command
        if Path(executable).resolve() != Path(sys.executable).resolve():
            raise AssertionError(f"Host tests must not launch {executable}")
        return original_popen(*args, **kwargs)

    monkeypatch.setattr(subprocess, "Popen", python_process_only)
