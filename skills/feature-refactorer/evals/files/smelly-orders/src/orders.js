function fn1(row, uid) {
  return row.userId === uid;
}

function listOrders(uid) {
  var rows = [
    { id: 'inv-101', userId: 'u1', date: '2026-01-15', totalCents: 1299 },
    { id: 'inv-102', userId: 'u1', date: '2026-02-02', totalCents: 4500 }
  ];
  var out = [];
  for (var i = 0; i < rows.length; i++) {
    var x = rows[i];
    if (fn1(x, uid)) {
      out.push(x);
    }
  }
  var extra = [];
  for (var j = 0; j < rows.length; j++) {
    var y = rows[j];
    if (fn1(y, uid)) {
      extra.push(y);
    }
  }
  return out;
}

module.exports = { listOrders };
