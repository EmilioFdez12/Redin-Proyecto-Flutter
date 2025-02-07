// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api, no_logic_in_create_state

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:redin_app/logic/blackjack/blackjack_game_logic.dart';
import 'package:redin_app/ui/widgets/blackjack/animated_card.dart';
import 'package:redin_app/ui/widgets/blackjack/bet_button.dart';
import 'package:redin_app/utils/database/balance.dart';
import 'package:redin_app/ui/ui.dart';

/// Pantalla principal donde se juega al Blackjack.
/// Esta pantalla muestra la interfaz de usuario del juego, incluyendo las cartas del jugador,
/// las cartas del crupier, y las opciones para realizar apuestas, pedir cartas o plantarse.
/// 
/// [initialBet]: La apuesta inicial con la que el jugador comienza la partida.
class BlackJackScreen extends StatefulWidget {
  const BlackJackScreen({super.key, required this.initialBet});

  final int initialBet;

  @override
  _BlackJackScreenState createState() => _BlackJackScreenState(initialBet: initialBet);
}

class _BlackJackScreenState extends State<BlackJackScreen> {
  final BlackJackGameLogic _game = BlackJackGameLogic();
  late FToast fToast;
  bool _resultProcessed = false;
  int _currentBet;
  bool _hasDoubledOrHalved = false;
  bool _isInitialPhase = true;

  _BlackJackScreenState({required int initialBet}) : _currentBet = initialBet;

  @override
  void initState() {
    super.initState();
    fToast = FToast();
    fToast.init(context);
    _game.startGame(() {
      setState(() {});
    });
  }

  /// Muestra un toast con un mensaje y un color de fondo específico.
  /// 
  /// [message]: El mensaje que se mostrará en el toast.
  /// [backgroundColor]: El color de fondo del toast.
  /// [context]: El contexto de la aplicación.
  void _showToast(String message, Color backgroundColor, BuildContext context) {
    fToast.showToast(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25.0),
          color: backgroundColor,
        ),
        child: Text(
          message,
          style: const TextStyle(fontSize: 18, color: Colors.white),
        ),
      ),
      gravity: ToastGravity.CENTER,
      toastDuration: const Duration(seconds: 2),
    );

    // Navegamos a la pantalla de apuestas después de 2 segundos
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const BlackJackBetScreen(),
        ),
      );
    });
  }

  /// Maneja el resultado del juego y actualiza el saldo del jugador.
  /// 
  /// [result]: El resultado del juego (ganar, perder, empate).
  /// [context]: El contexto de la aplicación.
  void _handleGameResult(String result, BuildContext context) {
    if (!_resultProcessed) {
      final balanceProvider = Provider.of<BalanceProvider>(context, listen: false);
      if (result.contains('Ganaste')) {
        // Si el jugador gana, añade el doble de la apuesta al saldo
        balanceProvider.addCoins(_currentBet * 2);
      } else if (result.contains('Empate')) {
        // Si hay un empate, devuelve la apuesta al jugador
        balanceProvider.addCoins(_currentBet);
      }
      _resultProcessed = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final balanceProvider = Provider.of<BalanceProvider>(context);
    final screenSize = MediaQuery.of(context).size;
    final screenHeight = screenSize.height;

    // Calculamos el puntaje del jugador y del crupier
    int playerScore = _game.calculateHandValue(_game.playerHand);
    int dealerScore = _game.dealerHand.isNotEmpty
        ? _game.calculateHandValue(
            _game.showDealerCard ? _game.dealerHand : [_game.dealerHand[0]])
        : 0;

    // Verificamos si es la fase inicial del juego (primeras dos cartas)
    _isInitialPhase = _game.playerHand.length == 2;

    // Manejamos el resultado del juego cuando este termina
    if (_game.gameOver && !_resultProcessed) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _handleGameResult(_game.result, context);
        if (_game.result.contains('Ganaste')) {
          _showToast(_game.result, Colors.green, context);
        } else if (_game.result.contains('Perdiste')) {
          _showToast(_game.result, Colors.red, context);
        } else {
          _showToast(_game.result, Colors.blue, context);
        }
      });
    }

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
            left: screenSize.width * 0.1,
            child: CoinDisplay(coins: balanceProvider.balance),
          ),
          Positioned(
              top: screenHeight * 0.2,
              left: screenSize.width * 0.3,
              child: Container(
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.red, width: 2.0),
                  color: Colors.red.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Text(
                  'DEALER',
                  style: GoogleFonts.poppins(
                    fontSize: screenHeight * 0.04,
                    fontWeight: FontWeight.w900,
                    color: Colors.red,
                  ),
                ),
              )),
          Positioned(
            top: screenHeight * 0.33,
            left: screenSize.width * 0.7,
            child: _ScoreDisplay(score: dealerScore, color: Colors.red),
          ),

          Positioned(
            top: screenHeight * 0.2,
            left: screenSize.width * 0.12,
            child: _CardStack(
              cards: _game.dealerHand,
              isFaceUp: (index) => index == 0 || _game.showDealerCard,
              isDealer: true,
            ),
          ),
          Positioned(
            top: screenHeight * 0.65,
            left: screenSize.width * 0.1,
            child: _ScoreDisplay(score: playerScore, color: Colors.green),
          ),
          Positioned(
            top: screenHeight * 0.5,
            left: screenSize.width * 0.35,
            child: _CardStack(
              cards: _game.playerHand,
              isFaceUp: (index) => true,
              isDealer: false,
            ),
          ),
          // Botones de apuesta y acciones del juego
          Positioned(
            top: screenHeight * 0.85,
            left: 0,
            right: 0,
            child: BetButtons(
              onHitPressed: () async {
                await _game.hit();
                setState(() {});
              },
              onStandPressed: () async {
                await _game.stand();
                setState(() {});
              },
              onDoublePressed: () {
                setState(() {
                  balanceProvider.subtractCoins(_currentBet);
                  _currentBet *= 2;
                  _hasDoubledOrHalved = true;
                });
              },
              onHalfPressed: () {
                setState(() {
                  balanceProvider.addCoins(_currentBet ~/ 2); 
                  _currentBet ~/= 2;
                  _hasDoubledOrHalved = true;
                });
              },
              isDoubleEnabled: _isInitialPhase && !_hasDoubledOrHalved,
              isHalfEnabled: _isInitialPhase && !_hasDoubledOrHalved,
            ),
          ),
        ],
      ),
    );
  }
}

