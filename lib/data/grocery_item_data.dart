import 'package:authentication_app/data/shopping_list_data.dart';

import '../models/grocery_list_model.dart';
import '../models/shopping_list_model.dart';


final groceryItems = [
  GroceryItemModel(
      id: 'a',
      name: 'Milk',
      quantity: 1,
      category: shoppingListData[Categories.carbs]!),
  GroceryItemModel(
      id: 'b',
      name: 'Bananas',
      quantity: 5,
      category: shoppingListData[Categories.fruit]!),
  GroceryItemModel(
      id: 'c',
      name: 'Beef Steak',
      quantity: 1,
      category: shoppingListData[Categories.meat]!),
];