import 'package:flutter/material.dart';
import 'package:shopping_list_app/data/categories.dart';
import 'package:shopping_list_app/models/category.dart';

class NewItemScreen extends StatefulWidget {
  const NewItemScreen({super.key});

  @override
  State<NewItemScreen> createState() => _NewItemScreenState();
}

class _NewItemScreenState extends State<NewItemScreen> {
  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<
        FormState>(); // That gives the access to the internal state of the form.

    var _enteredName = '';
    var _enteredQuantity = 0;
    var _selectedCategory = categories[Categories.vegetables];

    void _saveItem() {
      if (_formKey.currentState!.validate()) {
        _formKey.currentState!.save();
        print(_enteredName);
        print(_enteredQuantity);
        print(_selectedCategory);
      }
    }

    return Scaffold(
        appBar: AppBar(
          title: Text("Add a new item"),
        ),
        body: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  decoration: const InputDecoration(
                    label: Text("Grocery name"),
                  ),
                  validator: (value) {
                    if (value == null ||
                        value.isEmpty ||
                        value.trim().length <= 1 ||
                        value.length > 50) {
                      return "Must be 1 to 50 characters long";
                    }

                    return null;
                  },
                  onSaved: (newValue) {
                    _enteredName = newValue!;
                  },
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: TextFormField(
                        initialValue: _enteredQuantity.toString(),
                        decoration: const InputDecoration(
                          label: Text("Quantity"),
                        ),
                        validator: (value) {
                          if (value == null ||
                              value.isEmpty ||
                              int.tryParse(value) == null ||
                              int.tryParse(value)! < 0) {
                            return "Must be 0 or a positive value";
                          }

                          return null;
                        },
                        keyboardType: TextInputType.number,
                        onSaved: (newValue) {
                          _enteredQuantity = int.parse(newValue!);
                        },
                      ),
                    ),
                    Expanded(
                      child: DropdownButtonFormField(
                          value: _selectedCategory,
                          items: [
                            for (final category in categories.entries)
                              DropdownMenuItem(
                                  value: category.value,
                                  child: Row(
                                    children: [
                                      Container(
                                        height: 24,
                                        width: 24,
                                        color: category.value.color,
                                      ),
                                      const SizedBox(
                                        width: 12,
                                      ),
                                      Text(category.value.name)
                                    ],
                                  ))
                          ],
                          onChanged: (value) {
                            _selectedCategory = value!;
                          }),
                    )
                  ],
                ),
                const SizedBox(
                  height: 12,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        _formKey.currentState!.reset();
                      },
                      child: Text("Reset"),
                    ),
                    ElevatedButton(
                      onPressed: _saveItem,
                      child: Text("Add item"),
                    )
                  ],
                )
              ],
            )));
  }
}
