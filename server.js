const http = require('http');
const fs = require('fs');
const path = require('path');

const folder = 'C:/Users/SR/Desktop/demmo';

http.createServer((req, res) => {

```
const items = path.join(folder, 'items.json');
const stock = path.join(folder, 'stock.csv');

let itemsStat = fs.existsSync(items) ? fs.statSync(items) : null;
let stockStat = fs.existsSync(stock) ? fs.statSync(stock) : null;

let latestTime = 0;

if (itemsStat) latestTime = Math.max(latestTime, itemsStat.mtimeMs);
if (stockStat) latestTime = Math.max(latestTime, stockStat.mtimeMs);

let ageSeconds = Math.floor((Date.now() - latestTime) / 1000);

let status = ageSeconds < 120
    ? '🟢 RUNNING'
    : '🔴 NO RECENT UPDATE';

res.writeHead(200, { 'Content-Type': 'text/html' });

res.end(`
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta http-equiv="refresh" content="5">
    <title>SR Stock Monitor</title>
    <style>
        body {
            background: #0f172a;
            color: white;
            font-family: Segoe UI, Arial;
            padding: 25px;
        }

        .card {
            background: #1e293b;
            padding: 20px;
            margin-bottom: 15px;
            border-radius: 12px;
        }

        .big {
            font-size: 28px;
            font-weight: bold;
        }

        h1 {
            margin-top: 0;
        }
    </style>
</head>
<body>

    <h1>🚀 SR STOCK LIVE MONITOR</h1>

    <div class="card">
        <div class="big">${status}</div>
    </div>

    <div class="card">
        <b>items.json</b><br>
        Size: ${(itemsStat?.size || 0).toLocaleString()} bytes<br>
        Modified: ${itemsStat?.mtime || 'N/A'}
    </div>

    <div class="card">
        <b>stock.csv</b><br>
        Size: ${(stockStat?.size || 0).toLocaleString()} bytes<br>
        Modified: ${stockStat?.mtime || 'N/A'}
    </div>

    <div class="card">
        <b>Seconds Since Last Update:</b><br>
        ${ageSeconds}
    </div>

</body>
</html>
`);
```

}).listen(3001, () => {
console.log('SR Monitor running on http://localhost:3001');
});
