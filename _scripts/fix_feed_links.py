"""Μετατρέπει τους σχετικούς συνδέσμους των ροών RSS σε απόλυτους.

Το Quarto γράφει στο πλήρες κείμενο της ροής (π.χ. en/r-feed.xml για το
R-bloggers) συνδέσμους όπως "../../../en/posts/x/index.html", σχετικούς με
τη σελίδα του άρθρου. Οι συλλέκτες RSS τους διαβάζουν σχετικά με τη ροή και
καταλήγουν σε λάθος διευθύνσεις. Τρέχει ως post-render (βλ. _quarto.yml).
"""
import os
import pathlib
import re

SITE = "https://www.stochastika.com/"
out = pathlib.Path(os.environ.get("QUARTO_PROJECT_OUTPUT_DIR", "_site"))
for f in out.glob("*/*.xml"):
    text = f.read_text(encoding="utf-8")
    new = re.sub(r'(href|src)="(?:\.\./){3}', lambda m: f'{m.group(1)}="{SITE}', text)
    if new != text:
        f.write_text(new, encoding="utf-8")
        print(f"fix_feed_links: {f}")
