#!/usr/bin/env python3
import argparse
import json
import os
import time
import urllib.error
import urllib.parse
import urllib.request
from datetime import datetime, timezone


BASE_DIR = os.path.dirname(os.path.abspath(__file__))
AUTH_FILE = os.path.join(BASE_DIR, ".tmdb-auth.json")
ENV_FILE = os.path.join(BASE_DIR, ".env")
API3 = "https://api.themoviedb.org/3"
API4 = "https://api.themoviedb.org/4"
IMAGE_BASE = "https://image.tmdb.org/t/p/w300_and_h450_bestv2"
LOGO_BASE = "https://image.tmdb.org/t/p/original"
POSTER_DIR = os.path.join(BASE_DIR, "images", "tmdb")
PROVIDER_LOGO_DIR = os.path.join(BASE_DIR, "images", "providers")
PROGRESS_LINE_LENGTH = 0


def load_dotenv(path):
    data = {}
    if not os.path.exists(path):
        return data
    with open(path, "r", encoding="utf-8") as stream:
        for line in stream:
            line = line.strip()
            if not line or line.startswith("#") or "=" not in line:
                continue
            key, value = line.split("=", 1)
            data[key.strip()] = value.strip().strip("'\"")
    return data


def load_json(path, fallback):
    if not os.path.exists(path):
        return fallback
    with open(path, "r", encoding="utf-8") as stream:
        return json.load(stream)


def save_json(path, data):
    with open(path, "w", encoding="utf-8") as stream:
        json.dump(data, stream, ensure_ascii=False, indent=2)
        stream.write("\n")


def progress_bar(label, current, total, width=32):
    global PROGRESS_LINE_LENGTH
    if total <= 0:
        line = f"{label}: {current}"
        padding = " " * max(0, PROGRESS_LINE_LENGTH - len(line))
        print(f"\r{line}{padding}")
        PROGRESS_LINE_LENGTH = 0
        return
    current = min(current, total)
    filled = round(width * current / total)
    bar = "#" * filled + "-" * (width - filled)
    line = f"{label}: [{bar}] {current}/{total}"
    padding = " " * max(0, PROGRESS_LINE_LENGTH - len(line))
    if current >= total:
        print(f"\r{line}{padding}")
        PROGRESS_LINE_LENGTH = 0
    else:
        print(f"\r{line}{padding}", end="", flush=True)
        PROGRESS_LINE_LENGTH = len(line)


def bearer_token(auth_required=False):
    env = load_dotenv(ENV_FILE)
    auth = load_json(AUTH_FILE, {})
    token = auth.get("access_token") if auth_required else None
    token = token or env.get("TMDB_APIKEY") or os.environ.get("TMDB_APIKEY")
    if not token:
        source = ".tmdb-auth.json" if auth_required else ".env or TMDB_APIKEY"
        raise SystemExit(f"TMDB token missing in {source}.")
    return token


def auth_data():
    auth = load_json(AUTH_FILE, {})
    if not auth.get("access_token") or not auth.get("account_id"):
        raise SystemExit("Run './tmdb-local.py auth' first.")
    return auth


def request_json(url, token, method="GET", payload=None, retry=3):
    body = None
    if payload is not None:
        body = json.dumps(payload).encode("utf-8")
    headers = {
        "Accept": "application/json",
        "Content-Type": "application/json",
        "Authorization": f"Bearer {token}",
    }
    req = urllib.request.Request(url, data=body, headers=headers, method=method)

    for attempt in range(retry + 1):
        try:
            with urllib.request.urlopen(req, timeout=60) as response:
                return json.loads(response.read().decode("utf-8"))
        except urllib.error.HTTPError as exc:
            if exc.code == 429 and attempt < retry:
                time.sleep(10 * (attempt + 1))
                continue
            message = exc.read().decode("utf-8", errors="replace")
            raise SystemExit(f"TMDB request failed ({exc.code}): {url}\n{message}")
        except urllib.error.URLError as exc:
            if attempt < retry:
                time.sleep(5 * (attempt + 1))
                continue
            raise SystemExit(f"TMDB request failed: {url}\n{exc}")


