import 'dart:io';

import 'package:expense_tracker_app/models/expense.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NewExpense extends StatefulWidget {
  final void Function(Expense) onAddNewExpense;

  const NewExpense({super.key, required this.onAddNewExpense});

  @override
  State<StatefulWidget> createState() {
    return _NewExpense();
  }
}

class _NewExpense extends State<NewExpense> {
  // var _enteredTitle = '';

  // void _saveTitleInput(String inputValue) {
  //   _enteredTitle = inputValue;
  // }
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime? _selectedDate;
  Category _selectedCategory = Category.leisure;

  void _presentDatePicker() async {
    final now = DateTime.now();
    final firstDate = DateTime(now.year - 1, now.month, now.day);
    final pickedDate = await showDatePicker(
      context: super.context,
      initialDate: now,
      firstDate: firstDate,
      lastDate: now,
    );

    setState(() {
      _selectedDate = pickedDate;
    });
  }

  void _onSelectCategoryDropdownButton(dynamic value) {
    setState(() {
      if (value == null) {
        return;
      }
      _selectedCategory = value;
    });
  }

  void _cancelModalOverlay() {
    Navigator.pop(super.context);
  }

  void _showDialog() {
    if (Platform.isIOS) {
      showCupertinoDialog(
        context: context,
        builder: (ctx) => CupertinoAlertDialog(
          title: const Text('Invalid Input'),
          content: const Text(
              'Please make sure a valid title, amount, date and category was entered!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
              },
              child: const Text('Okay'),
            ),
          ],
        ),
      );
    } else {
      showDialog(
        context: super.context,
        builder: (ctx) => AlertDialog(
          title: const Text('Invalid Input'),
          content: const Text(
              'Please make sure a valid title, amount, date and category was entered!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
              },
              child: const Text('Okay'),
            ),
          ],
        ),
      );
    }
  }

  void _submitExpenseData() {
    final enteredAmount = double.tryParse(_amountController.text);
    final amountIsInvalid = enteredAmount == null || enteredAmount <= 0;

    // validate
    if (_titleController.text.trim().isEmpty ||
        amountIsInvalid ||
        _selectedDate == null) {
      _showDialog();

      return;
    }

    final title = _titleController.text;
    final date = _selectedDate!;
    final category = _selectedCategory;

    widget.onAddNewExpense(Expense(
      title: title,
      amount: enteredAmount,
      date: date,
      category: category,
    ));
    _cancelModalOverlay();
  }

  List<DropdownMenuItem> _buildDropdownCategoryMenuItems() => Category.values
      .map(
        (category) => DropdownMenuItem(
          value: category,
          child: Text(
            category.name.toUpperCase(),
          ),
        ),
      )
      .toList();

  String get _selectedTextDate => _selectedDate == null
      ? 'No Selected Date'
      : formatter.format(_selectedDate!);

  @override
  void dispose() {
    super.dispose();
    _titleController.dispose();
    _amountController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final keyBoardSpace = MediaQuery.of(context).viewInsets.bottom;
        
    return LayoutBuilder(builder: (context, constraints) {
      final width = constraints.maxWidth;

      return SizedBox(
        height: double.infinity,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(16, 30, 16, keyBoardSpace + 16),
            child: Column(
              children: [
                if (width >= 600)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _titleController,
                          maxLength: 50,
                          decoration: const InputDecoration(
                            label: Text('Title'),
                          ),
                        ),
                      ),
                      const SizedBox(width: 24),
                      Expanded(
                        child: TextField(
                          controller: _amountController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            prefixText: '\$',
                            label: Text('Amount'),
                          ),
                        ),
                      ),
                    ],
                  )
                else
                  TextField(
                    controller: _titleController,
                    // onChanged: _saveTitleInput,
                    maxLength: 50,
                    decoration: const InputDecoration(
                      label: Text('Title'),
                    ),
                  ),
                if (width >= 600)
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      DropdownButton(
                        value: _selectedCategory,
                        items: _buildDropdownCategoryMenuItems(),
                        onChanged: _onSelectCategoryDropdownButton,
                      ),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(_selectedTextDate),
                            IconButton(
                              onPressed: _presentDatePicker,
                              icon: const Icon(Icons.calendar_month),
                            )
                          ],
                        ),
                      ),
                    ],
                  )
                else
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _amountController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            prefixText: '\$',
                            label: Text('Amount'),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(_selectedTextDate),
                            IconButton(
                              onPressed: _presentDatePicker,
                              icon: const Icon(Icons.calendar_month),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    if (width < 600)
                      DropdownButton(
                        value: _selectedCategory,
                        items: _buildDropdownCategoryMenuItems(),
                        onChanged: _onSelectCategoryDropdownButton,
                      ),
                    const Spacer(),
                    TextButton(
                      onPressed: _cancelModalOverlay,
                      child: const Text('Cancel'),
                    ),
                    ElevatedButton(
                      onPressed: _submitExpenseData,
                      child: const Text('Save Expense'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}

// SizedBox(
//         height: double.infinity,
//         child: SingleChildScrollView(
//           child: Padding(
//             padding: EdgeInsets.fromLTRB(16, 30, 16, keyBoardSpace + 16),
//             child: Column(
//               children: [
//                 TextField(
//                   controller: _titleController,
//                   // onChanged: _saveTitleInput,
//                   maxLength: 50,
//                   decoration: const InputDecoration(
//                     label: Text('Title'),
//                   ),
//                 ),
//                 Row(
//                   children: [
//                     Expanded(
//                       child: TextField(
//                         controller: _amountController,
//                         keyboardType: TextInputType.number,
//                         decoration: const InputDecoration(
//                           prefixText: '\$',
//                           label: Text('Amount'),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(width: 16),
//                     Expanded(
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.end,
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         children: [
//                           Text(_selectedTextDate),
//                           IconButton(
//                             onPressed: _presentDatePicker,
//                             icon: const Icon(Icons.calendar_month),
//                           )
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 16),
//                 Row(
//                   children: [
//                     DropdownButton(
//                       value: _selectedCategory,
//                       items: _buildDropdownCategoryMenuItems(),
//                       onChanged: _onSelectCategoryDropdownButton,
//                     ),
//                     const Spacer(),
//                     TextButton(
//                       onPressed: _cancelModalOverlay,
//                       child: const Text('Cancel'),
//                     ),
//                     ElevatedButton(
//                       onPressed: _submitExpenseData,
//                       child: const Text('Save Expense'),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ),
//       )
