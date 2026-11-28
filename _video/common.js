// Κοινά εργαλεία των βίντεο: προβλέψιμη τυχαιότητα, ομαλές μεταβάσεις, σκηνές, κάρτα τέλους.
function rng(seed) { return function () { seed |= 0; seed = seed + 0x6D2B79F5 | 0; let t = Math.imul(seed ^ seed >>> 15, 1 | seed); t = t + Math.imul(t ^ t >>> 7, 61 | t) ^ t; return ((t ^ t >>> 14) >>> 0) / 4294967296; }; }
const ease = x => x < 0 ? 0 : x > 1 ? 1 : x * x * (3 - 2 * x);
const fadeIn = (t, a, d = 0.4) => ease((t - a) / d);
// scenes: [[id, αρχή, τέλος], ...]· κάθε σκηνή μπαίνει και βγαίνει με ομαλή μετάβαση
function showScenes(t, scenes) {
  for (const [id, a, b] of scenes) {
    const el = document.getElementById(id);
    el.style.opacity = Math.min(ease((t - a) / 0.4), ease((b - t) / 0.4));
    el.style.transform = `translateY(${(1 - ease((t - a) / 0.5)) * 30}px)`;
  }
}
// κάρτα τέλους με το λογότυπο· line = η φράση πάνω από το stochastika.com
function endCard(id, line) {
  const d = document.createElement("div"); d.className = "scene"; d.id = id;
  d.innerHTML = `<svg width="260" height="260" viewBox="0 0 64 64" style="position:absolute;left:80px;top:380px">
      <circle cx="32" cy="32" r="30" fill="#4e79a7"/>
      <text x="32" y="45" text-anchor="middle" font-family="Liberation Serif, serif" font-size="38" fill="#fff">Ω</text>
      <circle cx="50" cy="15" r="5" fill="#f28e2b"/></svg>
    <div class="big" style="top:700px">Stochastika</div>
    <div class="mid" style="top:860px">${line}</div>
    <div class="mid hl" style="top:1080px;font-weight:800">stochastika.com</div>`;
  document.body.appendChild(d);
}
