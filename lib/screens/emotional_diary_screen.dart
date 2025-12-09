import 'package:flutter/material.dart';
import 'package:sentir/models/emotional_entry.dart';
import 'package:sentir/models/booking.dart';
import 'package:sentir/models/experience.dart';
import 'package:sentir/services/emotional_diary_service.dart';
import 'package:sentir/services/booking_service.dart';
import 'package:sentir/services/experience_service.dart';
import 'package:sentir/services/user_service.dart';
import 'package:sentir/theme.dart';
import 'package:sentir/widgets/custom_button.dart';
import 'package:intl/intl.dart';

class EmotionalDiaryScreen extends StatefulWidget {
  const EmotionalDiaryScreen({super.key});

  @override
  State<EmotionalDiaryScreen> createState() => _EmotionalDiaryScreenState();
}

class _EmotionalDiaryScreenState extends State<EmotionalDiaryScreen> with SingleTickerProviderStateMixin {
  final _diaryService = EmotionalDiaryService();
  final _bookingService = BookingService();
  final _userService = UserService();
  List<EmotionalEntry> _entries = [];
  List<Booking> _completedBookings = [];
  bool _isLoading = true;
  
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _loadData();
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );
    
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    final user = await _userService.getCurrentUser();
    _entries = await _diaryService.getEntriesByUser(user.id);
    _completedBookings = await _bookingService.getBookingsByUser(user.id);
    _completedBookings = _completedBookings.where((b) => b.status == 'confirmed').toList();
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.warmBeige,
      body: SafeArea(
        child: Column(
          children: [
            // Gradient Header
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    EmotionColors.romanticismo,
                    EmotionColors.romanticismo.withValues(alpha: 0.7),
                  ],
                ),
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
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.auto_stories,
                          color: AppColors.pureWhite,
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 16),
                      const Expanded(
                        child: Text(
                          'Mi Diario Emocional',
                          style: TextStyle(
                            color: AppColors.pureWhite,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Guarda tus momentos y emociones',
                    style: TextStyle(
                      color: AppColors.pureWhite.withValues(alpha: 0.9),
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),

            // Content
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _entries.isEmpty && _completedBookings.isEmpty
                      ? _buildEmptyState()
                      : FadeTransition(
                          opacity: _fadeAnimation,
                          child: SingleChildScrollView(
                            padding: const EdgeInsets.all(24),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (_completedBookings.isNotEmpty) ...[
                                  Row(
                                    children: [
                                      const Icon(Icons.pending_actions, color: AppColors.softYellow, size: 20),
                                      const SizedBox(width: 8),
                                      Text(
                                        'Experiencias por registrar',
                                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 16),
                                  ..._completedBookings.map((booking) => TweenAnimationBuilder<double>(
                                    tween: Tween(begin: 0.0, end: 1.0),
                                    duration: const Duration(milliseconds: 400),
                                    builder: (context, value, child) {
                                      return Transform.scale(
                                        scale: value,
                                        child: Opacity(
                                          opacity: value,
                                          child: child,
                                        ),
                                      );
                                    },
                                    child: _PendingEntryCard(
                                      booking: booking,
                                      onTap: () => _createEntry(booking),
                                    ),
                                  )),
                                  const SizedBox(height: 32),
                                ],
                                if (_entries.isNotEmpty) ...[
                                  Row(
                                    children: [
                                      const Icon(Icons.favorite, color: EmotionColors.romanticismo, size: 20),
                                      const SizedBox(width: 8),
                                      Text(
                                        'Mis emociones guardadas',
                                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 16),
                                  ..._entries.asMap().entries.map((entry) {
                                    final index = entry.key;
                                    final emotionalEntry = entry.value;
                                    return TweenAnimationBuilder<double>(
                                      tween: Tween(begin: 0.0, end: 1.0),
                                      duration: Duration(milliseconds: 400 + (index * 100)),
                                      builder: (context, value, child) {
                                        return Transform.scale(
                                          scale: value,
                                          child: Opacity(
                                            opacity: value,
                                            child: child,
                                          ),
                                        );
                                      },
                                      child: _EntryCard(entry: emotionalEntry),
                                    );
                                  }),
                                ],
                              ],
                            ),
                          ),
                        ),
            ),
          ],
        ),
      ),
      floatingActionButton: _completedBookings.isEmpty
          ? null
          : Container(
              decoration: BoxDecoration(
                gradient: AppGradients.primaryButton,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.jadeGreen.withValues(alpha: 0.4),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: FloatingActionButton.extended(
                onPressed: () => _showNewEntryDialog(),
                backgroundColor: Colors.transparent,
                elevation: 0,
                label: const Text(
                  'Nuevo registro',
                  style: TextStyle(
                    color: AppColors.pureWhite,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                icon: const Icon(Icons.add, color: AppColors.pureWhite),
              ),
            ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(30),
              decoration: BoxDecoration(
                color: EmotionColors.romanticismo.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.auto_stories,
                size: 80,
                color: EmotionColors.romanticismo.withValues(alpha: 0.6),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Tu diario emocional está vacío',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: AppColors.darkGray,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              'Completa experiencias y guarda tus emociones para crear tu historia personal',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.mediumGray,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  void _showNewEntryDialog() {
    if (_completedBookings.isEmpty) return;
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.mediumGray.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Selecciona una experiencia',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ..._completedBookings.map((booking) => ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.jadeGreen.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.check_circle, color: AppColors.jadeGreen),
              ),
              title: Text(
                'Experiencia del ${DateFormat('d MMM').format(booking.date)}',
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                Navigator.pop(context);
                _createEntry(booking);
              },
            )),
          ],
        ),
      ),
    );
  }

  void _createEntry(Booking booking) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => _CreateEntryScreen(booking: booking),
      ),
    ).then((_) => _loadData());
  }
}

