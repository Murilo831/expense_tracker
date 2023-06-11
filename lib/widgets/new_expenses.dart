import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:expense_tracker/models/expense.dart';

class NewExpense extends StatefulWidget {
  const NewExpense({super.key, required this.onAddExpense});

  final void Function(Expense expense) onAddExpense;

  @override
  State<StatefulWidget> createState() {
    return _NewExpenseState();
  }
}

class _NewExpenseState extends State<NewExpense> {
  //TextEditingController -> Usado para lidar com a entrada do usuario
  final _titleController = TextEditingController();

  //MoneyMaskedTextController -> já deixa pronto pro user quando ele for colocar um valor de dinheiro
  final _amoutController = TextEditingController();
  //MoneyMaskedTextController(decimalSeparator: ',', thousandSeparator: '.');

  DateTime? _selectedDate;

  String? _textError;

  //Começa com esse valor o dropdown
  Category _selectedCategory = Category.lazer;

  /* Definindo a data */
  void _presentDatePicker() async {
    final now = DateTime.now();
    final firstDate = DateTime(now.year - 1, now.month, now.day);

    final pickedDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: firstDate,
      lastDate: now,
    );
    setState(() {
      _selectedDate = pickedDate;
    });
  }

  void _showDialog() {
    if (Platform.isIOS) {
      //CupertinoDialog -> para o IOS
      showCupertinoDialog(
        context: context,
        builder: (ctx) => CupertinoAlertDialog(
          title: const Text('Invalido'),
          content: Text('$_textError'),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.pop(ctx);
                },
                child: const Text('Okay'))
          ],
        ),
      );
    } else {
      // Mostrar mensagem de erro em um popup
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Invalido'),
          content: Text('$_textError'),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.pop(ctx);
                },
                child: const Text('Okay'))
          ],
        ),
      );
    }
  }

  void _submitExpenseData() {
    // tryParse('Hello') => null, tryParse('1.12') => 1.12

    final enteredAmout = double.tryParse(_amoutController.text);

    final amountIsInvalid = enteredAmout == null || enteredAmout <= 0;

    /*Mensagem de erro caso
    
      1. _titleController.text -> retornar vazio
      2. amountIsInvalid -> for igual a null ou 0
      3. _selectedDate -> for igual a null
    
     */
    if (_titleController.text.trim().isEmpty ||
        amountIsInvalid ||
        _selectedDate == null) {
      if (_titleController.text.trim().isEmpty) {
        _textError = 'Adicione um titulo para continuar';
      } else if (amountIsInvalid) {
        _textError = 'Adicione um valor para continuar';
      } else if (_selectedDate == null) {
        _textError = 'Adicione uma data para continuar';
      }

      _showDialog();

      return;
    }

    widget.onAddExpense(
      Expense(
        title: _titleController.text,
        amout: enteredAmout,
        date:
            _selectedDate!, // ! -> fala para dart que temos certeza que não será um valor nulo
        category: _selectedCategory,
      ),
    );
    Navigator.pop(context);
  }

  // dispose -> utilizado quando o controlador não é mais necessário

  // Ideal para não sobrecarregar a memória, do contrario o dispositivo pode ser ocupado pelos controladores que pode causar um colapso no app, fazendo ele crachar
  @override
  void dispose() {
    _titleController.dispose();
    _amoutController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final keyboardSpace = MediaQuery.of(context).viewInsets.bottom;

    return LayoutBuilder(builder: (ctx, constraints) {
      final width = constraints.maxWidth;

      return SizedBox(
        height: double.infinity,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(16, 16, 16, keyboardSpace + 16),
            child: Column(
              children: [
                if (width >= 600)
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _titleController,
                          maxLength: 50,
                          keyboardType: TextInputType.text,
                          decoration: const InputDecoration(
                            label: Text('Titulo'),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 24,
                      )
                    ],
                  )
                else
                  TextField(
                    controller: _titleController,
                    maxLength: 50,
                    keyboardType: TextInputType.text,
                    decoration: const InputDecoration(
                      label: Text('Titulo'),
                    ),
                  ),
                if (width >= 600)
                  Row(
                    children: [
                      DropdownButton(
                        value: _selectedCategory,
                        items: Category.values
                            .map(
                              (category) => DropdownMenuItem(
                                value: category,
                                child: Text(
                                  category.name.toUpperCase(),
                                ),
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          if (value == null) {
                            return;
                          }
                          setState(() {
                            _selectedCategory = value;
                          });
                        },
                      ),
                      const SizedBox(
                        width: 24,
                      ),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              _selectedDate == null
                                  ? 'Selecionar Data'
                                  : formatter.format(_selectedDate!),
                            ),
                            IconButton(
                              onPressed: _presentDatePicker,
                              icon: const Icon(Icons.calendar_month),
                            ),
                          ],
                        ),
                      )
                    ],
                  )
                else
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _amoutController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            prefixText: 'R\$ ',
                            label: Text('Valor'),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              _selectedDate == null
                                  ? 'Selecionar Data'
                                  : formatter.format(_selectedDate!),
                            ),
                            IconButton(
                              onPressed: _presentDatePicker,
                              icon: const Icon(Icons.calendar_month),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                const SizedBox(height: 16),
                if (width >= 600)
                  Row(
                    children: [
                      const Spacer(), //Garante que tenha espaçamento

                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Cancelar'),
                      ),
                      ElevatedButton(
                        onPressed: _submitExpenseData,
                        child: const Text(
                          'Salvar',
                        ),
                      ),
                    ],
                  )
                else
                  Row(
                    children: [
                      DropdownButton(
                        value: _selectedCategory,
                        items: Category.values
                            .map(
                              (category) => DropdownMenuItem(
                                value: category,
                                child: Text(
                                  category.name.toUpperCase(),
                                ),
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          if (value == null) {
                            return;
                          }
                          setState(() {
                            _selectedCategory = value;
                          });
                        },
                      ),

                      const Spacer(), //Garante que tenha espaçamento

                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Cancelar'),
                      ),
                      ElevatedButton(
                        onPressed: _submitExpenseData,
                        child: const Text(
                          'Salvar',
                        ),
                      ),
                    ],
                  )
              ],
            ),
          ),
        ),
      );
    });
  }
}