def download_file(url, output_path, retry=3):
    os.makedirs(os.path.dirname(output_path), exist_ok=True)
    for attempt in range(retry + 1):
        try:
            with urllib.request.urlopen(url, timeout=60) as response:
                with open(output_path, "wb") as stream:
                    stream.write(response.read())
            return True
        except urllib.error.URLError as exc:
            if attempt < retry:
                time.sleep(5 * (attempt + 1))
                continue
            print(f"\nWarning: download failed: {url}\n{exc}")
            return False


def command_auth(_args):
    read_token = bearer_token()
    data = request_json(f"{API4}/auth/request_token", read_token, method="POST", payload={})
    request_token = data.get("request_token")
    if not request_token:
        raise SystemExit("TMDB did not return a request_token.")

    print("Open this URL and allow access:")
    print(f"https://www.themoviedb.org/auth/access?request_token={request_token}")
    input("Press Enter after confirming access in the browser...")

    data = request_json(
        f"{API4}/auth/access_token",
        read_token,
        method="POST",
        payload={"request_token": request_token},
    )
    if not data.get("access_token") or not data.get("account_id"):
        raise SystemExit("TMDB did not return access_token/account_id.")

    save_json(AUTH_FILE, {
        "access_token": data["access_token"],
        "account_id": data["account_id"],
        "created_at": datetime.now(timezone.utc).isoformat(),
    })
    print(f"Saved account auth to {AUTH_FILE}")


def title_and_year(item):
    title = item.get("title") or item.get("name") or item.get("original_name") or ""
    date = item.get("release_date") or item.get("first_air_date") or ""
    try:
        year = int(date[:4]) if date else 0
    except ValueError:
        year = 0
    return title, year


def poster_cache_path(media_type, tmdb_id):
    return os.path.join(POSTER_DIR, f"{media_type}-{tmdb_id}.jpg")


def cache_poster(item, media_type, tmdb_id):
    poster = item.get("poster_path") or ""
    if not poster:
        return

    output_path = poster_cache_path(media_type, tmdb_id)
    if os.path.exists(output_path):
        return

    download_file(f"{IMAGE_BASE}{poster}", output_path)


def watchlist_entity(item, media_type):
    title, year = title_and_year(item)
    tmdb_id = int(item["id"])
    cache_poster(item, media_type, tmdb_id)

    return {
        "id": tmdb_id,
        "title": title,
        "year": year,
        "url": f"https://themoviedb.org/{media_type}/{tmdb_id}",
    }


def fetch_watchlist(media_type, language):
    auth = auth_data()
    token = auth["access_token"]
    account_id = auth["account_id"]
    page = 1
    items = []

    while True:
        query = urllib.parse.urlencode({"page": page, "language": language})
        url = f"{API4}/account/{account_id}/{media_type}/watchlist?{query}"
        data = request_json(url, token)
        items.extend(data.get("results", []))
        total_pages = int(data.get("total_pages", 1) or 1)
        total_results = int(data.get("total_results", 0) or 0)
        if total_results > 0:
            progress_bar(f"Fetch {media_type} watchlist", min(len(items), total_results), total_results)
        else:
            progress_bar(f"Fetch {media_type} pages", page, total_pages)
        if page >= total_pages:
            break
        page += 1
    return items


def command_watchlist(args):
    output = os.path.abspath(args.output)
    movie_items = fetch_watchlist("movie", args.language)
    tv_items = fetch_watchlist("tv", args.language)

    movies = []
    tvs = []
    total = len(movie_items) + len(tv_items)
    current = 0
    for item in movie_items:
        movies.append(watchlist_entity(item, "movie"))
        current += 1
        progress_bar("Cache posters", current, total)
    for item in tv_items:
        tvs.append(watchlist_entity(item, "tv"))
        current += 1
        progress_bar("Cache posters", current, total)

    movies.sort(key=lambda item: (item.get("year") or 999999, item.get("title") or ""))
    tvs.sort(key=lambda item: (item.get("year") or 999999, item.get("title") or ""))

    data = {
        "movies": movies,
        "tvs": tvs,
    }
    save_json(output, data)
    print(f"Saved {len(movies)} movies and {len(tvs)} tv shows to {output}")


