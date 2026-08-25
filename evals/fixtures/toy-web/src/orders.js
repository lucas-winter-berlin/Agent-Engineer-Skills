function listOrders(userId) {
  return [
    { id: 'inv-101', userId: 'u1', date: '2026-01-15', totalCents: 1299 },
    { id: 'inv-102', userId: 'u1', date: '2026-02-02', totalCents: 4500 }
  ].filter(function (row) {
    return row.userId === userId;
  });
}

module.exports = { listOrders };
