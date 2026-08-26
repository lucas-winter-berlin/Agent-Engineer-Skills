function formatCents(cents) {
  if (typeof cents !== 'number' || !isFinite(cents)) {
    throw new TypeError('cents must be a finite number');
  }
  return '$' + (cents / 100).toFixed(2);
}

module.exports = { formatCents };
