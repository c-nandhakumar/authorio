import 'package:flutter/material.dart';

class AuthorFavoriteIcon extends StatefulWidget {
  final bool isFavorite;

  const AuthorFavoriteIcon({super.key, required this.isFavorite});

  @override
  _AuthorFavoriteIconState createState() => _AuthorFavoriteIconState();
}

class _AuthorFavoriteIconState extends State<AuthorFavoriteIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.2,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void didUpdateWidget(covariant AuthorFavoriteIcon oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isFavorite != oldWidget.isFavorite) {
      if (widget.isFavorite) {
        _controller.forward().then((onValue) {
          _controller.reverse();
        });
      } else {
        _controller.reverse();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return ScaleTransition(
          scale: _scaleAnimation,
          child: Icon(
            widget.isFavorite ? Icons.favorite_rounded : Icons.favorite_rounded,
            color:
                widget.isFavorite
                    ? Colors.red
                    : Colors.grey.withValues(alpha: 0.25),
          ),
        );
      },
    );
  }
}
