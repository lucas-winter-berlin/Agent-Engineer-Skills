function cartItemCount(cart) {
  // Empty cart from the store is null; callers expect 0.
  return cart.items.length;
}

module.exports = { cartItemCount };