/// Widget que muestra la puntuación.
class _ScoreDisplay extends StatelessWidget {
  final int score;
  final Color color;

  const _ScoreDisplay({required this.score, required this.color});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Stack(
      children: [
        // Borde blanco
        Text(
          '$score',
          style: TextStyle(
            fontSize: screenWidth * 0.16,
            foreground: Paint()
              ..style = PaintingStyle.stroke
              ..strokeWidth = 4
              ..color = Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        // Texto principal
        Text(
          '$score',
          style: TextStyle(
            fontSize: screenWidth * 0.16,
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

/// Widget para mostrar las cartas una encima de otra.
class _CardStack extends StatelessWidget {
  final List<String> cards;
  final bool Function(int index) isFaceUp;
  final bool isDealer;

  const _CardStack({
    required this.cards,
    required this.isFaceUp,
    required this.isDealer,
  });

  @override
  Widget build(BuildContext context) {
    const double cardWidth = 100.0;
    const double cardHeight = 150.0;
    const double verticalOverlap = 10.0;
    const double horizontalOffset = 32.0;

    return Center(
      child: SizedBox(
        height: cardHeight + (cards.length - 1) * verticalOverlap,
        width: cardWidth + (cards.length - 1) * horizontalOffset,
        child: Stack(
          children: cards.asMap().entries.map((entry) {
            int index = entry.key;
            String card = entry.value;
            final double offsetY = index * verticalOverlap;
            final double offsetX = index * horizontalOffset;

            return Positioned(
              bottom: offsetY,
              left: offsetX,
              child: AnimatedCard(
                card: card,
                isFaceUp: isFaceUp(index),
                isDealer: isDealer,
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}