import 'package:flutter/material.dart';

/// Botones para apostar, se utiliza en 
/// la pantalla de juego del blackjack
class BetButtons extends StatelessWidget {
  final VoidCallback onHitPressed;
  final VoidCallback onStandPressed;
  final VoidCallback onDoublePressed;
  final VoidCallback onHalfPressed;   
  final bool isDoubleEnabled;         
  final bool isHalfEnabled;           

  const BetButtons({
    super.key,
    required this.onHitPressed,
    required this.onStandPressed,
    required this.onDoublePressed,
    required this.onHalfPressed,
    required this.isDoubleEnabled,
    required this.isHalfEnabled,
  });

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    final screenHeight = screenSize.height;

    final buttonWidth = screenWidth * 0.2;
    final buttonHeight = screenHeight * 0.1;
    final roundButtonSize = screenWidth * 0.15;
    final fontSize = screenWidth * 0.05;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Botón HIT
        _buildButton(
          text: "HIT",
          color: Colors.blue,
          borderColor: Colors.blue[300]!,
          width: buttonWidth * 1.2,
          height: buttonHeight * 0.6,
          isRound: false,
          fontSize: fontSize,
          onPressed: onHitPressed,
          isEnabled: true,
        ),
        const SizedBox(width: 10),
        // Botón X2 (redondo)
        _buildButton(
          text: "X2",
          color: Colors.orange,
          borderColor: Colors.orange[300]!,
          width: roundButtonSize,
          height: roundButtonSize,
          isRound: true,
          fontSize: fontSize,
          onPressed: isDoubleEnabled ? onDoublePressed : null,
          isEnabled: isDoubleEnabled,
        ),
        const SizedBox(width: 10),
        // Botón /2 (redondo)
        _buildButton(
          text: "/2",
          color: Colors.green,
          borderColor: Colors.green[300]!,
          width: roundButtonSize,
          height: roundButtonSize,
          isRound: true,
          fontSize: fontSize,
          onPressed: isHalfEnabled ? onHalfPressed : null,
          isEnabled: isHalfEnabled,
        ),
        const SizedBox(width: 10),
        // Botón STAND
        _buildButton(
          text: "STAND",
          color: Colors.red,
          borderColor: Colors.red[300]!,
          width: buttonWidth * 1.2,
          height: buttonHeight * 0.6,
          isRound: false,
          fontSize: fontSize,
          onPressed: onStandPressed,
          isEnabled: true,
        ),
      ],
    );
  }

  /// Winget para hacer un boton default
  Widget _buildButton({
    required String text,
    required Color color,
    required Color borderColor,
    required double width,
    required double height,
    required bool isRound,
    required double fontSize,
    required VoidCallback? onPressed,
    required bool isEnabled,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: isEnabled ? color.withOpacity(0.2) : Colors.grey.withOpacity(0.2), 
          borderRadius: isRound
              ? BorderRadius.circular(height / 2)
              : BorderRadius.circular(12),
          border: Border.all(
            color: isEnabled ? borderColor : Colors.grey, 
            width: 2,
          ),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: isEnabled ? color : Colors.grey,
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}