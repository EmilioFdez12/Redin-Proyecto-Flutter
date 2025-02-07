import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';
import 'package:redin_app/logic/horse/horse_logic.dart';
import 'package:redin_app/utils/database/balance.dart';
import 'package:redin_app/ui/ui.dart';
import 'package:redin_app/utils/music/music_manager.dart';

/// Pantalla principal donde se juega a los caballos.
/// Esta pantalla muestra la interfaz de usuario del juego, 
/// incluyendo las opciones para realizar apuestas.
class HorseScreen extends HookWidget {
  const HorseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final balanceProvider = Provider.of<BalanceProvider>(context);
    final audioManager = Provider.of<AudioManager>(context);

    final screenSize = MediaQuery.of(context).size;
    final screenHeight = screenSize.height;
    final screenWidth = screenSize.width;

    final horse1Position = useState(0.0);
    final horse2Position = useState(0.0);
    final horse3Position = useState(0.0);
    final horse4Position = useState(0.0);
    final coinValue = useState(0);
    final selectedHorse = useState<String?>(null);
    final winningHorse = useState<String?>(null);
    final isRaceRunning = useState(false);

    final horseRaceLogic = HorseRaceLogic(
      context: context,
      balanceProvider: balanceProvider,
      horse1Position: horse1Position,
      horse2Position: horse2Position,
      horse3Position: horse3Position,
      horse4Position: horse4Position,
      coinValue: coinValue,
      selectedHorse: selectedHorse,
      winningHorse: winningHorse,
      isRaceRunning: isRaceRunning,
      audioManager: audioManager,
    );

    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            'assets/images/home/home_background.png',
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          Positioned(
            top: screenHeight * 0.08,
            left: screenWidth * 0.1,
            child: CoinDisplay(coins: balanceProvider.balance),
          ),
          Positioned(
            top: screenHeight * 0.35,
            left: 0,
            right: 0,
            child: Center(
              child: HorseRaceTrack(
                horseImagePath: 'assets/images/horse/caballo_rojo.png',
                offset: horse1Position.value,
              ),
            ),
          ),
          Positioned(
            top: screenHeight * 0.40,
            left: 0,
            right: 0,
            child: Center(
              child: HorseRaceTrack(
                horseImagePath: 'assets/images/horse/caballo_verde.png',
                offset: horse2Position.value,
              ),
            ),
          ),
          Positioned(
            top: screenHeight * 0.45,
            left: 0,
            right: 0,
            child: Center(
              child: HorseRaceTrack(
                horseImagePath: 'assets/images/horse/caballo_azul.png',
                offset: horse3Position.value,
              ),
            ),
          ),
          Positioned(
            top: screenHeight * 0.50,
            left: 0,
            right: 0,
            child: Center(
              child: HorseRaceTrack(
                horseImagePath: 'assets/images/horse/caballo_amarillo.png',
                offset: horse4Position.value,
              ),
            ),
          ),
          Positioned(
            top: screenHeight * 0.6,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                HorseButton(
                  color: Colors.red,
                  borderColor: Colors.red[300]!,
                  size: screenWidth * 0.15,
                  isActive: selectedHorse.value == 'Rojo',
                  onPressed: () {
                    selectedHorse.value = 'Rojo';
                    print('Apuesta al caballo rojo: ${coinValue.value} monedas');
                  },
                ),
                const SizedBox(width: 16),
                HorseButton(
                  color: Colors.green,
                  borderColor: Colors.green[300]!,
                  size: screenWidth * 0.15,
                  isActive: selectedHorse.value == 'Verde',
                  onPressed: () {
                    selectedHorse.value = 'Verde';
                    print('Apuesta al caballo verde: ${coinValue.value} monedas');
                  },
                ),
                const SizedBox(width: 16),
                HorseButton(
                  color: Colors.blue,
                  borderColor: Colors.blue[300]!,
                  size: screenWidth * 0.15,
                  isActive: selectedHorse.value == 'Azul',
                  onPressed: () {
                    selectedHorse.value = 'Azul';
                    print('Apuesta al caballo azul: ${coinValue.value} monedas');
                  },
                ),
                const SizedBox(width: 16),
                HorseButton(
                  color: Colors.yellow,
                  borderColor: Colors.yellow[300]!,
                  size: screenWidth * 0.15,
                  isActive: selectedHorse.value == 'Amarillo',
                  onPressed: () {
                    selectedHorse.value = 'Amarillo';
                    print('Apuesta al caballo amarillo: ${coinValue.value} monedas');
                  },
                ),
              ],
            ),
          ),
          Positioned(
            top: screenHeight * 0.70,
            left: 0,
            right: 0,
            child: Center(
              child: CoinSelector(
                coinValue: coinValue.value,
                onCoinChanged: horseRaceLogic.onCoinChanged,
              ),
            ),
          ),
          Positioned(
            top: screenHeight * 0.80,
            left: 0,
            right: 0,
            child: Center(
              child: SpinButton(
                label: 'GO!',
                onPressed: isRaceRunning.value ? null : horseRaceLogic.startRace,
              ),
            ),
          ),
        ],
      ),
    );
  }
}