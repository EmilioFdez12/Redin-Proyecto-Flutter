import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:redin_app/logic/roulette/roulette_logic.dart';
import 'package:redin_app/utils/database/balance.dart';
import 'package:redin_app/utils/music/music_manager.dart';

/// Clase que maneja la lógica del juego de la ruleta.
/// Esta clase gestiona las apuestas, la rotación de la ruleta, los resultados
/// y las interacciones con el saldo y el audio.
class RouletteGameLogic {
  /// Notificador para la rotación de la ruleta.
  final ValueNotifier<double> rotation;

  /// Notificador para indicar si la ruleta está girando.
  final ValueNotifier<bool> isSpinning;

  /// Notificador para el número resultante de la ruleta.
  final ValueNotifier<String> resultNumber;

  /// Notificador para el valor de la apuesta en monedas.
  final ValueNotifier<int> coinValue;

  /// Notificador para la apuesta seleccionada (rojo, negro, par, impar, etc.).
  final ValueNotifier<String?> selectedBet;

  /// Notificador para los números seleccionados en la apuesta.
  final ValueNotifier<Set<int>> selectedNumbers;

  /// Proveedor del saldo del usuario.
  final BalanceProvider balanceProvider;

  /// Gestor de audio para controlar la música y los sonidos.
  final AudioManager audioManager;

  /// Constructor de la clase [RouletteGameLogic].
  ///
  /// [rotation]: Notificador para la rotación de la ruleta.
  /// [isSpinning]: Notificador para indicar si la ruleta está girando.
  /// [resultNumber]: Notificador para el número resultante de la ruleta.
  /// [coinValue]: Notificador para el valor de la apuesta en monedas.
  /// [selectedBet]: Notificador para la apuesta seleccionada.
  /// [selectedNumbers]: Notificador para los números seleccionados en la apuesta.
  /// [balanceProvider]: Proveedor del saldo del usuario.
  /// [audioManager]: Gestor de audio para controlar la música y los sonidos.
  RouletteGameLogic({
    required this.rotation,
    required this.isSpinning,
    required this.resultNumber,
    required this.coinValue,
    required this.selectedBet,
    required this.selectedNumbers,
    required this.balanceProvider,
    required this.audioManager,
  });

  /// Hace girar la ruleta.
  /// Verifica si el usuario tiene suficiente saldo y si ha seleccionado una apuesta válida.
  /// Luego, realiza la rotación de la ruleta y calcula el resultado.
  void spinWheel() async {
    // Verificamos si el usuario tiene suficiente saldo para apostar
    if (coinValue.value > balanceProvider.balance) {
      Fluttertoast.showToast(
        msg: "No tienes suficientes monedas para apostar",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return;
    }

    // Verificamos si la ruleta no está girando y si se ha seleccionado una apuesta válida
    if (!isSpinning.value && (selectedBet.value != null || selectedNumbers.value.isNotEmpty) && coinValue.value > 0) {
      // Restamos las monedas apostadas del saldo
      balanceProvider.subtractCoins(coinValue.value);

      // Muteamos la música de fondo
      await audioManager.muteBackgroundMusic();

      // Reproducimos el sonido de la ruleta girando
      await audioManager.playRouletteBall();

      // Realizamos la rotación de la ruleta
      rotation.value = RouletteLogic.spinWheel(rotation.value);
      isSpinning.value = true;
      resultNumber.value = "";

      Future.delayed(const Duration(seconds: 6), () async {
        // Calculamos el número resultante
        final result = RouletteLogic.calculateResult(rotation.value);
        resultNumber.value = result;
        isSpinning.value = false;

        // Detenemos el sonido de la ruleta girando
        await audioManager.stopRouletteMusic();

        // Reanudamos la música de fondo
        await audioManager.unmuteBackgroundMusic();

        // Convertimos el resultado a un número entero
        final number = int.tryParse(result) ?? 0;

        bool isWin = false;

        // Verificamos si se han seleccionado números específicos
        if (selectedNumbers.value.isNotEmpty) {
          isWin = selectedNumbers.value.contains(number);
        } else {
          // Verificamos el tipo de apuesta seleccionada
          final color = RouletteLogic.numberColors[result];
          switch (selectedBet.value) {
            case 'ODD':
              isWin = number % 2 != 0 && number != 0;
              break;
            case 'EVEN':
              isWin = number % 2 == 0 && number != 0; 
              break;
            case 'RED':
              isWin = color == RouletteLogic.rojo; 
              break;
            case 'BLACK':
              isWin = color == RouletteLogic.negro; 
              break;
            case 'GREEN':
              isWin = number == 0; 
              break;
            case '1-18':
              isWin = number >= 1 && number <= 18; 
              break;
            case '19-36':
              isWin = number >= 19 && number <= 36;
              break;
            default:
              isWin = false;
          }
        }

        // Si el usuario gana, calculamos las ganancias y las añade al saldo
        if (isWin) {
          final winnings = selectedNumbers.value.isNotEmpty
              ? coinValue.value * (36 ~/ selectedNumbers.value.length) 
              : selectedBet.value == 'GREEN'
                  ? coinValue.value * 35 
                  : coinValue.value * 2;

          balanceProvider.addCoins(winnings);

          // Reproducimos el sonido de victoria
          await audioManager.playVictorySound();

          // Mostramos un mensaje de victoria
          Fluttertoast.showToast(
            msg: "¡Ganaste! Ganancias: $winnings monedas",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            backgroundColor: Colors.green,
            textColor: Colors.white,
          );
          print('¡Ganaste! Número: $number. Ganancias: $winnings');
        } else {
          // Reproducimos el sonido de derrota
          await audioManager.playFailSound();

          // Mostramos un mensaje de derrota
          Fluttertoast.showToast(
            msg: "Perdiste. Número: $number",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            backgroundColor: Colors.red,
            textColor: Colors.white,
          );
          print('Perdiste. Número: $number');
        }

        // Reiniciamos la apuesta
        selectedBet.value = null;
        selectedNumbers.value = {};
      });
    } else {
      // Mostramos un mensaje si no se ha seleccionado una apuesta válida
      Fluttertoast.showToast(
        msg: "Selecciona un tipo de apuesta o números y una cantidad de monedas",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.orange,
        textColor: Colors.white,
      );
    }
  }
}