#!/usr/bin/python3
# Vendored community workaround from:
# https://github.com/niri-wm/niri/discussions/1599
# https://gist.github.com/DerEchteJoghurt/9cabbcf8eb7b4af25e4519feda302cb2
# Revision: b088b7a319473793f5901d7d0cd2aba37635c3a8
# Local changes: Zen rule, reject missing match fields, check IPC replies,
# and reset match state when a window stops matching.
"""
Like open-float, but dynamically. Floats a window when it matches the rules.
Some windows don't have the right title and app-id when they open, and only set
them afterward. This script is like open-float for those windows.
Usage: fill in the RULES array below, then run the script.
"""

from dataclasses import dataclass, field
import json
import os
import re
import sys
from socket import AF_UNIX, SHUT_WR, socket


@dataclass(kw_only=True)
class Match:
    title: str | None = None
    app_id: str | None = None

    def matches(self, window):
        if self.title is None and self.app_id is None:
            return False

        matched = True

        if self.title is not None:
            if window.get("title") is None:
                return False
            matched &= re.search(self.title, window.get("title") or "") is not None
        if self.app_id is not None:
            if window.get("app_id") is None:
                return False
            matched &= re.search(self.app_id, window.get("app_id") or "") is not None

        return matched


@dataclass
class Rule:
    match: list[Match] = field(default_factory=list)
    exclude: list[Match] = field(default_factory=list)
    width: int = 0
    height: int = 0
    centered: bool = False

    def matches(self, window):
        if len(self.match) > 0 and not any(m.matches(window) for m in self.match):
            return False
        if any(m.matches(window) for m in self.exclude):
            return False

        return True


# Write your rules here. One Rule() = one window-rule {}.
RULES = [
    Rule(
        [Match(title=r"^Extension: \(Bitwarden Password Manager\)", app_id="^zen-beta$")],
        width=420,
        height=600,
        centered=True,
    ),
]


if len(RULES) == 0:
    print("fill in the RULES list, then run the script")
    exit()


niri_socket = socket(AF_UNIX)
niri_socket.connect(os.environ["NIRI_SOCKET"])
file = niri_socket.makefile("rw")

_ = file.write('"EventStream"')
file.flush()
niri_socket.shutdown(SHUT_WR)

windows = {}


def send(request):
    with socket(AF_UNIX) as niri_socket:
        niri_socket.settimeout(5)
        niri_socket.connect(os.environ["NIRI_SOCKET"])
        with niri_socket.makefile("rw") as reply_file:
            reply_file.write(json.dumps(request) + "\n")
            reply_file.flush()
            reply = json.loads(reply_file.readline())
        if "Err" in reply:
            raise RuntimeError(reply["Err"])
        if "Ok" not in reply:
            raise RuntimeError(f"unexpected IPC reply: {reply!r}")


def float(id: int):
    send({"Action": {"MoveWindowToFloating": {"id": id}}})

def set_height(id: int, height: int):
    send({"Action": {"SetWindowHeight":
                     {"id": id, "change": {"SetFixed": height}}}})

def set_width(id: int, width: int):
    send({"Action": {"SetWindowWidth":
                     {"id": id, "change": {"SetFixed": width}}}})

def set_centered(id: int, width: int, height: int):
    # move window to center of the screen
    send({"Action": {"MoveFloatingWindow":
                     {"id": id,
                      "x": {"SetProportion": 50.0},
                      "y": {"SetProportion": 50.0}}}})

    # adjust for top left origin
    send({"Action": {"MoveFloatingWindow":
                     {"id": id,
                      "x": {"AdjustFixed": -(width / 2)},
                      "y": {"AdjustFixed": -(height / 2)}}}})

def update_matched(win):
    win["matched"] = False
    matched_before = windows.get(win["id"], {}).get("matched", False)
    for r in RULES:
        matched = r.matches(win)
        if matched:
            # first match wins
            win["matched"] = matched
            break
    if win["matched"] and not matched_before:
        try:
            float(win["id"])
            if r.height != 0:
                set_height(win["id"], r.height)
            if r.width != 0:
                set_width(win["id"], r.width)
            if r.centered:
                set_centered(win["id"], r.width, r.height)
        except RuntimeError as error:
            # Leave it eligible for a retry on the next window update.
            win["matched"] = False
            print(f"could not float window {win['id']}: {error}", file=sys.stderr)
        else:
            print(f"floating title={win['title']}, app_id={win['app_id']}")


for line in file:
    event = json.loads(line)

    if changed := event.get("WindowsChanged"):
        for win in changed["windows"]:
            update_matched(win)
        windows = {win["id"]: win for win in changed["windows"]}
    elif changed := event.get("WindowOpenedOrChanged"):
        win = changed["window"]
        update_matched(win)
        windows[win["id"]] = win
    elif changed := event.get("WindowClosed"):
        del windows[changed["id"]]
