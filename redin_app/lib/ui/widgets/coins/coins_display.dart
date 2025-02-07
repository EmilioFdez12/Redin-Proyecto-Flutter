import 'package:flutter/material.dart';

/// Container donde se muestra
/// el saldo actual del usuario
class CoinDisplay extends StatelessWidget {
  final int coins;

  const CoinDisplay({super.key, required this.coins});

  @override
  Widget build(BuildContext context) {
    // Obtenemos el tamaño de la pantalla
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final fontSize = screenWidth * 0.06;
    final horizontalPadding = screenWidth * 0.05;
    final verticalPadding = screenHeight * 0.01;
    final imageSize = screenWidth * 0.15;

    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        DecoratedBox(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [
                Color(0xFF515151),
                Color(0xFF000000),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: BorderRadius.circular(50),
            border: Border.all(
              color: const Color.fromARGB(150, 255, 255, 255),
              width: 2, // Grosor del borde
            ),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: horizontalPadding * 2.5, vertical: verticalPadding),
            child: Text(
              '$coins',
              style: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
        Positioned(
          left: -imageSize * 0.3,
          child: Image.asset(
            'assets/images/redin_logo.png',
            width: imageSize,
            height: imageSize,
          ),
        ),
      ],
    );
  }
}
