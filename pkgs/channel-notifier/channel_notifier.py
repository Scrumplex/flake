from datetime import datetime, timezone
from json import dump, dumps, load
from os import environ
from pathlib import Path
from prometheus_api_client import PrometheusConnect
from typing import Tuple
from sys import exit
from urllib.request import Request, urlopen


def commit_url(rev: str):
    return f"https://github.com/NixOS/nixpkgs/commit/{rev}"


def fetch_latest_revision(url: str, channel: str) -> str | None:
    prom = PrometheusConnect(url)

    metrics = prom.get_current_metric_value(
        "channel_revision", label_config={"channel": channel}
    )
    latest_metric = metrics[-1]

    return latest_metric.get("metric", {}).get("revision")


def read_cached_revision(data_path: Path) -> Tuple[str, datetime] | None:
    if not data_path.exists():
        return None

    with open(data_path, "r") as f:
        data = load(f)
        revision: str | None = data.get("revision")
        timestamp: str | None = data.get("timestamp")
        if not revision or not timestamp:
            return None
        return revision, datetime.fromisoformat(timestamp)


def write_cache(data_path: Path, revision: str, timestamp: datetime):
    with open(data_path, "w") as f:
        data = {"revision": revision, "timestamp": timestamp.isoformat()}
        dump(data, f)


def send_webhook(webhook_url: str, content: str):
    payload = {"username": "NixOS Notifier", "content": content}
    encoded = dumps(payload).encode("utf-8")
    req = Request(
        webhook_url,
        data=encoded,
        headers={"User-Agent": "Channel-Notifier/1.0.0 contact@scrumplex.net"},
    )
    req.add_header("Content-Type", "application/json; charset=utf-8")

    print(webhook_url)

    urlopen(req)


def main():
    data_path = Path(environ.get("STATE_DIRECTORY", ".")) / "cached.json"
    webhook_url = environ.get("WEBHOOK_URL", "")
    channel = environ.get("NIXOS_CHANNEL", "nixos-unstable")

    latest_revision = fetch_latest_revision("https://prometheus.nixos.org", channel)
    now = datetime.now(tz=timezone.utc)

    if not latest_revision:
        return 1

    cached = read_cached_revision(data_path)

    if cached:
        cached_revision, _ = cached

        if cached_revision != latest_revision:
            rev_url = commit_url(latest_revision)

            print(f"Sending webhook for new {channel} revision {latest_revision}")
            send_webhook(
                webhook_url,
                f"# Nixpkgs `{channel}` Channel Update\nThe channel {channel} has been updated to revision [{latest_revision}](<{rev_url}>).\n[**NixOS Status**](https://status.nixos.org/)",
            )

    write_cache(data_path, latest_revision, now)
    return 0


if __name__ == "__main__":
    exit(main())
