import 'dart:convert';
import 'package:sentir/models/emotional_entry.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class EmotionalDiaryService {
  static const _entriesKey = 'emotional_entries';
  final _uuid = const Uuid();

  Future<List<EmotionalEntry>> getEntriesByUser(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    final entriesJson = prefs.getString(_entriesKey);
    
    if (entriesJson != null) {
      try {
        final List<dynamic> decoded = json.decode(entriesJson) as List;
        final allEntries = decoded.map((e) => EmotionalEntry.fromJson(e as Map<String, dynamic>)).toList();
        return allEntries.where((e) => e.userId == userId).toList()
          ..sort((a, b) => b.date.compareTo(a.date));
      } catch (e) {
        return [];
      }
    }
    
    return [];
  }

  Future<EmotionalEntry> createEntry(EmotionalEntry entry) async {
    final prefs = await SharedPreferences.getInstance();
    final entriesJson = prefs.getString(_entriesKey);
    
    List<EmotionalEntry> entries = [];
    if (entriesJson != null) {
      try {
        final List<dynamic> decoded = json.decode(entriesJson) as List;
        entries = decoded.map((e) => EmotionalEntry.fromJson(e as Map<String, dynamic>)).toList();
      } catch (e) {
        entries = [];
      }
    }
    
    final newEntry = entry.copyWith(id: _uuid.v4());
    entries.add(newEntry);
    
    await prefs.setString(_entriesKey, json.encode(entries.map((e) => e.toJson()).toList()));
    return newEntry;
  }

  Future<void> updateEntry(EmotionalEntry entry) async {
    final prefs = await SharedPreferences.getInstance();
    final entriesJson = prefs.getString(_entriesKey);
    
    if (entriesJson != null) {
      try {
        final List<dynamic> decoded = json.decode(entriesJson) as List;
        final entries = decoded.map((e) => EmotionalEntry.fromJson(e as Map<String, dynamic>)).toList();
        
        final index = entries.indexWhere((e) => e.id == entry.id);
        if (index != -1) {
          entries[index] = entry;
          await prefs.setString(_entriesKey, json.encode(entries.map((e) => e.toJson()).toList()));
        }
      } catch (e) {
        return;
      }
    }
  }

  Future<Map<String, dynamic>> getEmotionalStats(String userId) async {
    final entries = await getEntriesByUser(userId);
    
    if (entries.isEmpty) {
      return {
        'totalEntries': 0,
        'emotionDistribution': <String, int>{},
        'averageRatings': <String, double>{},
      };
    }
    
    final Map<String, List<int>> emotionValues = {};
    
    for (final entry in entries) {
      for (final emotion in entry.emotions.entries) {
        if (!emotionValues.containsKey(emotion.key)) {
          emotionValues[emotion.key] = [];
        }
        emotionValues[emotion.key]!.add(emotion.value);
      }
    }
    
    final Map<String, double> averageRatings = {};
    for (final emotion in emotionValues.entries) {
      final sum = emotion.value.reduce((a, b) => a + b);
      averageRatings[emotion.key] = sum / emotion.value.length;
    }
    
    final Map<String, int> emotionDistribution = {};
    for (final emotion in emotionValues.entries) {
      emotionDistribution[emotion.key] = emotion.value.length;
    }
    
    return {
      'totalEntries': entries.length,
      'emotionDistribution': emotionDistribution,
      'averageRatings': averageRatings,
    };
  }
}
