import 'package:flutter/material.dart';


import '../models/grocery_list_model.dart';

class GroceryItem extends StatelessWidget {
  GroceryItem(
      {super.key, required this.addGroceryItems, required this.refreshPage, required this.editData});

  final List<GroceryItemModel> addGroceryItems;
  Future<void> Function() refreshPage;
  void Function(GroceryItemModel itemModel) editData;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: refreshPage,
      //   By using providers data will fetched another time
      //   Provider.of(context).fetchAndSetProducts(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView.builder(
            itemCount: addGroceryItems.length,
            itemBuilder: (ctx, index) {
              return ListTile(
                title: Text(addGroceryItems[index].name, style: const TextStyle(
                    color: Colors.white
                ),),
                leading: Container(
                  height: 24,
                  width: 24,
                  color: addGroceryItems[index].category.itemColor,
                ),
                trailing: Row(
                    children: [
                      IconButton(onPressed: () {
                         editData;
              }, icon: const Icon(Icons.edit, color: Colors.white,),),
                      const SizedBox(width: 5,),
                      Text(addGroceryItems[index].quantity.toString(),
                        style: const TextStyle(
                            color: Colors.white
                        ),)

                    ]

                ),
              );
            }),
      ),
    );
  }
}