class _PendingEntryCard extends StatelessWidget {
  final Booking booking;
  final VoidCallback onTap;

  const _PendingEntryCard({required this.booking, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.softYellow.withValues(alpha: 0.3),
              AppColors.softYellow.withValues(alpha: 0.15),
            ],
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: AppColors.softYellow.withValues(alpha: 0.5),
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.softYellow.withValues(alpha: 0.2),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: const BoxDecoration(
                color: AppColors.softYellow,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.pending_actions,
                color: AppColors.pureWhite,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Experiencia completada',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                      color: AppColors.darkGray,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '¿Qué sentiste? Registra tus emociones',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.mediumGray,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              size: 18,
              color: AppColors.softYellow,
            ),
          ],
        ),
      ),
    );
  }
}

class _EntryCard extends StatelessWidget {
  final EmotionalEntry entry;

  const _EntryCard({required this.entry});

  @override
  Widget build(BuildContext context) {
    final topEmotions = entry.emotions.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.pureWhite,
            AppColors.pureWhite.withValues(alpha: 0.95),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.darkGray.withValues(alpha: 0.08),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: EmotionColors.romanticismo.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.calendar_today,
                      size: 16,
                      color: EmotionColors.romanticismo,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    DateFormat('d MMMM yyyy').format(entry.date),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  gradient: AppGradients.primaryButton,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${topEmotions.length} emociones',
                  style: const TextStyle(
                    color: AppColors.pureWhite,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: topEmotions.take(3).map((e) => _EmotionBadge(
              emotion: e.key,
              value: e.value,
            )).toList(),
          ),
          if (entry.notes.isNotEmpty) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.warmBeige.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                entry.notes,
                style: Theme.of(context).textTheme.bodyMedium,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _EmotionBadge extends StatelessWidget {
  final String emotion;
  final int value;

  const _EmotionBadge({required this.emotion, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.skyBlue.withValues(alpha: 0.2),
            AppColors.skyBlue.withValues(alpha: 0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: AppColors.skyBlue.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            emotion,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.darkGray,
            ),
          ),
          const SizedBox(width: 6),
          ...List.generate(
            value,
            (index) => const Icon(
              Icons.star,
              size: 14,
              color: AppColors.softYellow,
            ),
          ),
        ],
      ),
    );
  }
}

// Keep the rest of the _CreateEntryScreen and _EmotionRater classes unchanged
class _CreateEntryScreen extends StatefulWidget {
  final Booking booking;

  const _CreateEntryScreen({required this.booking});

  @override
  State<_CreateEntryScreen> createState() => _CreateEntryScreenState();
}

class _CreateEntryScreenState extends State<_CreateEntryScreen> {
  final _diaryService = EmotionalDiaryService();
  final _experienceService = ExperienceService();
  final _userService = UserService();
  final _notesController = TextEditingController();
  final Map<String, int> _emotions = {
    'feliz': 0,
    'relajado': 0,
    'emocionado': 0,
    'inspirado': 0,
    'conectado': 0,
    'renovado': 0,
  };
  Experience? _experience;
  bool _isLoading = true;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _loadExperience();
  }

  Future<void> _loadExperience() async {
    _experience = await _experienceService.getExperienceById(widget.booking.experienceId);
    setState(() => _isLoading = false);
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading || _experience == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('¿Qué sentiste hoy?'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.pureWhite,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      _experience!.imageUrl,
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      _experience!.title,
                      style: Theme.of(context).textTheme.titleMedium,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            Text(
              'Califica tus emociones',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'Toca las estrellas para calificar cada emoción',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 16),
            ..._emotions.keys.map((emotion) => _EmotionRater(
              emotion: emotion,
              rating: _emotions[emotion]!,
              onRatingChanged: (rating) {
                setState(() => _emotions[emotion] = rating);
              },
            )),
            const SizedBox(height: 32),
            Text(
              'Cuéntanos más',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _notesController,
              maxLines: 5,
              decoration: const InputDecoration(
                hintText: 'Describe lo que sentiste, lo que viviste, lo que aprendiste...',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 32),
            CustomButton(
              text: 'Guardar mi emoción',
              onPressed: _saveEntry,
              isLoading: _isSaving,
              icon: Icons.favorite,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _saveEntry() async {
    final hasRatings = _emotions.values.any((rating) => rating > 0);
    if (!hasRatings) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor califica al menos una emoción')),
      );
      return;
    }

    setState(() => _isSaving = true);

    try {
      final user = await _userService.getCurrentUser();
      final now = DateTime.now();
      
      final entry = EmotionalEntry(
        id: '',
        userId: user.id,
        experienceId: widget.booking.experienceId,
        bookingId: widget.booking.id,
        emotions: Map.from(_emotions)..removeWhere((key, value) => value == 0),
        notes: _notesController.text,
        date: now,
        createdAt: now,
      );

      await _diaryService.createEntry(entry);

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('¡Emoción guardada! 💫')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error al guardar la entrada')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }
}

class _EmotionRater extends StatelessWidget {
  final String emotion;
  final int rating;
  final ValueChanged<int> onRatingChanged;

  const _EmotionRater({
    required this.emotion,
    required this.rating,
    required this.onRatingChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.pureWhite,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            emotion.substring(0, 1).toUpperCase() + emotion.substring(1),
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          Row(
            children: List.generate(5, (index) {
              return GestureDetector(
                onTap: () => onRatingChanged(index + 1),
                child: Icon(
                  index < rating ? Icons.star : Icons.star_border,
                  color: AppColors.softYellow,
                  size: 28,
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
