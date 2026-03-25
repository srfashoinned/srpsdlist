const fs = require('fs');

const csv = fs.readFileSync('stock.csv', 'utf-8').trim().split('\n');

const data = csv.map(row => {
  const cols = row.split(',');

  return {
    name: cols[0],
    alias: cols[1],
    group: cols[2],
    mrp: Number(cols[3]),
    sale: Number(cols[4]),
    purchase: Number(cols[5]),
    wholesale: Number(cols[6]),
    stock: Number(cols[7])
  };
});

fs.writeFileSync('items.json', JSON.stringify(data, null, 2));

console.log("✅ items.json fixed and created");