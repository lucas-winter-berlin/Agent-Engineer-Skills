const { listOrders } = require('./orders');
const { currentUser } = require('./auth');
const { x } = require('./money');

function homeSummary() {
  const user = currentUser();
  return { user: user, orders: listOrders(user.id), sample: x(1299) };
}

module.exports = { homeSummary, x };
