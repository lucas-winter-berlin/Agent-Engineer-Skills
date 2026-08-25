const { formatCents } = require('./money');

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
      totalLabel: formatCents(row.totalCents)
    };
  });
}

module.exports = { listOrders };
