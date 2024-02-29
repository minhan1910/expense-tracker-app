import 'package:expense_tracker_app/data/expenses_factory.dart';
import 'package:expense_tracker_app/widgets/chart/chart.dart';
import 'package:expense_tracker_app/widgets/expenses_list/expenses_list.dart';
import 'package:expense_tracker_app/models/expense.dart';
import 'package:expense_tracker_app/widgets/new_expense.dart';
import 'package:flutter/material.dart';

class ExpensesScreen extends StatefulWidget {
  const ExpensesScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _Expenses();
  }
}

class _Expenses extends State<ExpensesScreen> {
  final List<Expense> _registeredExpenses = ExpensesFactory.build();

  void _openAddExpenseOverlay() {
    showModalBottomSheet(
      useSafeArea: true,
      isScrollControlled: true,
      context: super.context,
      builder: (ctx) => NewExpense(
        onAddNewExpense: _addNewExpense,
      ),
      constraints: const BoxConstraints(
        maxWidth: double.infinity,
        minWidth: double.infinity,
      ),
    );
  }

  void _addNewExpense(final Expense newExpense) {
    setState(() {
      _registeredExpenses.add(newExpense);
    });
  }

  void _removeExpense(Expense expense) {
    final expenseIndex = _registeredExpenses.indexOf(expense);

    setState(() {
      _registeredExpenses.removeAt(expenseIndex);
    });

    ScaffoldMessenger.of(super.context).clearSnackBars();
    ScaffoldMessenger.of(super.context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 3),
        content: const Text('Expense deleted!'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            setState(() {
              _registeredExpenses.insert(expenseIndex, expense);
            });
          },
        ),
      ),
    );
  }

  Widget _buildMainContent() => _registeredExpenses.isNotEmpty
      ? ExpensesList(
          expenses: _registeredExpenses,
          onRemoveExpense: _removeExpense,
        )
      : const Center(
          child: Text('No Expense found, Start adding something!'),
        );

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Expense Tracker'),
        actions: [
          IconButton(
            onPressed: _openAddExpenseOverlay,
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: width < 600
          ? Column(
              children: [
                // const Text('The chart'),
                Chart(
                  expenses: _registeredExpenses,
                ),
                // should be used Expand for solving Nest Column Widget (ExpensesList return inner Column)
                Expanded(
                  child: _buildMainContent(),
                ),
              ],
            )
          : Row(
              children: [
                Expanded(
                  child: Chart(
                    expenses: _registeredExpenses,
                  ),
                ),
                // should be used Expand for solving Nest Column Widget (ExpensesList return inner Column)
                Expanded(
                  child: _buildMainContent(),
                )
              ],
            ),
    );
  }
}
