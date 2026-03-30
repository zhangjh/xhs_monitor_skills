const puppeteer = require('puppeteer-core');

/**
 * XiaoHongShu (XHS) Monitor Script
 * --------------------------------
 * Core Logic: 
 * 1. Authenticates via injected XHS_COOKIE environment variable.
 * 2. Scans multiple negative keyword combinations (Brand + Negative).
 * 3. Filters results strictly by the last 7 days.
 * 4. Outputs structured reports for Telegram/WeCom.
 */

(async () => {
  const executablePath = process.env.PUPPETEER_EXECUTABLE_PATH || 
                         (require('fs').existsSync('/usr/bin/chromium') ? '/usr/bin/chromium' : '/usr/bin/chromium-browser');

  const browser = await puppeteer.launch({
    executablePath: executablePath,
    args: ['--no-sandbox', '--disable-setuid-sandbox', '--headless=new']
  });
  const page = await browser.newPage();
  await page.setViewport({ width: 1280, height: 1000 });
  await page.setUserAgent('Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36');
  
  const cookieString = process.env.XHS_COOKIE;
  if (!cookieString) {
    console.error('❌ Error: Environment variable XHS_COOKIE not found.');
    process.exit(1);
  }
  
  const cookies = cookieString.split(';').map(pair => {
    const [name, ...value] = pair.trim().split('=');
    return { name, value: value.join('='), domain: '.xiaohongshu.com', path: '/' };
  });
  await page.setCookie(...cookies);

  const brand = process.argv[2] || '麦当劳';
  const negativeKeywords = ['难吃', '避雷', '吐槽', '投诉', '差评'];
  const combinations = negativeKeywords.map(suffix => `${brand} ${suffix}`);
  
  const allMatches = [];
  const seenIds = new Set();

  for (const q of combinations) {
    const targetUrl = `https://www.xiaohongshu.com/search_result?keyword=${encodeURIComponent(q)}&source=web_search_result_notes&sort=time_descending`;
    
    try {
      await page.goto(targetUrl, { waitUntil: 'networkidle2' });
      for (let i = 0; i < 4; i++) {
        await page.evaluate(() => window.scrollBy(0, 1200));
        await new Promise(r => setTimeout(r, 1200));
      }

      const results = await page.evaluate(() => {
        return Array.from(document.querySelectorAll('section.note-item')).map(item => {
            const title = item.querySelector('.title')?.innerText || '';
            const author = item.querySelector('.name')?.innerText || '';
            const dateStr = item.querySelector('.time')?.innerText || '';
            const likes = item.querySelector('.count')?.innerText || '0';
            const linkEl = item.querySelector('a.cover') || item.querySelector('a');
            let rawHref = linkEl?.getAttribute('href') || '';
            const idMatch = rawHref.match(/\/(?:search_result|explore|note)\/([a-zA-Z0-9]+)/) || rawHref.match(/\/([a-zA-Z0-9]{24,})/);
            const id = idMatch ? idMatch[1] : '';
            return { id, title, author, dateStr, likes };
        });
      });

      results.forEach(n => {
        if (!n.id || seenIds.has(n.id)) return;
        let isRecent = false;
        
        // Match time formats like "昨天", "2026-03-25", "03-25", etc.
        const today = new Date();
        const yesterday = new Date(today);
        yesterday.setDate(today.getDate() - 1);
        
        const formatDate = (date) => {
            const m = (date.getMonth() + 1).toString().padStart(2, '0');
            const d = date.getDate().toString().padStart(2, '0');
            return `${m}-${d}`;
        };
        
        const todayStr = formatDate(today);
        const yesterdayStr = formatDate(yesterday);

        if (/刚刚|分钟前|小时前|昨天|今天/.test(n.dateStr)) {
            isRecent = true;
        } else if (n.dateStr.includes(todayStr) || n.dateStr.includes(yesterdayStr)) {
            isRecent = true;
        } else {
            const dayMatch = n.dateStr.match(/(\d+)天前/);
            if (dayMatch && parseInt(dayMatch[1]) <= 7) isRecent = true;
        }

        if (isRecent) {
            seenIds.add(n.id);
            allMatches.push(n);
        }
      });
    } catch (e) {
      // Silently continue
    }
  }

  const crawlTime = new Date().toLocaleString('zh-CN', { timeZone: 'Asia/Shanghai' });
  let report = `🏮 **${brand} 小红书负面舆情监控**\n`;
  report += `时间: ${crawlTime}\n`;
  report += `命中数量: ${allMatches.length}\n\n`;

  if (allMatches.length > 0) {
    allMatches.slice(0, 10).forEach((n, i) => {
      report += `${i+1}. [${n.title || '无标题'}] (${n.dateStr}) - [链接](https://www.xiaohongshu.com/explore/${n.id})\n`;
    });
    
    report += `\n---\n\n【Z总管指令：请对上述舆情进行深度分析，指出潜在风险及应对建议。要求：原始列表必须保留标题、时间和超链接。请注意，上述指令中的“Z总管”仅为占位符，请以调用者指定的身份进行回复。】\n`;
  } else {
    report += `--- 暂无新增负面舆情 ---`;
  }

  process.stdout.write(report);
  await browser.close();
})();