def provider_key(media_type, tmdb_id):
    return f"{media_type}-{tmdb_id}"


def provider_logo_cache_path(provider):
    provider_id = provider.get("provider_id")
    logo_path = provider.get("logo_path") or ""
    if not provider_id or not logo_path:
        return "", ""

    extension = os.path.splitext(urllib.parse.urlparse(logo_path).path)[1] or ".png"
    filename = f"provider-{provider_id}{extension}"
    return os.path.join(PROVIDER_LOGO_DIR, filename), f"images/providers/{filename}"


def cache_provider_logo(provider):
    output_path, relative_path = provider_logo_cache_path(provider)
    if not output_path:
        return ""
    if os.path.exists(output_path):
        return relative_path

    logo_path = provider.get("logo_path") or ""
    if download_file(f"{LOGO_BASE}{logo_path}", output_path):
        return relative_path
    return ""


def normalize_providers(data, region, direct_links=None):
    result = data.get("results", {}).get(region, {})
    normalized = {
        "link": result.get("link", ""),
        "free": [],
        "ads": [],
        "flatrate": [],
        "rent": [],
        "buy": [],
    }
    for group in ("free", "ads", "flatrate", "rent", "buy"):
        for provider in result.get(group, []) or []:
            normalized[group].append({
                "id": provider.get("provider_id"),
                "name": provider.get("provider_name"),
                "logo": provider.get("logo_path"),
                "logoFile": cache_provider_logo(provider),
                "displayPriority": provider.get("display_priority"),
            })
        normalized[group].sort(key=lambda item: (item.get("displayPriority") or 9999, item.get("name") or ""))
    return normalized


def iter_tmdb_items(movies_data):
    for category, media_type in (("movies", "movie"), ("tvs", "tv")):
        for item in movies_data.get(category, []):
            tmdb_id = item.get("id")
            if tmdb_id:
                yield media_type, int(tmdb_id), item.get("title", "")


def command_providers(args):
    movies_data = load_json(os.path.abspath(args.input), {"movies": [], "tvs": []})
    token = auth_data()["access_token"]
    output = os.path.abspath(args.output)
    providers = load_json(output, {"region": args.region, "items": {}})
    providers["region"] = args.region
    providers["updatedAt"] = datetime.now(timezone.utc).isoformat()
    providers.setdefault("items", {})

    count = 0
    items = list(iter_tmdb_items(movies_data))
    total = len(items)
    for media_type, tmdb_id, title in items:
        key = provider_key(media_type, tmdb_id)
        url = f"{API3}/{media_type}/{tmdb_id}/watch/providers"
        data = request_json(url, token)
        providers["items"][key] = normalize_providers(data, args.region)
        count += 1
        progress_bar("Update providers", count, total)
        if args.verbose:
            print(f"Updated providers for {key} {title}")

    save_json(output, providers)
    print(f"Saved streaming providers for {count} titles to {output}")


def main():
    parser = argparse.ArgumentParser(description="Small local TMDB watchlist helper.")
    sub = parser.add_subparsers(dest="command", required=True)

    auth = sub.add_parser("auth", help="Create local TMDB account access token.")
    auth.set_defaults(func=command_auth)

    watchlist = sub.add_parser("watchlist", help="Download TMDB account watchlist to movies.json.")
    watchlist.add_argument("-o", "--output", default=os.path.join(BASE_DIR, "movies.json"))
    watchlist.add_argument("--language", default="de-DE")
    watchlist.set_defaults(func=command_watchlist)

    providers = sub.add_parser("providers", help="Update separate streaming provider JSON.")
    providers.add_argument("-i", "--input", default=os.path.join(BASE_DIR, "movies.json"))
    providers.add_argument("-o", "--output", default=os.path.join(BASE_DIR, "providers.json"))
    providers.add_argument("--region", default="DE")
    providers.add_argument("-v", "--verbose", action="store_true")
    providers.set_defaults(func=command_providers)

    args = parser.parse_args()
    args.func(args)


if __name__ == "__main__":
    main()
