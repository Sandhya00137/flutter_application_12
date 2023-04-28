import 'dart:convert';

import 'package:flutter/material.dart';
import '../data/shopping_list_data.dart';
import '../models/grocery_list_model.dart';
import '../models/shopping_list_model.dart';

import 'package:http/http.dart' as http;

class NewItemScreen extends StatefulWidget {
  const NewItemScreen({Key? key}) : super(key: key);

  @override
  State<NewItemScreen> createState() => _NewItemScreenState();
}

class _NewItemScreenState extends State<NewItemScreen> {
  final _formKey = GlobalKey<FormState>();
  var _enteredName = '';
  var _enteredQuantity = 1;
  var _selectedCategory = shoppingListData[Categories.vegetables]!;
  var _isSending = false;

  void _saveItem() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() {
        _isSending = true;
      });
      final url = Uri.https(
          'flutter-preparation-bb835-default-rtdb.firebaseio.com',
          'shopping-list.json');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(
          {
            'name': _enteredName,
            'category': _selectedCategory.itemName,
            'quantity': _enteredQuantity
          },
        ),
      );

      // ).then((value) {
      //
      // });
      //   print('$_selectedCategory value ');
      final Map<String, dynamic> resData = json.decode(response.body);
      if (!context.mounted) {
        return;
      }
      //   Navigator.of(context).pop();
      Navigator.of(context).pop(GroceryItemModel(
          id: resData['name'],
          name: _enteredName,
          category: _selectedCategory,
          quantity: _enteredQuantity));
    }
  }

  void _resetAllFields() {
    _formKey.currentState!.reset();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add new Item',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        // instead of textfield
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // instead of textfield()
              TextFormField(
                maxLength: 50,
                decoration: const InputDecoration(
                  label: Text(
                    'name',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                validator: (value) {
                  if (value == null ||
                      value.isEmpty ||
                      value.trim().length <= 1 ||
                      value.trim().length > 50) {
                    return 'must be 1 to 50 characters';
                  }
                  return null;
                },
                onSaved: (value) {
                  _enteredName = value!;
                },
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                          label: Text('quantity',
                              style: TextStyle(color: Colors.white))),
                      initialValue: _enteredQuantity.toString(),
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            int.tryParse(value)! <= 0 ||
                            int.tryParse(value) == null) {
                          return 'must be valid, positive number ';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _enteredQuantity = int.parse(value!);
                      },
                    ),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Expanded(
                    child: DropdownButtonFormField(
                        items: [
                          for (final item in shoppingListData.entries)
                            DropdownMenuItem(
                                value: _selectedCategory,
                                child: Row(children: [
                                  Container(
                                    width: 16,
                                    height: 16,
                                    color: item.value.itemColor,
                                  ),
                                  const SizedBox(
                                    width: 6,
                                  ),
                                  Text(item.value.itemName),
                                ]))
                        ],
                        onChanged: (value) {
                          setState(() {
                            _selectedCategory = value!;
                          });
                        }),
                  ),
                  // ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                      onPressed: _isSending ? null : _resetAllFields,
                      child: const Text('Reset')),
                  ElevatedButton(
                      onPressed: _isSending ? null : _saveItem,
                      child: _isSending
                          ? const SizedBox(
                              height: 16,
                              width: 16,
                              child: CircularProgressIndicator(),
                            )
                          : const Text('Submit')),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
