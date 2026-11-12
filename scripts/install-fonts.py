#!/usr/bin/env python3
"""将模板使用的字体下载到 .fonts/。只需要 Python 标准库。"""
import argparse
import io
import json
import re
import tarfile
from pathlib import Path
from urllib.request import urlopen

ADOBE = "https://raw.githubusercontent.com/adobe-fonts/source-han-serif/release/"
UKAI = "https://deb.debian.org/debian/pool/main/f/fonts-arphic-ukai/"
LIBERATION = "https://api.github.com/repos/liberationfonts/liberation-fonts/releases/latest"


def fetch(url):
    with urlopen(url, timeout=60) as response:
        return response.read()


def save(directory, name, data):
    path = directory / name
    path.parent.mkdir(parents=True, exist_ok=True)
    temporary = path.with_suffix(path.suffix + ".tmp")
    temporary.write_bytes(data)
    temporary.replace(path)


def download(directory, name, url, force):
    if force or not (directory / name).is_file():
        save(directory, name, fetch(url))
    print(f"已准备：{name}")


def liberation_url():
    release = json.loads(fetch(LIBERATION))
    for asset in release.get("assets", []):
        if "ttf" in asset["name"] and asset["name"].endswith(".tar.gz"):
            return asset["browser_download_url"]
    # 部分发布把字体下载链接放在发布说明中。
    match = re.search(r"https://github\.com/[^\s)]+/liberation-fonts-ttf-[^\s)]+\.tar\.gz", release.get("body", ""))
    if not match:
        raise RuntimeError("Liberation Serif 发布页面未找到字体下载链接")
    return match.group()


def ukai_url():
    # 从下载目录中选择最新的字体压缩包。
    links = re.findall(r'href="([^"]+\.orig\.tar\.(?:gz|bz2|xz))"', fetch(UKAI).decode())
    if not links:
        raise RuntimeError("文鼎楷体下载页面未找到字体压缩包")
    latest = max(links, key=lambda name: tuple(map(int, re.findall(r"\d+", name))))
    return UKAI + latest


def unpack(directory, url, fonts):
    files = {}
    with tarfile.open(fileobj=io.BytesIO(fetch(url)), mode="r:*") as archive:
        for member in archive:
            if not member.isfile():
                continue
            name = Path(member.name).name
            if name in fonts:
                files[name] = archive.extractfile(member).read()
    if set(files) != set(fonts):
        raise RuntimeError("字体压缩包缺少所需字体")
    for name, data in files.items():
        save(directory, name, data)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--directory", type=Path, default=Path(__file__).resolve().parent.parent / ".fonts")
    parser.add_argument("--force", action="store_true", help="重新下载字体")
    args = parser.parse_args()
    directory = args.directory
    for weight in ("Regular", "Bold"):
        name = f"SourceHanSerifCN-{weight}.otf"
        download(directory, name, ADOBE + "SubsetOTF/CN/" + name, args.force)
    fonts = tuple(f"LiberationSerif-{weight}.ttf" for weight in ("Regular", "Bold", "Italic", "BoldItalic"))
    if args.force or not all((directory / name).is_file() for name in fonts):
        unpack(directory, liberation_url(), fonts)
    if args.force or not (directory / "ukai.ttc").is_file():
        unpack(directory, ukai_url(), ("ukai.ttc",))
    print(f"字体已准备好：{directory}")


if __name__ == "__main__":
    main()
