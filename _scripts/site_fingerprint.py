"""Υπολογίζει ένα «αποτύπωμα» του ορατού περιεχομένου του site.

Τρέχει μετά το hide_future_posts.py. Παίρνει όλα τα αρχεία του αποθετηρίου
(git ls-files), παραλείπει τους φακέλους των άρθρων που έχουν `draft: true`
(μελλοντικά άρθρα) και τα αρχεία που δεν επηρεάζουν το site (.github/,
_scripts/, αρχεία .md στη ρίζα), και επιστρέφει ένα SHA-256 των υπολοίπων.

Το workflow της δημοσίευσης συγκρίνει αυτό το αποτύπωμα με εκείνο της
τελευταίας δημοσίευσης (αρχείο deploy-fingerprint.txt στο live site ή, αν
δεν υπάρχει ακόμα, _scripts/initial-fingerprint.txt) και
δημοσιεύει μόνο όταν διαφέρουν. Έτσι ένα merge με άρθρα μελλοντικής
ημερομηνίας, ή μια μέρα χωρίς νέο άρθρο, δεν καταναλώνει credits της Netlify.
"""
import hashlib
import pathlib
import re
import subprocess

root = pathlib.Path(__file__).resolve().parent.parent
files = subprocess.run(["git", "ls-files"], cwd=root, capture_output=True, text=True, check=True).stdout.split()

# φάκελοι άρθρων που θα κρυφτούν (draft: true μετά το hide_future_posts.py)
hidden_dirs = set()
for f in root.glob("*/posts/*/index.qmd"):
    m = re.match(r"^---\n(.*?)\n---\n", f.read_text(encoding="utf-8"), flags=re.S)
    if m and re.search(r"^draft:\s*true", m.group(1), flags=re.M):
        hidden_dirs.add(f.parent.relative_to(root).as_posix() + "/")

h = hashlib.sha256()
for rel in sorted(files):
    if rel.startswith((".github/", "_scripts/")) or (("/" not in rel) and rel.endswith(".md")):
        continue
    if any(rel.startswith(d) for d in hidden_dirs):
        continue
    h.update(rel.encode())
    h.update(b"\0")
    h.update((root / rel).read_bytes())
    h.update(b"\0")
print(h.hexdigest())
