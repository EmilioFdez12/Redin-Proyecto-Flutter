import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

/// Boton para seleccionar a que caballo se va a 
/// apostar para utilizar en la pantalla de caballos
class HorseButton extends HookWidget {
  final Color color;
  final Color borderColor;
  final double size;
  final bool isActive;
  final VoidCallback onPressed;

  const HorseButton({
    super.key,
    required this.color,
    required this.borderColor,
    required this.size,
    required this.isActive,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: isActive ? color : color.withOpacity(0.2),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isActive ? borderColor : borderColor,
            width: 2,
          ),
        ),
      ),
    );
  }
}