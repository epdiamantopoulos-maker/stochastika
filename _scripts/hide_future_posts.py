"""Κρύβει τα άρθρα με μελλοντική ημερομηνία πριν από το render.

Για κάθε el/posts/*/index.qmd και en/posts/*/index.qmd με `date` μεταγενέστερη
της σημερινής (ώρα Ελλάδας), προσθέτει `draft: true` στο front matter.
Με `draft-mode: gone` στο _quarto.yml, αυτά τα άρθρα δεν δημοσιεύονται καθόλου.

Τρέχει μόνο μέσα στο GitHub Action: οι αλλαγές δεν γίνονται ποτέ commit.
"""
import datetime as dt
import pathlib
import re
import sys
from zoneinfo import ZoneInfo

today = dt.datetime.now(ZoneInfo("Europe/Athens")).date()
if len(sys.argv) > 1:  # π.χ. python hide_future_posts.py 2026-12-20 για δοκιμή
    today = dt.date.fromisoformat(sys.argv[1])

root = pathlib.Path(__file__).resolve().parent.parent
hidden, shown = [], []
for f in sorted(root.glob("*/posts/*/index.qmd")):
    text = f.read_text(encoding="utf-8")
    m = re.match(r"^---\n(.*?)\n---\n", text, flags=re.S)
    if not m:
        continue
    d = re.search(r"^date:\s*\"?(\d{4}-\d{2}-\d{2})", m.group(1), flags=re.M)
    if not d:
        continue
    rel = f.relative_to(root)
    if dt.date.fromisoformat(d.group(1)) > today:
        if not re.search(r"^draft:\s*true", m.group(1), flags=re.M):
            f.write_text("---\ndraft: true\n" + text[4:], encoding="utf-8")
        hidden.append(f"{rel} ({d.group(1)})")
    else:
        shown.append(f"{rel} ({d.group(1)})")

print(f"Σήμερα: {today}")
print(f"Δημοσιεύονται: {len(shown)}")
for s in shown:
    print("  +", s)
print(f"Κρύβονται (μελλοντικά): {len(hidden)}")
for h in hidden:
    print("  -", h)
