import shutil
import sys
import tarfile
from pathlib import Path


source = Path("/host/build/sources/qemu-10.2.3.tar.gz")
outputs = {Path(output).name: Path("/host/build") / output for output in sys.argv[1:]}
with tarfile.open(source, "r:gz") as archive:
    for member in archive:
        name = Path(member.name).name
        if name not in outputs or not member.name.endswith("/pc-bios/" + name):
            continue
        if not member.isfile():
            raise RuntimeError(f"firmware is not a regular file: {member.name}")
        output = outputs.pop(name)
        output.parent.mkdir(parents=True, exist_ok=True)
        temporary = output.with_suffix(output.suffix + ".tmp")
        with archive.extractfile(member) as firmware, temporary.open("wb") as target:
            shutil.copyfileobj(firmware, target)
        temporary.replace(output)
        if not outputs:
            break
if outputs:
    raise RuntimeError(f"missing QEMU firmware: {', '.join(outputs)}")
