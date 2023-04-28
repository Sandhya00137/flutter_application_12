import 'dart:async';
import 'dart:convert';

import 'package:authentication_app/data/grocery_item_data.dart';
import 'package:authentication_app/data/shopping_list_data.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/grocery_list_model.dart';
import '../widgets/grocery_item.dart';
import 'new_item_screen.dart';

class ShopFirstScreen extends StatefulWidget {
  const ShopFirstScreen({super.key});

  @override
  State<ShopFirstScreen> createState() => _ShopFirstScreenState();
}

class _ShopFirstScreenState extends State<ShopFirstScreen> {
  List<GroceryItemModel> _list = [];
  late Future<List<GroceryItemModel>> _loadedItems;
  String? _error;


  @override
  void initState() {
    super.initState();
    _loadedItems = _loadItems();
  }

  Future<List<GroceryItemModel>> _loadItems() async {
    final url = Uri.https(
        'flutter-preparation-bb835-default-rtdb.firebaseio.com',
        'shopping-list.json');

    // try {
       final response = await http.get(url);
       if (response.statusCode >= 400) {
         // setState(() {
         //   _error = 'Failed to fetch data';
         // });
         throw Exception('Fetch data is failed');
       }
       if (response.body == 'null') {
         // setState(() {
         //   _isLoading = false;
         // });
         return [];
       }
       final Map<String, dynamic> listData = json.decode(response.body);
       final List<GroceryItemModel> loadedItems = [];
       for (final item in listData.entries) {
         final category = shoppingListData.entries
             .firstWhere(
                 (element) => element.value.itemName == item.value['category'])
             .value;
         loadedItems.add(GroceryItemModel(id: item.key,
             name: item.value['name'],
             category: item.value['category'],
             quantity: item.value['quantity']));
       }
       return loadedItems;
    }
    // catch (error) {
    //   setState(() {
    //     _error = 'Something went wrong!';
    //   });
    // }

    // throw Exception('An error occurred!');

    // }


    void _addItem() async {
      // final newItem =  await Navigator.of(context).push<GroceryItemModel>(
      final data = await Navigator.of(context)
          .push<GroceryItemModel>(MaterialPageRoute(builder: (ctx) {
        return const NewItemScreen();
      }));
      // _loadItems();
      if (data == null) {
        return;
      }
      setState(() {
        _list.add(data);
        // _isLoading = false;
      });

    }

    Future<void> refresh() async {
      final url = Uri.https(
          'flutter-preparation-bb835-default-rtdb.firebaseio.com',
          'shopping-list.json');
      final response = await http.get(url);
      if (response.statusCode >= 400) {
        // setState(() {
        //   _error = 'Failed to fetch data';
        // });
        throw Exception('Fetch data is failed');
      }
      if (response.body == 'null') {
        // setState(() {
        //   _isLoading = false;
        // });
        return ;
      }
      final Map<String, dynamic> listData = json.decode(response.body);
      final List<GroceryItemModel> loadedItems = [];
      for (final item in listData.entries) {
        final category = shoppingListData.entries
            .firstWhere(
                (element) => element.value.itemName == item.value['category'])
            .value;
        loadedItems.add(GroceryItemModel(id: item.key,
            name: item.value['name'],
            category: item.value['category'],
            quantity: item.value['quantity']));
      }
     setState(() {
       _list = loadedItems;
      });
      // setState(() {
      //   _list = loadedItems.map((e) => {
      //
      //   }).cast<GroceryItemModel>().toList();
      // });

    }

    Future<void> updateProduct(GroceryItemModel item) async {
      final indexOfItem = _list.indexOf(item);
      
      final url = Uri.https(
          'flutter-preparation-bb835-default-rtdb.firebaseio.com',
          'shopping-list.json');
      final response = await http.patch(url, body: json.encode({
        'name': item.name,
        'category': item.category,
        'quantity': item.quantity,
      }));
      if (response.statusCode >= 400) {
        // setState(() {
        //   _error = 'Failed to fetch data';
        // });
        throw Exception('Fetch data is failed');
      }
      if (response.body == 'null') {
        // setState(() {
        //   _isLoading = false;
        // });
        return ;
      }
      final Map<String, dynamic> listData = json.decode(response.body);
      final List<GroceryItemModel> loadedItems = [];
      for (final item in listData.entries) {
        final category = shoppingListData.entries
            .firstWhere(
                (element) => element.value.itemName == item.value['category'])
            .value;
        loadedItems.add(GroceryItemModel(id: item.key,
            name: item.value['name'],
            category: item.value['category'],
            quantity: item.value['quantity']));
      }
      setState(() {
        _list = loadedItems;
      });
    }

    void _removeItem(GroceryItemModel item) async {
    final indexOfItem = _list.indexOf(item);
      setState(() {
        _list.remove(item);
      });

      final url = Uri.https(
          'flutter-preparation-bb835-default-rtdb.firebaseio.com',
          'shopping-list/${item.id}.json');
      final response = await http.delete(url);

     if(response.statusCode >= 400) {
       setState(() {
         _list.insert(indexOfItem, item);
       });
     }

    }

    @override
    Widget build(BuildContext context) {
     // Widget content = const Center(child: Text('No data added yet'),);

     // if(_isLoading == true) {
     //   content = const Center(child: CircularProgressIndicator(),);
     // }

     // if (_list.isNotEmpty) {
     //   content = GroceryItem(
     //     addGroceryItems: _list,
     //   );
     // }

     // if(_error != null) {
     //   content = Center(child: Text(_error!),);
     // }
      return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Your Groceries',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
          actions: [
            IconButton(onPressed: _addItem, icon: const Icon(Icons.add)),
          ],
        ),
        body: FutureBuilder(future: _loadedItems, builder: (context, snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(),);
          }
          if(snapshot.hasError) {
            return Center(child: Text(_error!),);
          }
          if (snapshot.data!.isEmpty) {
            return const Center(child: Text('No data added yet'),);
          }
          return GroceryItem(
            addGroceryItems: snapshot.data!, refreshPage: refresh, editData: updateProduct);
        },),
      );
    }
  }
