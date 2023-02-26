import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CalculationProvider with ChangeNotifier {

  // THIS FUNCTIONS WERE GOTTEN FOR CHATGPT, I CANT SAY IF THEY ARE CORRECT OR NOT. SO CONTINUE USING CHATGPT TO GENERATE OTHERS



  
   
  // a and b are the input from the user so if we want to use the function, we say
  // calculatePythagoreanTheorem(2,4)
  double calculatePythagoreanTheorem(double a, double b) {
    double c = sqrt(pow(a, 2) + pow(b, 2));
    return c;
  }




  // the simultaneous accept a list of list like a matrix
  // if this is the question
  //   2x + y - z = 8
  //  -3x - y + 2z = -11
  //  -x + y + 2z = -3
  // that means the input that will be passed will be 
  //   [
  //   [2.0, 1.0, -1.0, 8.0],
  //   [-3.0, -1.0, 2.0, -11.0],
  //   [-1.0, 1.0, 2.0, -3.0],
  //  ]

  List<double> solveSimultaneousEquations(List<List<double>> equations) {
    int n = equations.length;

    // Perform forward elimination
    for (int i = 0; i < n; i++) {
      // Find the row with the largest absolute value in the ith column
      int pivotRow = i;
      double pivotValue = equations[i][i].abs();
      for (int j = i + 1; j < n; j++) {
        double value = equations[j][i].abs();
        if (value > pivotValue) {
          pivotRow = j;
          pivotValue = value;
        }
      }
      // Swap the ith row with the pivot row
      if (pivotRow != i) {
        List<double> temp = equations[i];
        equations[i] = equations[pivotRow];
        equations[pivotRow] = temp;
      }

      // Normalize the ith row
      double divisor = equations[i][i];
      for (int j = i; j < n + 1; j++) {
        equations[i][j] /= divisor;
      }

      // Eliminate the ith variable from all other rows
      for (int j = 0; j < n; j++) {
        if (j != i) {
          double factor = equations[j][i];
          for (int k = i; k < n + 1; k++) {
            equations[j][k] -= factor * equations[i][k];
          }
        }
      }
    }

    // Extract the solution vector from the augmented matrix
    List<double> solution = List<double>.filled(n, 0.0);
    for (int i = 0; i < n; i++) {
      solution[i] = equations[i][n];
    }

    return solution;
  }
}
