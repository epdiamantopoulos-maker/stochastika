"""Προσθέτει μουσική υπόκρουση από το _video/music σε ένα βίντεο χωρίς ήχο.

Η επιλογή είναι «τυχαία» αλλά σταθερή: τα κομμάτια ανακατεύονται μία φορά
(σταθερός σπόρος) και τα άρθρα, με τη σειρά της ημερομηνίας τους, τα
παίρνουν κυκλικά. Έτσι κάθε άρθρο έχει πάντα την ίδια μουσική και δύο
διαδοχικά άρθρα δεν έχουν ποτέ την ίδια. Κομμάτια μικρότερα από το βίντεο
δεν χρησιμοποιούνται.

Χρήση: python3 _video/add_music.py <βίντεο.mp4> <slug> <έξοδος.mp4>
"""
import pathlib
import random
import re
import subprocess
import sys

ROOT = pathlib.Path(__file__).resolve().parent.parent
video, slug, out = sys.argv[1:4]


def duration(f):
    r = subprocess.run(["ffprobe", "-v", "error", "-show_entries", "format=duration", "-of", "csv=p=0", str(f)],
                       capture_output=True, text=True, check=True)
    return float(r.stdout)


tracks = sorted((ROOT / "_video" / "music").glob("*.mp3"))
random.Random(2026).shuffle(tracks)
dates = {}
for q in (ROOT / "el" / "posts").glob("*/index.qmd"):
    m = re.search(r"^date:\s*(\S+)", q.read_text(encoding="utf-8"), re.M)
    dates[q.parent.name] = m.group(1) if m else "9999"
order = sorted(dates, key=lambda s: (dates[s], s))
D = duration(video)
k = order.index(slug) if slug in order else 0
# κυκλικά μόνο ανάμεσα στα κομμάτια που φτάνουν για όλο το βίντεο, ώστε
# δύο διαδοχικά άρθρα να μην πάρουν ποτέ το ίδιο
eligible = [t for t in tracks if duration(t) >= D]
track = eligible[k % len(eligible)]
print(f"add_music: {slug} -> {track.name}")
fade_out = max(0.0, D - 2.5)
af = (f"[1:a]atrim=0:{D},asetpts=N/SR/TB,afade=t=in:d=1,afade=t=out:st={fade_out}:d=2.5,"
      f"loudnorm=I=-20:TP=-2:LRA=11[a]")
subprocess.run(["ffmpeg", "-v", "error", "-y", "-i", video, "-i", str(track), "-filter_complex", af,
                "-map", "0:v", "-map", "[a]", "-c:v", "copy", "-c:a", "aac", "-b:a", "160k", "-shortest",
                "-movflags", "+faststart", out], check=True)
