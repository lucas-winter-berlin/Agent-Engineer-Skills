const { listOrders } = require('./orders');
const { currentUser } = require('./auth');
const { formatCents } = require('./money');

function homeSummary() {
  const user = currentUser();
  return { user: user, orders: listOrders(user.id) };
}

module.exports = { homeSummary, formatCents };
