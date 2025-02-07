import 'dart:math';
import 'package:flutter/material.dart';

/// Clase que contiene la lógica básica de la ruleta.
/// Esta clase gestiona los números de la ruleta, sus colores y los cálculos
/// relacionados con la rotación y el resultado de la ruleta.
class RouletteLogic {
  /// Lista de números en la ruleta, ordenados según su posición en la rueda.
  static const List<String> numbers = [
    "0", "32", "15", "19", "4", "21", "2", "25", "17", "34", "6",
    "27", "13", "36", "11", "30", "8", "23", "10", "5", "24", "16",
    "33", "1", "20", "14", "31", "9", "22", "18", "29", "7", "28", "12", "35", "3", "26"
  ];

  /// Color rojo utilizado en la ruleta.
  static const Color rojo = Color(0xFFE10D00);

  /// Color verde utilizado en la ruleta.
  static const Color verde = Color(0xFF027710);

  /// Color negro utilizado en la ruleta.
  static const Color negro = Color(0xFF121212);

  /// Mapa que asigna cada número de la ruleta a su color correspondiente.
  static const Map<String, Color> numberColors = {
    '0': verde,
    '1': rojo, '3': rojo, '5': rojo, '7': rojo, '9': rojo,
    '12': rojo, '14': rojo, '16': rojo, '18': rojo, '19': rojo,
    '21': rojo, '23': rojo, '25': rojo, '27': rojo, '30': rojo,
    '32': rojo, '34': rojo, '36': rojo,
    '2': negro, '4': negro, '6': negro, '8': negro,
    '10': negro, '11': negro, '13': negro, '15': negro,
    '17': negro, '20': negro, '22': negro, '24': negro,
    '26': negro, '28': negro, '29': negro, '31': negro,
    '33': negro, '35': negro,
  };

  /// Ángulo que ocupa cada numero de la ruleta.
  static final double sectorAngle = 360.0 / numbers.length;

  /// Genera una rotación aleatoria para la ruleta, incluyendo giros completos y un extra aleatorio.
  ///
  /// [currentRotation]: La rotación actual de la ruleta.
  /// Devuelve la nueva rotación calculada.
  static double spinWheel(double currentRotation) {
     // Añadimos una rotación extra aleatoria
    final randomExtraRotation = Random().nextInt(360);
    return currentRotation + 1440 + randomExtraRotation;
  }

  /// Calcula el número resultante basado en el ángulo final de la ruleta.
  ///
  /// [finalRotation]: La rotación final de la ruleta.
  /// Devuelve el número correspondiente al ángulo final.
  static String calculateResult(double finalRotation) {
    final normalizedAngle = finalRotation % 360.0;

    // Ajustamos el ángulo para que el 0 esté en la parte superior
    // como en la imagen
    final adjustedAngle = (360.0 - normalizedAngle) % 360.0;

    // Calculamos el índice del número correspondiente al ángulo ajustado
    final index = ((adjustedAngle + sectorAngle / 2) / sectorAngle).floor() % numbers.length;

    // Devuelve el número correspondiente al índice calculado
    return numbers[index];
  }
}