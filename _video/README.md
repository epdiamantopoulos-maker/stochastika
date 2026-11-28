# Βίντεο για TikTok / Reels / Shorts

Κάθετα βίντεο 1080×1920 (~30″) που προωθούν τα άρθρα. Ο φάκελος ξεκινά με `_`,
οπότε το Quarto δεν τον δημοσιεύει.

- `<slug>.html`: πρότυπο βίντεο για ένα άρθρο. Ορίζει `window.render(t)` που
  ζωγραφίζει το καρέ τη στιγμή `t` (σε δευτερόλεπτα). Ασφαλής ζώνη κειμένου:
  x 80–920, y 200–1450 (κάτω και δεξιά τα κουμπιά του TikTok).
- `render.js`: αποδίδει το πρότυπο σε MP4 χωρίς ήχο (Playwright + ffmpeg).
- `add_music.py`: προσθέτει μουσική από το `music/` με σταθερή «τυχαία»
  επιλογή ανά άρθρο, χωρίς ίδιο κομμάτι σε διαδοχικά άρθρα.
- `music/`: κομμάτια από το Pixabay (Pixabay Content License). Ο αριθμός στο
  τέλος του ονόματος είναι το ID του κομματιού στο Pixabay. Για νέα κομμάτια:
  μόνο χωρίς ένδειξη Content ID.

```sh
node _video/render.js _video/law-of-large-numbers.html /tmp/silent.mp4 31
python3 _video/add_music.py /tmp/silent.mp4 law-of-large-numbers stochastika-lln.mp4
```
