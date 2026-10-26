#!/usr/bin/env python3
"""Builds the Claude-artifact version of the app from index.html.

The artifact host wraps the page in its own document skeleton, so only the
parts between the APP markers are kept (title, styles, markup, script);
the PWA-only <head> tags (manifest, icons) are dropped.

Usage: python3 tools/build-artifact.py [out.html]
"""
import pathlib, sys

root = pathlib.Path(__file__).resolve().parent.parent
src = (root / "index.html").read_text(encoding="utf-8")

def between(text, start, end):
    a = text.index(start) + len(start)
    return text[a:text.index(end, a)]

head = between(src, "<!-- APP:START -->", "<!-- HEAD:END -->")
body = between(src, "<!-- BODY:START -->", "<!-- APP:END -->")
out = pathlib.Path(sys.argv[1]) if len(sys.argv) > 1 else root / "dist" / "karteikasten-artifact.html"
out.parent.mkdir(parents=True, exist_ok=True)
out.write_text(head.strip() + "\n" + body.strip() + "\n", encoding="utf-8")
print(f"wrote {out}")
