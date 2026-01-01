const puppeteer = require('puppeteer-core');

(async () => {
  const browser = await puppeteer.connect({
    browserWSEndpoint: 'ws://localhost:4040/chromium?stealth&--window-size=1920,1080',
  });

  const page = await browser.newPage();
  await page.goto('https://example.com');
  const title = await page.title();
  console.log('페이지 제목:', title);

  await browser.close();
})();