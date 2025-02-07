import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Boton utilizado en el menú
/// Se utiliza para cada juego implementado
class MenuButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final double width;
  final double height;
  final Color textColor;
  final List<Shadow> textShadow;
  final Color borderColor;
  final Color boxShadowColor;
  final double? lineHeight;

  const MenuButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.width = 120,
    this.height = 120,
    this.textColor = Colors.white,
    this.textShadow = const [],
    this.borderColor = Colors.white,
    this.boxShadowColor = Colors.white,
    this.lineHeight,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final textSize = screenWidth * 0.056;

    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: const Color(0xFF000000),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: borderColor,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: boxShadowColor,
              blurRadius: 10,
              offset: const Offset(0, 0),
            ),
          ],
        ),
        child: Center(
          child: Text(
            text,
            style: GoogleFonts.poppins(
              color: textColor,
              fontSize: textSize,
              fontWeight: FontWeight.w900,
              height: lineHeight,
              shadows: textShadow,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}