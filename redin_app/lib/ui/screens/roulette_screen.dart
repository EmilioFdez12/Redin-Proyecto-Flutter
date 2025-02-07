import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';
import 'package:redin_app/logic/roulette/roulette_game_logic.dart';
import 'package:redin_app/logic/roulette/roulette_logic.dart';
import 'package:redin_app/utils/database/balance.dart';
import 'package:redin_app/utils/music/music_manager.dart';
import 'package:redin_app/ui/ui.dart';

/// Pantalla principal donde se juega a la ruleta.
/// Esta pantalla muestra la interfaz de usuario del juego,
/// incluyendo las opciones para realizar apuestas y la propia ruleta.
class RouletteScreen extends HookWidget {
  const RouletteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final rotation = useState(0.0);
    final isSpinning = useState(false);
    final resultNumber = useState("");
    final currentPage = useState(1);
    final showGrid = useState(false);
    final coinValue = useState(0);
    final selectedBet = useState<String?>(null);
    final selectedNumbers = useState<Set<int>>({});
    final balanceProvider = Provider.of<BalanceProvider>(context);
    final audioManager = Provider.of<AudioManager>(context);

    final gameLogic = RouletteGameLogic(
      rotation: rotation,
      isSpinning: isSpinning,
      resultNumber: resultNumber,
      coinValue: coinValue,
      selectedBet: selectedBet,
      selectedNumbers: selectedNumbers,
      balanceProvider: balanceProvider,
      audioManager: audioManager,
    );

    void toggleGrid() {
      showGrid.value = !showGrid.value;
    }

    void closeGrid() {
      showGrid.value = false;
    }

    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    final screenHeight = screenSize.height;

    final wheelSize = screenWidth * 0.7;
    final fontSize = screenWidth * 0.15;

    // Función para manejar los cambios en el valor de las monedas
    void onCoinChanged(int value) {
      coinValue.value = value;
      print('Monedas seleccionadas: $value');
    }

