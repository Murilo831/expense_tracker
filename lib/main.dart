import 'package:flutter/material.dart';
//import 'package:flutter/services.dart'; //Não permite rotação

import 'package:expense_tracker/widgets/expenses.dart';

// Define a cor principal do aplicativo
var kColorScheme = ColorScheme.fromSeed(
  seedColor: const Color.fromARGB(255, 96, 59, 181),
);

var kDarkColorScheme = ColorScheme.fromSeed(
  // Força com que os elementos fiquem dark
  brightness: Brightness.dark,
  //fromARGB(255, 5, 99, 125)
  seedColor: const Color.fromARGB(255, 5, 99, 125),
);

void main() {
  /** 
   * NÃO PERMITE ROTAÇÃO
   * Esse Código serve para não permitir que a rolagem de tela aconteça, caso o usuario vire a tela
   * 
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]).then((fn) {

    //Colocar todo código no runApp aqui dentro

  });
  */

    runApp(MaterialApp(
      /*
    
    Tema escuro
     */
      darkTheme: ThemeData.dark().copyWith(
        useMaterial3: true,
        colorScheme: kDarkColorScheme,

        // Coloca estilo nos cards
        cardTheme: const CardTheme().copyWith(
          color: kDarkColorScheme.secondaryContainer,
          // adiciona uma margin de 16 e 8 px em todos cards
          margin: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
        ),

        // Deixa o botão mais visivel
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
              backgroundColor: kDarkColorScheme.primaryContainer,
              foregroundColor: kDarkColorScheme.onPrimaryContainer),
        ),
      ),

      /*
    
    Tema claro
     */

      theme: ThemeData().copyWith(
        // Deixa mais bonito -> useMaterial3
        useMaterial3: true, // aqui
        colorScheme: kColorScheme,
        appBarTheme: const AppBarTheme().copyWith(
          backgroundColor: kColorScheme.onPrimaryContainer,
          foregroundColor: kColorScheme.primaryContainer,
        ),

        // Coloca estilo nos cards
        cardTheme: const CardTheme().copyWith(
          color: kColorScheme.secondaryContainer,
          // adiciona uma margin de 16 e 8 px em todos cards
          margin: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
        ),

        // Deixa o botão mais visivel
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: kColorScheme.primaryContainer,
          ),
        ),

        //Coloca estivo nos textos
        textTheme: ThemeData().textTheme.copyWith(
              titleLarge: TextStyle(
                fontWeight: FontWeight.bold,
                color: kColorScheme.onSecondaryContainer,
                fontSize: 16,
              ),
            ),
      ),
      /*
    Usa o tema que o usuario esta usando seja:
    Dark
    Light
    ou do sistema
     */
      themeMode: ThemeMode.system, //default
      home: const Expenses(),
    ));
  
}
