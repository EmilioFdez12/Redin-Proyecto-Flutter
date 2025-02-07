import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:redin_app/utils/database/balance.dart';
import 'package:redin_app/utils/music/music_manager.dart';

/// Clase que maneja la lógica de la carrera de caballos.
/// Esta clase se encarga de gestionar las posiciones de los caballos,
/// las apuestas, la reproducción de música y los resultados de la carrera.
class HorseRaceLogic {
  final BuildContext context;
  final BalanceProvider balanceProvider;
  final ValueNotifier<double> horse1Position;
  final ValueNotifier<double> horse2Position;
  final ValueNotifier<double> horse3Position;
  final ValueNotifier<double> horse4Position;
  final ValueNotifier<int> coinValue;
  final ValueNotifier<String?> selectedHorse;
  final ValueNotifier<String?> winningHorse;
  final ValueNotifier<bool> isRaceRunning;
  final AudioManager audioManager;

  /// Constructor de la clase [HorseRaceLogic].
  ///
  /// [context]: El contexto de la aplicación.
  /// [balanceProvider]: Proveedor del saldo del usuario.
  /// [horse1Position]: Posición del caballo 1.
  /// [horse2Position]: Posición del caballo 2.
  /// [horse3Position]: Posición del caballo 3.
  /// [horse4Position]: Posición del caballo 4.
  /// [coinValue]: Valor de la apuesta en monedas.
  /// [selectedHorse]: Caballo seleccionado por el usuario.
  /// [winningHorse]: Caballo ganador de la carrera.
  /// [isRaceRunning]: Indica si la carrera está en curso.
  /// [audioManager]: Gestor de audio para controlar la música.
  HorseRaceLogic({
    required this.context,
    required this.balanceProvider,
    required this.horse1Position,
    required this.horse2Position,
    required this.horse3Position,
    required this.horse4Position,
    required this.coinValue,
    required this.selectedHorse,
    required this.winningHorse,
    required this.isRaceRunning,
    required this.audioManager,
  });

  /// Método que se ejecuta cuando el valor de la apuesta cambia.
  ///
  /// [value]: Nuevo valor de la apuesta en monedas.
  void onCoinChanged(int value) {
    coinValue.value = value;
    print('Monedas seleccionadas: $value');
  }

  /// Inicia la carrera de caballos.
  /// Verifica si se ha seleccionado un caballo y si la apuesta es válida.
  /// Luego, inicia la carrera y gestiona el movimiento de los caballos.
  void startRace() async {
    // Verificamos si se ha seleccionado un caballo y si la apuesta es válida
    if (selectedHorse.value == null || coinValue.value == 0) {
      Fluttertoast.showToast(
        msg: 'Por favor, selecciona un caballo y ajusta tu apuesta.',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return;
    }

    // Verificamos si el saldo es suficiente para la apuesta
    if (balanceProvider.balance < coinValue.value) {
      Fluttertoast.showToast(
        msg: 'Saldo insuficiente.',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return;
    }

    // Restamos las monedas apostadas del saldo
    balanceProvider.subtractCoins(coinValue.value);

    // Reiniciamos las posiciones de los caballos
    horse1Position.value = 0;
    horse2Position.value = 0;
    horse3Position.value = 0;
    horse4Position.value = 0;

    // Indicams que la carrera ha comenzado
    isRaceRunning.value = true;

    // Baja el volumen de la música de fondo a 0
    print('Muting background music');
    await audioManager.muteBackgroundMusic();

    // Reproduce la música de la carrera
    print('Playing race music');
    await audioManager.playHorseMusic();

    // ignore: unused_local_variable
    Timer? raceTimer;

    // Temporizador que controla el avance de los caballos
    raceTimer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      final random = Random();

      // Animamos los caballos de manera aleatoria
      horse1Position.value += 5 + random.nextInt(26);
      horse2Position.value += 5 + random.nextInt(26);
      horse3Position.value += 5 + random.nextInt(26);
      horse4Position.value += 5 + random.nextInt(26);

      // Verificamos si algún caballo ha llegado a la meta
      if (horse1Position.value >= 275 ||
          horse2Position.value >= 275 ||
          horse3Position.value >= 275 ||
          horse4Position.value >= 275) {
        print('Race finished');
        timer.cancel();
        isRaceRunning.value = false;

        // Determinamos el caballo ganador
        final positions = [
          horse1Position.value,
          horse2Position.value,
          horse3Position.value,
          horse4Position.value,
        ];
        final maxPosition = positions.reduce(max);
        final winningHorseIndex = positions.indexOf(maxPosition);

        winningHorse.value =
            ['Rojo', 'Verde', 'Azul', 'Amarillo'][winningHorseIndex];

        // Mostramos un mensaje con el caballo ganador
        Fluttertoast.showToast(
          msg: '¡El caballo ${winningHorse.value} ha ganado!',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: const Color.fromARGB(255, 255, 255, 255),
          textColor: const Color.fromARGB(255, 12, 12, 12),
        );

        // Verificamos si el usuario ha ganado la apuesta
        if (selectedHorse.value == winningHorse.value) {
          final reward = coinValue.value * 4;
          balanceProvider.addCoins(reward);

          // Mostramos un mensaje de victoria
          Fluttertoast.showToast(
            msg: '¡Ganaste $reward monedas!',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.green,
            textColor: Colors.white,
          );
        } else {
          // Reproducimos un sonido al perder
          await audioManager.playFailSound();
          Fluttertoast.showToast(
            msg: 'No has ganado esta vez. ¡Suerte para la próxima!',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.red,
            textColor: Colors.white,
          );
        }

        // Detenemos la música de la carrera
        print('Stopping race music');
        await audioManager.stopHorseMusic();

        // Restauramos el volumen de la música de fondo
        print('Unmuting background music');
        await audioManager.unmuteBackgroundMusic();
      }
    });
  }
}