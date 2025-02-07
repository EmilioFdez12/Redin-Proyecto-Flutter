import 'package:flutter/material.dart';

/// Grid de numeros, permite apostar por
/// 1, 2, 3 o 4 numeros que conformen la ruleta
class NumberGrid extends StatelessWidget {
  final int start;
  final int end;
  final Set<int> selectedNumbers;
  final Function(int) onNumberSelected;
  final VoidCallback onClose;

  const NumberGrid({
    super.key,
    required this.start,
    required this.end,
    required this.selectedNumbers,
    required this.onNumberSelected,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final horizontalPadding = screenWidth * 0.15;

    return GestureDetector(
      onTap: onClose,
      child: GridView.builder(
        padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
        shrinkWrap: true,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 6,
          crossAxisSpacing: 4,
          mainAxisSpacing: 4,
          childAspectRatio: 1,
        ),
        itemCount: end - start + 1,
        itemBuilder: (context, index) {
          final number = start + index;
          final isSelected = selectedNumbers.contains(number);

          return GestureDetector(
            onTap: () => onNumberSelected(number),
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: isSelected ? Colors.white : Colors.black,
                borderRadius: BorderRadius.zero,
              ),
              child: Text(
                '$number',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isSelected ? Colors.black : Colors.white,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
