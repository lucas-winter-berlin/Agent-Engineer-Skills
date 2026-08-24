const { listOrders } = require('./orders');
const { currentUser } = require('./auth');

function homeSummary() {
  const user = currentUser();
  return { user: user, orders: listOrders(user.id) };
}

module.exports = { homeSummary };
