import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:redin_app/ui/ui.dart';
import 'package:redin_app/utils/database/balance.dart';
import 'package:redin_app/utils/music/music_manager.dart';

/// Pantalla principal donde se muestran los minijuegos
/// disponibles para jugar y el balance de monedas.
class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  @override
  void initState() {
    super.initState();
    final audioManager = Provider.of<AudioManager>(context, listen: false);
    audioManager.playBackgroundMusic();
  }

  @override
  void dispose() {
    final audioManager = Provider.of<AudioManager>(context, listen: false);
    audioManager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final balanceProvider = Provider.of<BalanceProvider>(context);
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            'assets/images/home/home_background.png',
            fit: BoxFit.cover,
            width: screenSize.width,
            height: screenSize.height,
          ),
          Positioned(
            top: screenSize.height * 0.1,
            left: 0,
            right: 0,
            child: Center(
              child: Image.asset(
                'assets/images/home/welcomeCasino.png',
                height: screenSize.height * 0.2,
                fit: BoxFit.contain,
              ),
            ),
          ),
          Positioned(
            bottom: screenSize.height * 0.55,
            left: 0,
            right: 0,
            child: Center(
              child: CoinDisplay(coins: balanceProvider.balance),
            ),
          ),
          Positioned(
            bottom: screenSize.height * 0.15,
            left: 0,
            right: 0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: screenSize.width * 0.4,
                      child: MenuButton(
                        text: 'ROULETTE',
                        onPressed: () {
                          Navigator.push(
                            context,
                            AnimatedRoute(page: const RouletteScreen()),
                          );
                        },
                        textColor: const Color(0xFFF44336),
                        textShadow: const [
                          Shadow(
                            color: Colors.red,
                            blurRadius: 10,
                          ),
                        ],
                        borderColor: Colors.red,
                        boxShadowColor: Colors.red,
                      ),
                    ),
                    SizedBox(width: screenSize.width * 0.05),
                    SizedBox(
                      width: screenSize.width * 0.4,
                      child: MenuButton(
                        text: 'BLACK\nJACK',
                        onPressed: () {
                          Navigator.push(context,
                              AnimatedRoute(page: const BlackJackBetScreen()));
                        },
                        lineHeight: 1,
                        textColor: Colors.green,
                        textShadow: const [
                          Shadow(
                            color: Colors.green,
                            blurRadius: 10,
                          ),
                        ],
                        borderColor: Colors.green,
                        boxShadowColor: Colors.green,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: screenSize.height * 0.03),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: screenSize.width * 0.4,
                      child: MenuButton(
                        text: 'HORSE',
                        onPressed: () {
                          Navigator.push(
                            context,
                            AnimatedRoute(page: const HorseScreen()),
                          );
                        },
                        textColor: Colors.blue,
                        textShadow: const [
                          Shadow(
                            color: Colors.blue,
                            blurRadius: 10,
                          ),
                        ],
                        borderColor: const Color(0xFF2196F3),
                        boxShadowColor: Colors.blue,
                      ),
                    ),
                    SizedBox(width: screenSize.width * 0.05),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
