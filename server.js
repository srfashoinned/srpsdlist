const http = require('http');
const fs = require('fs');
const path = require('path');

const folder = 'C:/Users/SR/Desktop/demmo';

http.createServer((req, res) => {

const items = path.join(folder, 'items.json');
const stock = path.join(folder, 'stock.csv');

const itemsStat = fs.existsSync(items) ? fs.statSync(items) : null;
const stockStat = fs.existsSync(stock) ? fs.statSync(stock) : null;

let latestTime = 0;

if (itemsStat) latestTime = Math.max(latestTime, itemsStat.mtimeMs);
if (stockStat) latestTime = Math.max(latestTime, stockStat.mtimeMs);

const ageSeconds = Math.floor((Date.now() - latestTime) / 1000);

const status = ageSeconds < 120
? 'RUNNING'
: 'NO RECENT UPDATE';

const html =
'<html><head>' +
'<meta http-equiv="refresh" content="5">' +
'<title>SR Stock Monitor</title>' +
'<style>' +
'body{background:#0f172a;color:white;font-family:Segoe UI;padding:25px;}' +
'.card{background:#1e293b;padding:20px;margin-bottom:15px;border-radius:12px;}' +
'.big{font-size:28px;font-weight:bold;}' +
'</style></head><body>' +
'<h1>SR STOCK LIVE MONITOR</h1>' +
'<div class="card"><div class="big">' + status + '</div></div>' +
'<div class="card"><b>items.json</b><br>Size: ' + (itemsStat ? itemsStat.size.toLocaleString() : 0) + ' bytes<br>Modified: ' + (itemsStat ? itemsStat.mtime : 'N/A') + '</div>' +
'<div class="card"><b>stock.csv</b><br>Size: ' + (stockStat ? stockStat.size.toLocaleString() : 0) + ' bytes<br>Modified: ' + (stockStat ? stockStat.mtime : 'N/A') + '</div>' +
'<div class="card"><b>Seconds Since Last Update:</b><br>' + ageSeconds + '</div>' +
'</body></html>';

res.writeHead(200, { 'Content-Type': 'text/html' });
res.end(html);

}).listen(3001, () => {
console.log('SR Monitor running on http://localhost:3001');
});
