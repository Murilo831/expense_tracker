import 'package:flutter/material.dart';

import 'package:expense_tracker/widgets/chart/chart.dart';
import 'package:expense_tracker/widgets/expenses_list/expenses_list.dart';
import 'package:expense_tracker/widgets/new_expenses.dart';
import 'package:expense_tracker/models/expense.dart';

class Expenses extends StatefulWidget {
  const Expenses({super.key});

  @override
  State<Expenses> createState() {
    return _ExpensesState();
  }
}

class _ExpensesState extends State<Expenses> {
  final List<Expense> _registeredExpenses = [
    Expense(
      title: 'Flutter Course',
      amout: 19.99,
      date: DateTime.now(),
      category: Category.comida,
    ),
    Expense(
      title: 'Cinema ',
      amout: 15.99,
      date: DateTime.now(),
      category: Category.lazer,
    ),
  ];

  //Abre e cria o modal, no final da tela
  void _openAddExpenseOverlay() {
    showModalBottomSheet(
      //Modal não fica na camera
      useSafeArea: true,
      isScrollControlled: true,
      context: context,
      builder: (ctx) => NewExpense(onAddExpense: _addExpense),
    );
  }

  void _addExpense(Expense expense) {
    setState(() {
      _registeredExpenses.add(expense);
    });
  }

  //Remove as despensar internamente
  void _removeExpense(Expense expense) {
    final expenseIndex = _registeredExpenses.indexOf(expense);

    setState(() {
      _registeredExpenses.remove(expense);
    });

    /*
    Caso o usuário exclua mais de uma de uma vez.
    A mensagem antiga é imediatamente removida!
    E a nova mensagem é mostrada
     */
    ScaffoldMessenger.of(context).clearSnackBars();

    // Mostra a mensagem se realmente quer apagar e da a opção de trazer o elemento para a lista
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 5),
        content: const Text('Despesa Excluida'),
        action: SnackBarAction(
          label: 'Desfazer',
          onPressed: () {
            setState(() {
              _registeredExpenses.insert(expenseIndex, expense);
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    Widget mainContent = const Center(
      child: Text('Nenhuma despesa encontrada.'),
    );

    // se _registeredExpenses não estiver vazia
    //isNotEmpty -> verifica se a lista esta vazia
    if (_registeredExpenses.isNotEmpty) {
      mainContent = ExpensesList(
        expenses: _registeredExpenses,
        onRemoveExpense: _removeExpense,
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Despesas'),
        actions: [
          IconButton(
            onPressed: _openAddExpenseOverlay,
            icon: const Icon(Icons.add),
          )
        ],
      ),
      body: width < 600
          ? Column(
              children: [
                const SizedBox(
                  height: 26,
                ),
                Chart(expenses: _registeredExpenses),
                // Quando uma lista ficar dentro da outra colocar expanded
                Expanded(
                  child: mainContent,
                ),
              ],
            )
          : Row(
              children: [
                Expanded(child: Chart(expenses: _registeredExpenses)),
                // Quando uma lista ficar dentro da outra colocar expanded
                Expanded(
                  child: mainContent,
                ),
              ],
            ),
    );
  }
}