    return Scaffold(
      // Si pulsamos fuera del grid se cierra
      body: GestureDetector(
        onTap: () {
          if (showGrid.value) {
            closeGrid();
          }
        },
        child: Stack(
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
            // Ruleta
            Center(
              child: Padding(
                padding: EdgeInsets.only(bottom: screenHeight * 0.3),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    AnimatedRotation(
                      turns: rotation.value / 360,
                      duration: const Duration(milliseconds: 6000),
                      curve: Curves.easeOut,
                      child: Container(
                        width: wheelSize,
                        height: wheelSize,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(
                                'assets/images/roulette/ruleta.webp'),
                            fit: BoxFit.cover,
                          ),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                    if (resultNumber.value.isNotEmpty)
                      Stack(
                        children: [
                          Text(
                            resultNumber.value,
                            style: TextStyle(
                              fontSize: fontSize,
                              fontWeight: FontWeight.bold,
                              foreground: Paint()
                                ..style = PaintingStyle.stroke
                                ..strokeWidth = 4
                                ..color = Colors.white,
                            ),
                          ),
                          Text(
                            resultNumber.value,
                            style: TextStyle(
                              fontSize: fontSize,
                              fontWeight: FontWeight.bold,
                              color: RouletteLogic
                                      .numberColors[resultNumber.value] ??
                                  Colors.white,
                            ),
                          ),
                        ],
                      ),
                    Positioned(
                      top: 30,
                      child: Image.asset(
                        'assets/images/roulette/arrow.webp',
                        fit: BoxFit.contain,
                        width: screenWidth * 0.1,
                        height: screenHeight * 0.1,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: screenHeight * 0.05,
              left: 0,
              right: 0,
              child: Center(
                child: SpinButton(
                  label: 'SPIN',
                  onPressed: gameLogic.spinWheel,
                ),
              ),
            ),
            Positioned(
              bottom: screenHeight * 0.28,
              left: 0,
              right: 0,
              child: Column(
                children: [
                  if (!showGrid.value)
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            RouletteButton(
                              color: const Color.fromARGB(255, 255, 255, 255),
                              label: 'ODD',
                              isActive: selectedBet.value == 'ODD',
                              onPressed: () {
                                selectedBet.value = 'ODD';
                                print('Apuesta seleccionada: ODD');
                              },
                            ),
                            SizedBox(width: screenWidth * 0.02),
                            RouletteButton(
                              color: Colors.red,
                              label: '',
                              isActive: selectedBet.value == 'RED',
                              onPressed: () {
                                selectedBet.value = 'RED';
                                print('Apuesta seleccionada: RED');
                              },
                            ),
                            SizedBox(width: screenWidth * 0.02),
                            RouletteButton(
                              color: Colors.black,
                              label: '',
                              isActive: selectedBet.value == 'BLACK',
                              onPressed: () {
                                selectedBet.value = 'BLACK';
                                print('Apuesta seleccionada: BLACK');
                              },
                            ),
                            SizedBox(width: screenWidth * 0.02),
                            RouletteButton(
                              color: const Color.fromARGB(255, 255, 255, 255),
                              label: 'EVEN',
                              isActive: selectedBet.value == 'EVEN',
                              onPressed: () {
                                selectedBet.value = 'EVEN';
                                print('Apuesta seleccionada: EVEN');
                              },
                            ),
                          ],
                        ),
                        SizedBox(height: screenHeight * 0.02),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            RouletteButton(
                              color: const Color.fromARGB(255, 255, 255, 255),
                              label: '1-18',
                              isActive: selectedBet.value == '1-18',
                              onPressed: () {
                                selectedBet.value = '1-18';
                                print('Apuesta seleccionada: 1-18');
                              },
                            ),
                            SizedBox(width: screenWidth * 0.02),
                            RouletteButton(
                              color: Colors.green,
                              label: '0',
                              isActive: selectedBet.value == 'GREEN',
                              onPressed: () {
                                selectedBet.value = 'GREEN';
                                print('Apuesta seleccionada: GREEN');
                              },
                            ),
                            SizedBox(width: screenWidth * 0.02),
                            RouletteButton(
                              color: const Color.fromARGB(255, 255, 255, 255),
                              label: '19-36',
                              isActive: selectedBet.value == '19-36',
                              onPressed: () {
                                selectedBet.value = '19-36';
                                print('Apuesta seleccionada: 19-36');
                              },
                            ),
                            SizedBox(width: screenWidth * 0.02),
                            RouletteButton(
                              color: Colors.blue,
                              label: 'Table',
                              onPressed: toggleGrid,
                            ),
                          ],
                        ),
                      ],
                    ),
                  if (showGrid.value)
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              onPressed: () => currentPage.value = 1,
                              child: const Text('1-18'),
                            ),
                            SizedBox(width: screenWidth * 0.02),
                            ElevatedButton(
                              onPressed: () => currentPage.value = 2,
                              child: const Text('19-36'),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: screenHeight * 0.16,
                          child: NumberGrid(
                            start: currentPage.value == 1 ? 1 : 19,
                            end: currentPage.value == 1 ? 18 : 36,
                            selectedNumbers: selectedNumbers.value,
                            onNumberSelected: (number) {
                              if (selectedNumbers.value.contains(number)) {
                                selectedNumbers.value =
                                    Set<int>.from(selectedNumbers.value)
                                      ..remove(number);
                              } else if (selectedNumbers.value.length < 4) {
                                selectedNumbers.value =
                                    Set<int>.from(selectedNumbers.value)
                                      ..add(number);
                              }
                              print('Número seleccionado: $number');
                            },
                            onClose: closeGrid,
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
            Positioned(
              bottom: screenHeight * 0.17,
              left: 0,
              right: 0,
              child: Center(
                child: CoinSelector(
                  coinValue: coinValue.value,
                  onCoinChanged: onCoinChanged,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}