import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';

//Formata a data por padrão
final formatter = DateFormat.yMd();

//Gera o id
const uuid = Uuid();

//Tratado com String
enum Category { comida, viagem, lazer, trabalho }

const categoryIcons = {
  Category.comida: Icons.lunch_dining,
  Category.viagem: Icons.flight_takeoff,
  Category.lazer: Icons.movie,
  Category.trabalho: Icons.work
};

class Expense {
  Expense({
    required this.title,
    required this.amout,
    required this.date,
    required this.category,
  }) : id = uuid.v4();

  final String id;
  final String title;
  final double amout;
  final DateTime date;
  final Category category;

  String get formattedDate {
    return formatter.format(date);
  }
}

class ExpenseBucket {
  const ExpenseBucket({
    required this.category,
    required this.expenses,
  });

  ExpenseBucket.forCategory(
    List<Expense> allExpenses,
    this.category,
  ) : expenses = allExpenses
            .where((expense) => expense.category == category)
            .toList();

  final Category category;
  final List<Expense> expenses;

  double get totalExpenses {
    double sum = 0;

    //Ótimo para listas
    // Eu vi isso em python, mesma coisa
    for (final expense in expenses) {
      sum += expense.amout; // sum = sum + expense.amout
    }

    return sum;
  }
}
