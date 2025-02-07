import 'package:flutter/material.dart';

/// Anima las cartas del Blackjack 
class AnimatedCard extends StatefulWidget {
  final String card;
  final bool isFaceUp;
  final bool isDealer;

  const AnimatedCard({
    super.key,
    required this.card,
    required this.isFaceUp,
    required this.isDealer,
  });

  @override
  // ignore: library_private_types_in_public_api
  _AnimatedCardState createState() => _AnimatedCardState();
}

class _AnimatedCardState extends State<AnimatedCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _animation = Tween<Offset>(
      begin: const Offset(0, 5),
      end: Offset(0, widget.isDealer ? 0.5 : 0.5),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _animation,
      child: Image.asset(
        'assets/images/blackjack/cards/${widget.isFaceUp ? widget.card : 'Reverso'}.webp',
        height: MediaQuery.of(context).size.height * 0.15,
      ),
    );
  }
}