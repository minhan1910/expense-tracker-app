import 'package:expense_tracker_app/models/expense.dart';

class ExpensesFactory {
  static final List<Expense> _expenses = [
    Expense(
      title: 'Flutter Course',
      amount: 19.99,
      date: DateTime.now(),
      category: Category.work,
    ),
    Expense(
      title: 'Cinema',
      amount: 19.99,
      date: DateTime.now(),
      category: Category.leisure,
    ),
  ];

  static List<Expense> build() => _expenses;
}
