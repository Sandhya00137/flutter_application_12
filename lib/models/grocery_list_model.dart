

import 'package:authentication_app/models/shopping_list_model.dart';

class GroceryItemModel {
  const GroceryItemModel({
    required this.id,
    required this.name,
    required this.category,
    required this.quantity,
  });

  final String id;
  final String name;
  final ShoppingListModel category;
  final int quantity;
}
