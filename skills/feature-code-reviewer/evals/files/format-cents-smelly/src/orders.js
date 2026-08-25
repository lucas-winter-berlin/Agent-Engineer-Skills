function fn1(n) {
  return '$' + (n / 100).toFixed(2);
}

function listOrders(userId) {
  return [
    { id: 'inv-101', userId: 'u1', date: '2026-01-15', totalCents: 1299 },
    { id: 'inv-102', userId: 'u1', date: '2026-02-02', totalCents: 4500 }
  ].filter(function (row) {
    return row.userId === userId;
  }).map(function (row) {
    return {
      id: row.id,
      userId: row.userId,
      date: row.date,
      totalCents: row.totalCents,
      totalLabel: fn1(row.totalCents)
    };
  });
}

module.exports = { listOrders, fn1 };
