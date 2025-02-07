import 'package:flutter/material.dart';

/// Crea a un caballa con su propia calle
class HorseRaceTrack extends StatelessWidget {
  final String horseImagePath;
  final double offset;

  const HorseRaceTrack({
    super.key,
    required this.horseImagePath,
    required this.offset,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 325,
      height: 50,
      child: Stack(
        children: [
          // Rail (pista)
          Positioned(
            top: 35,
            left: 0,
            right: 0,
            child: Image.asset(
              'assets/images/horse/rail.png',
              width: 325,
              height: 10,
              fit: BoxFit.cover,
            ),
          ),
          // Caballo
          Positioned(
            top: 0,
            left: offset,
            child: Image(
              image: AssetImage(horseImagePath),
              width: 50,
              height: 50,
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    );
  }
}