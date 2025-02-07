  import 'package:flutter/material.dart';

  /// Selector que permite elegir monedas 
  /// de 1 en 1 o de 50 en 50
  class CoinSelector extends StatelessWidget {
    final int coinValue;
    final Function(int) onCoinChanged;

    const CoinSelector({
      super.key,
      required this.coinValue,
      required this.onCoinChanged,
    });

    @override
    Widget build(BuildContext context) {
      // Obtenemos el tamaño de la pantalla
      final screenSize = MediaQuery.of(context).size;
      final screenWidth = screenSize.width;
      final screenHeight = screenSize.height;

      final iconSize = screenWidth * 0.08;
      final fontSize = screenWidth * 0.06;
      final paddingHorizontal = screenWidth ;
      final paddingVertical = screenHeight;

      return Container(
        padding: EdgeInsets.symmetric(
          horizontal: paddingHorizontal * 0.01,
          vertical: paddingVertical * 0.001,
        ),
        decoration: BoxDecoration(
          color: const Color.fromRGBO(0, 0, 0, 64),
          border: Border.all(
            color: const Color.fromARGB(255, 0, 0, 0),
            width: 2,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(
                Icons.chevron_left,
                color: Colors.red,
                size: iconSize,
              ),
              onPressed: () {
                if (coinValue >= 50) {
                  onCoinChanged(coinValue - 50);
                }
              },
            ),
            IconButton(
              icon: Icon(
                Icons.remove,
                color: Colors.white,
                size: iconSize,
              ),
              onPressed: () {
                if (coinValue > 1) {
                  onCoinChanged(coinValue - 1);
                }
              },
            ),
            SizedBox(width: paddingHorizontal * 0.04),
            Text(
              '$coinValue', 
              style: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(width: paddingHorizontal * 0.04),
            IconButton(
              icon: Icon(
                Icons.add,
                color: Colors.white,
                size: iconSize,
              ),
              onPressed: () {
                onCoinChanged(coinValue + 1);
              },
            ),
            IconButton(
              icon: Icon(
                Icons.chevron_right,
                color: Colors.green,
                size: iconSize,
              ),
              onPressed: () {
                onCoinChanged(coinValue + 50);
              },
            ),
          ],
        ),
      );
    }
  }