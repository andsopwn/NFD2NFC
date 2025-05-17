# nfd2nfc_zip.sh
#!/usr/bin/env bash
set -euo pipefail

SRC="${1:-.}"
BASE="$(basename "$SRC")"
DST="${2:-$BASE.zip}"

find "$SRC" -type f -name '.DS_Store' -delete

python3 - <<'PY' "$SRC" "$DST"
import sys, unicodedata, pathlib, zipfile

root = pathlib.Path(sys.argv[1]).resolve()
out  = sys.argv[2]

with zipfile.ZipFile(out, 'w', compression=zipfile.ZIP_DEFLATED) as z:
    for p in root.rglob('*'):
        if p.is_file():
            rel = p.relative_to(root).as_posix()
            z.write(p, unicodedata.normalize('NFC', rel))
PY

