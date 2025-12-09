import 'package:flutter/material.dart';
import 'package:sentir/models/experience.dart';
import 'package:sentir/widgets/swipeable_experience_card.dart';

class SwipeableCardStack extends StatefulWidget {
  final List<Experience> experiences;
  final Function(Experience) onSwipeLeft;
  final Function(Experience) onSwipeRight;
  final Function(Experience) onTap;
  final VoidCallback? onEmpty;

  const SwipeableCardStack({
    super.key,
    required this.experiences,
    required this.onSwipeLeft,
    required this.onSwipeRight,
    required this.onTap,
    this.onEmpty,
  });

  @override
  State<SwipeableCardStack> createState() => SwipeableCardStackState();
}

class SwipeableCardStackState extends State<SwipeableCardStack> {
  int _currentIndex = 0;
  final GlobalKey<SwipeableExperienceCardState> _cardKey = GlobalKey();

  bool get hasMore => _currentIndex < widget.experiences.length;

  void swipeLeft() {
    _cardKey.currentState?.programmaticSwipe(false);
  }

  void swipeRight() {
    _cardKey.currentState?.programmaticSwipe(true);
  }

  void _handleSwipeLeft() {
    if (_currentIndex < widget.experiences.length) {
      widget.onSwipeLeft(widget.experiences[_currentIndex]);
      setState(() => _currentIndex++);

      if (_currentIndex >= widget.experiences.length) {
        widget.onEmpty?.call();
      }
    }
  }

  void _handleSwipeRight() {
    if (_currentIndex < widget.experiences.length) {
      widget.onSwipeRight(widget.experiences[_currentIndex]);
      setState(() => _currentIndex++);

      if (_currentIndex >= widget.experiences.length) {
        widget.onEmpty?.call();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_currentIndex >= widget.experiences.length) {
      return const SizedBox.shrink();
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final cardWidth = constraints.maxWidth * 0.9;
        final cardHeight = constraints.maxHeight * 0.9;

        return Stack(
          alignment: Alignment.center,
          children: [
            // Card 3 (back)
            if (_currentIndex + 2 < widget.experiences.length)
              Transform.scale(
                scale: 0.85,
                child: Transform.translate(
                  offset: const Offset(0, 20),
                  child: Opacity(
                    opacity: 0.5,
                    child: _buildCard(
                      widget.experiences[_currentIndex + 2],
                      false,
                      cardWidth,
                      cardHeight,
                    ),
                  ),
                ),
              ),

            // Card 2 (middle)
            if (_currentIndex + 1 < widget.experiences.length)
              Transform.scale(
                scale: 0.92,
                child: Transform.translate(
                  offset: const Offset(0, 10),
                  child: Opacity(
                    opacity: 0.7,
                    child: _buildCard(
                      widget.experiences[_currentIndex + 1],
                      false,
                      cardWidth,
                      cardHeight,
                    ),
                  ),
                ),
              ),

            // Card 1 (front) - Interactive
            SizedBox(
              width: cardWidth,
              height: cardHeight,
              child: SwipeableExperienceCard(
                key: _cardKey,
                experience: widget.experiences[_currentIndex],
                onSwipeLeft: _handleSwipeLeft,
                onSwipeRight: _handleSwipeRight,
                onTap: () => widget.onTap(widget.experiences[_currentIndex]),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildCard(
      Experience experience, bool interactive, double width, double height) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(25),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              experience.imageUrl,
              fit: BoxFit.cover,
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.3),
                    Colors.black.withValues(alpha: 0.7),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
