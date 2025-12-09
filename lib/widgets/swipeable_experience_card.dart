import 'package:flutter/material.dart';
import 'package:sentir/models/experience.dart';
import 'package:sentir/theme.dart';
import 'package:intl/intl.dart';

class SwipeableExperienceCard extends StatefulWidget {
  final Experience experience;
  final VoidCallback onSwipeLeft;
  final VoidCallback onSwipeRight;
  final VoidCallback onTap;

  const SwipeableExperienceCard({
    super.key,
    required this.experience,
    required this.onSwipeLeft,
    required this.onSwipeRight,
    required this.onTap,
  });

  @override
  State<SwipeableExperienceCard> createState() =>
      SwipeableExperienceCardState();
}

class SwipeableExperienceCardState extends State<SwipeableExperienceCard>
    with SingleTickerProviderStateMixin {
  Offset _position = Offset.zero;
  late AnimationController _animationController;
  late Animation<Offset> _animation;
  double _rotation = 0.0;

  static const double _swipeThreshold = 100.0;
  static const double _maxRotation = 0.26; // ~15 degrees

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onPanStart(DragStartDetails details) {
    // Start drag
  }

  void _onPanUpdate(DragUpdateDetails details) {
    setState(() {
      _position += details.delta;
      _rotation = _position.dx / 1000 * _maxRotation;
    });
  }

  void _onPanEnd(DragEndDetails details) {
    if (_position.dx.abs() > _swipeThreshold) {
      // Complete the swipe
      _completeSwipe();
    } else {
      // Return to center
      _returnToCenter();
    }
  }

  void _completeSwipe() {
    final screenWidth = MediaQuery.of(context).size.width;
    final direction = _position.dx > 0 ? 1 : -1;

    _animation = Tween<Offset>(
      begin: _position,
      end: Offset(screenWidth * 1.5 * direction, _position.dy),
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _animationController.forward(from: 0).then((_) {
      if (direction > 0) {
        widget.onSwipeRight();
      } else {
        widget.onSwipeLeft();
      }
    });

    _animation.addListener(() {
      setState(() {
        _position = _animation.value;
        _rotation = _position.dx / 1000 * _maxRotation;
      });
    });
  }

  void _returnToCenter() {
    _animation = Tween<Offset>(
      begin: _position,
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );

    _animationController.forward(from: 0);

    _animation.addListener(() {
      setState(() {
        _position = _animation.value;
        _rotation = _position.dx / 1000 * _maxRotation;
      });
    });
  }

  void programmaticSwipe(bool isRight) {
    final screenWidth = MediaQuery.of(context).size.width;
    final direction = isRight ? 1 : -1;

    _animation = Tween<Offset>(
      begin: Offset.zero,
      end: Offset(screenWidth * 1.5 * direction, -100),
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _animationController.forward(from: 0).then((_) {
      if (isRight) {
        widget.onSwipeRight();
      } else {
        widget.onSwipeLeft();
      }
    });

    _animation.addListener(() {
      setState(() {
        _position = _animation.value;
        _rotation = _position.dx / 1000 * _maxRotation;
      });
    });
  }

  Color _getOverlayColor() {
    if (_position.dx > 0) {
      return AppColors.jadeGreen;
    } else {
      return AppColors.coral;
    }
  }

  double _getOverlayOpacity() {
    final opacity = (_position.dx.abs() / _swipeThreshold).clamp(0.0, 1.0);
    return opacity * 0.5;
  }

  IconData _getOverlayIcon() {
    return _position.dx > 0 ? Icons.favorite : Icons.close;
  }

  @override
  Widget build(BuildContext context) {
    final currencyFormat =
        NumberFormat.currency(symbol: '\$', decimalDigits: 0);

    return GestureDetector(
      onPanStart: _onPanStart,
      onPanUpdate: _onPanUpdate,
      onPanEnd: _onPanEnd,
      onTap: widget.onTap,
      child: Transform.translate(
        offset: _position,
        child: Transform.rotate(
          angle: _rotation,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              boxShadow: [
                BoxShadow(
                  color: AppColors.darkGray.withValues(alpha: 0.2),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(25),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // Background Image
                  Image.asset(
                    widget.experience.imageUrl,
                    fit: BoxFit.cover,
                  ),

                  // Gradient Overlay
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          AppColors.darkGray.withValues(alpha: 0.3),
                          AppColors.darkGray.withValues(alpha: 0.9),
                        ],
                      ),
                    ),
                  ),

                  // Swipe Direction Overlay
                  if (_position.dx.abs() > 20)
                    Container(
                      decoration: BoxDecoration(
                        color: _getOverlayColor().withValues(
                          alpha: _getOverlayOpacity(),
                        ),
                      ),
                      child: Center(
                        child: Transform.rotate(
                          angle: _position.dx > 0 ? -0.3 : 0.3,
                          child: Icon(
                            _getOverlayIcon(),
                            size: 120,
                            color: AppColors.pureWhite,
                          ),
                        ),
                      ),
                    ),

                  // Content
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Rating Badge
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.pureWhite,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.star,
                                  size: 16,
                                  color: AppColors.softYellow,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  widget.experience.rating.toStringAsFixed(1),
                                  style: const TextStyle(
                                    color: AppColors.darkGray,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Title
                          Text(
                            widget.experience.title,
                            style: const TextStyle(
                              color: AppColors.pureWhite,
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 12),

                          // Location
                          Row(
                            children: [
                              const Icon(
                                Icons.location_on,
                                size: 18,
                                color: AppColors.pureWhite,
                              ),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  widget.experience.location,
                                  style: TextStyle(
                                    color: AppColors.pureWhite
                                        .withValues(alpha: 0.9),
                                    fontSize: 16,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),

                          // Duration and Price
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.access_time,
                                      size: 18,
                                      color: AppColors.pureWhite,
                                    ),
                                    const SizedBox(width: 6),
                                    Flexible(
                                      child: Text(
                                        widget.experience.duration,
                                        style: const TextStyle(
                                          color: AppColors.pureWhite,
                                          fontSize: 16,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                currencyFormat.format(widget.experience.price),
                                style: const TextStyle(
                                  color: AppColors.softYellow,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
