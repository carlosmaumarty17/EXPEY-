import 'package:flutter/material.dart';
import 'package:sentir/models/emotion.dart';
import 'package:sentir/models/experience.dart';
import 'package:sentir/services/experience_service.dart';
import 'package:sentir/theme.dart';
import 'package:sentir/widgets/experience_swipe_card.dart';
import 'package:sentir/screens/experience_detail_screen.dart';

class ExploreScreen extends StatefulWidget {
  final Emotion? emotion;

  const ExploreScreen({super.key, this.emotion});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  final _experienceService = ExperienceService();
  List<Experience> _experiences = [];
  int _currentIndex = 0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadExperiences();
  }

  Future<void> _loadExperiences() async {
    setState(() => _isLoading = true);
    
    if (widget.emotion != null) {
      _experiences = await _experienceService.getExperiencesByEmotion(widget.emotion!.id);
    } else {
      _experiences = await _experienceService.getAllExperiences();
    }
    
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    final emotion = widget.emotion;
    final bgColor = emotion?.color.withValues(alpha: 0.05) ?? AppColors.warmBeige;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(emotion?.name ?? 'Todas las experiencias'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: emotion?.color ?? AppColors.darkGray),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _experiences.isEmpty
              ? _buildEmptyState()
              : _buildSwipeCards(),
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
            'No hay experiencias disponibles',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: AppColors.mediumGray,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Intenta con otra emoción',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.mediumGray,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSwipeCards() {
    return Stack(
      children: [
        Positioned.fill(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.65,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    if (_currentIndex < _experiences.length)
                      ExperienceSwipeCard(
                        experience: _experiences[_currentIndex],
                        onTap: () => _navigateToDetail(_experiences[_currentIndex]),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              _buildActionButtons(),
              const SizedBox(height: 40),
            ],
          ),
        ),
        Positioned(
          top: 20,
          left: 0,
          right: 0,
          child: Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.pureWhite,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '${_currentIndex + 1} / ${_experiences.length}',
                style: const TextStyle(
                  color: AppColors.darkGray,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildActionButton(
          icon: Icons.close,
          color: AppColors.coral,
          onTap: _onSkip,
        ),
        const SizedBox(width: 30),
        _buildActionButton(
          icon: Icons.favorite,
          color: AppColors.jadeGreen,
          size: 70,
          iconSize: 32,
          onTap: () => _onLike(_experiences[_currentIndex]),
        ),
        const SizedBox(width: 30),
        _buildActionButton(
          icon: Icons.info_outline,
          color: AppColors.skyBlue,
          onTap: () => _navigateToDetail(_experiences[_currentIndex]),
        ),
      ],
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
        ),
        child: Icon(icon, color: color, size: iconSize),
      ),
    );
  }

  void _onSkip() {
    if (_currentIndex < _experiences.length - 1) {
      setState(() => _currentIndex++);
    } else {
      _showEndMessage('Has visto todas las experiencias');
    }
  }

  void _onLike(Experience experience) {
    _navigateToDetail(experience);
  }

  void _navigateToDetail(Experience experience) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ExperienceDetailScreen(experience: experience),
      ),
    );
  }

  void _showEndMessage(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('🌈'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('Volver al inicio'),
          ),
        ],
      ),
    );
  }
}
