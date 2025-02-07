import 'package:flutter/material.dart';

/// Boton para iniciar un juego tras apostar
class SpinButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;

  const SpinButton({
    super.key,
    required this.label,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    // Obtenemos el tamaño de la pantalla
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final fontSize = screenWidth * 0.06;
    final verticalPadding = screenHeight * 0.015;
    final horizontalPadding = screenWidth * 0.15;
    final borderRadius = screenWidth * 0.5;
    final borderWidth = screenWidth * 0.008;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        gradient: const LinearGradient(
          colors: [
            Color.fromARGB(255, 255, 169, 71),
            Color.fromARGB(255, 255, 223, 117),
            Color.fromARGB(255, 255, 170, 42),
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(borderWidth),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius),
            ),
            padding: EdgeInsets.symmetric(
              vertical: verticalPadding,
              horizontal: horizontalPadding,
            ),
            elevation: 0,
          ),
          onPressed: onPressed,
          child: ShaderMask(
            shaderCallback: (Rect bounds) {
              return const LinearGradient(
                colors: [
                  Color.fromARGB(255, 255, 169, 71),
                  Color.fromARGB(255, 255, 223, 117),
                  Color.fromARGB(255, 255, 170, 42),
                ],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ).createShader(bounds);
            },
            child: Text(
              label,
              style: TextStyle(
                color: Colors.white,
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
