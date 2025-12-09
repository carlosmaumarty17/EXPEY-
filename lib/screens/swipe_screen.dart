import 'package:flutter/material.dart';
import 'package:sentir/models/emotion.dart';
import 'package:sentir/models/experience.dart';
import 'package:sentir/services/experience_service.dart';
import 'package:sentir/theme.dart';
import 'package:sentir/widgets/swipeable_card_stack.dart';
import 'package:sentir/screens/experience_detail_screen.dart';

class SwipeScreen extends StatefulWidget {
  final Emotion? emotion;

  const SwipeScreen({super.key, this.emotion});

  @override
  State<SwipeScreen> createState() => _SwipeScreenState();
}

class _SwipeScreenState extends State<SwipeScreen>
    with TickerProviderStateMixin {
  final _experienceService = ExperienceService();
  List<Experience> _experiences = [];
  bool _isLoading = true;
  final GlobalKey<SwipeableCardStackState> _stackKey = GlobalKey();

  late AnimationController _headerController;
  late Animation<double> _headerFadeAnimation;

  @override
  void initState() {
    super.initState();
    _loadExperiences();
    _setupAnimations();
  }

  void _setupAnimations() {
    _headerController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _headerFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _headerController, curve: Curves.easeOut),
    );

    _headerController.forward();
  }

  Future<void> _loadExperiences() async {
    setState(() => _isLoading = true);

    List<Experience> allExperiences;
    if (widget.emotion != null) {
      allExperiences =
          await _experienceService.getExperiencesByEmotion(widget.emotion!.id);
    } else {
      allExperiences = await _experienceService.getAllExperiences();
    }

    setState(() {
      _experiences = allExperiences;
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    _headerController.dispose();
    super.dispose();
  }

  void _handleSwipeLeft(Experience experience) {
    debugPrint('Passed: ${experience.title}');
  }

  void _handleSwipeRight(Experience experience) {
    _navigateToDetail(experience);
  }

  void _handleCardTap(Experience experience) {
    _navigateToDetail(experience);
  }

  void _handleEmpty() {
    _showEndDialog();
  }

  void _showEndDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          '🎉 ¡Has visto todas las experiencias!',
          textAlign: TextAlign.center,
        ),
        content: const Text(
          'No hay más experiencias en esta categoría. Explora otras emociones.',
          textAlign: TextAlign.center,
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Go back to categories
            },
            child: const Text('Volver a categorías'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final emotion = widget.emotion;
    final bgColor =
        emotion?.color.withValues(alpha: 0.05) ?? AppColors.warmBeige;

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            FadeTransition(
              opacity: _headerFadeAnimation,
              child: Container(
                decoration: BoxDecoration(
                  gradient: emotion != null
                      ? LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            emotion.color,
                            emotion.color.withValues(alpha: 0.7),
                          ],
                        )
                      : AppGradients.primaryHeader,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                ),
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back,
                              color: AppColors.pureWhite),
                          onPressed: () => Navigator.pop(context),
                        ),
                        const SizedBox(width: 8),
                        if (emotion != null)
                          Icon(emotion.icon,
                              color: AppColors.pureWhite, size: 28),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            emotion?.name ?? 'Todas las experiencias',
                            style: const TextStyle(
                              color: AppColors.pureWhite,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Desliza para descubrir',
                      style: TextStyle(
                        color: AppColors.pureWhite,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '← Pasar  |  Me gusta →',
                      style: TextStyle(
                        color: AppColors.pureWhite.withValues(alpha: 0.9),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Loading or Card Stack
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _experiences.isEmpty
                      ? _buildEmptyState()
                      : Column(
                          children: [
                            // Swipe Hints
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 40),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.arrow_back,
                                        color: AppColors.coral
                                            .withValues(alpha: 0.6),
                                        size: 20,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        'Pasar',
                                        style: TextStyle(
                                          color: AppColors.coral
                                              .withValues(alpha: 0.6),
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        'Me gusta',
                                        style: TextStyle(
                                          color: AppColors.jadeGreen
                                              .withValues(alpha: 0.6),
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const SizedBox(width: 4),
                                      Icon(
                                        Icons.arrow_forward,
                                        color: AppColors.jadeGreen
                                            .withValues(alpha: 0.6),
                                        size: 20,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),

                            // Card Stack
                            Expanded(
                              child: SwipeableCardStack(
                                key: _stackKey,
                                experiences: _experiences,
                                onSwipeLeft: _handleSwipeLeft,
                                onSwipeRight: _handleSwipeRight,
                                onTap: _handleCardTap,
                                onEmpty: _handleEmpty,
                              ),
                            ),

                            // Action Buttons
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 30),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  _buildActionButton(
                                    icon: Icons.close,
                                    color: AppColors.coral,
                                    onTap: () =>
                                        _stackKey.currentState?.swipeLeft(),
                                  ),
                                  _buildActionButton(
                                    icon: Icons.favorite,
                                    color: AppColors.jadeGreen,
                                    size: 70,
                                    iconSize: 32,
                                    onTap: () =>
                                        _stackKey.currentState?.swipeRight(),
                                  ),
                                  _buildActionButton(
                                    icon: Icons.info_outline,
                                    color: AppColors.skyBlue,
                                    onTap: () {
                                      if (_stackKey.currentState?.hasMore ??
                                          false) {
                                        _navigateToDetail(_experiences[0]);
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
    double size = 60,
    double iconSize = 28,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: AppColors.pureWhite,
          shape: BoxShape.circle,
          border: Border.all(color: color, width: 3),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.3),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Icon(icon, color: color, size: iconSize),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.explore_off,
            size: 80,
            color: AppColors.mediumGray.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'No hay experiencias en esta categoría',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: AppColors.mediumGray,
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  void _navigateToDetail(Experience experience) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            ExperienceDetailScreen(experience: experience),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
      ),
    );
  }
}
