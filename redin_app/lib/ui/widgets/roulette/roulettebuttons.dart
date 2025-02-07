import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RouletteButton extends StatelessWidget {
  final Color color;
  final String label;
  final VoidCallback onPressed;
  final bool isActive;
  final bool isRound; // Nuevo parámetro para definir si el botón es redondo

  const RouletteButton({
    super.key,
    required this.color,
    required this.label,
    required this.onPressed,
    this.isActive = false,
    this.isRound = false, // Por defecto, el botón es rectangular
  });

  @override
  Widget build(BuildContext context) {
    // Obtenemos el tamaño de la pantalla
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Tamaños responsive
    final buttonWidth = screenWidth * 0.2;
    final buttonHeight = screenHeight * 0.07;
    final fontSize = screenWidth * 0.04;

    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: buttonWidth,
        height: buttonHeight,
        decoration: BoxDecoration(
          color: isActive ? color : color.withOpacity(0.3),
          borderRadius: isRound
              ? BorderRadius.circular(buttonHeight / 2) 
              : BorderRadius.circular(12), 
          border: Border.all(
            color: isActive ? color.withOpacity(0.7) : color,
            width: isActive ? 4 : 2, // Grosor del borde
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: GoogleFonts.poppins(
              color: isActive ? Colors.black : color, 
              fontSize: fontSize,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}