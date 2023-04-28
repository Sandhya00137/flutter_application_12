import 'package:flutter/material.dart';

enum Categories {
  vegetables,
  fruit,
  dairy,
  meat,
  carbs,
  sweets,
  spices,
  convenience,
  hygiene,
  other
}

class ShoppingListModel {
  const ShoppingListModel(this.itemName, this.itemColor);

  final String itemName;
  final Color itemColor;
}