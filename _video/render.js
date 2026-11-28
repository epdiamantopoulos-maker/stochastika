// Αποδίδει ένα πρότυπο HTML βίντεο (με συνάρτηση window.render(t)) καρέ-καρέ σε MP4 χωρίς ήχο.
// Χρήση: node _video/render.js <πρότυπο.html> <έξοδος.mp4> [διάρκεια σε s] [fps]
const {chromium} = require('playwright');
const {spawn} = require('child_process');
const path = require('path');
(async () => {
  const [html, out, dur = '31', fps = '30'] = process.argv.slice(2);
  const b = await chromium.launch();
  const p = await b.newPage({viewport: {width: 1080, height: 1920}, deviceScaleFactor: 1});
  await p.goto('file://' + path.resolve(html)); await p.waitForTimeout(500);
  const ff = spawn('ffmpeg', ['-v', 'error', '-y', '-f', 'image2pipe', '-framerate', fps, '-i', '-', '-c:v', 'libx264',
    '-preset', 'veryfast', '-crf', '20', '-pix_fmt', 'yuv420p', '-movflags', '+faststart', out], {stdio: ['pipe', 'ignore', 'inherit']});
  for (let i = 0; i < +fps * +dur; i++) {
    await p.evaluate(t => window.render(t), i / +fps);
    ff.stdin.write(await p.screenshot({type: 'jpeg', quality: 92}));
  }
  ff.stdin.end(); await new Promise(r => ff.on('close', r)); await b.close();
})();
