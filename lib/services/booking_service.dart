import 'dart:convert';
import 'package:sentir/models/booking.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class BookingService {
  static const _bookingsKey = 'bookings';
  final _uuid = const Uuid();

  Future<List<Booking>> getBookingsByUser(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    final bookingsJson = prefs.getString(_bookingsKey);
    
    if (bookingsJson != null) {
      try {
        final List<dynamic> decoded = json.decode(bookingsJson) as List;
        final allBookings = decoded.map((b) => Booking.fromJson(b as Map<String, dynamic>)).toList();
        return allBookings.where((b) => b.userId == userId).toList();
      } catch (e) {
        return [];
      }
    }
    
    return [];
  }

  Future<Booking?> getBookingById(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final bookingsJson = prefs.getString(_bookingsKey);
    
    if (bookingsJson != null) {
      try {
        final List<dynamic> decoded = json.decode(bookingsJson) as List;
        final allBookings = decoded.map((b) => Booking.fromJson(b as Map<String, dynamic>)).toList();
        return allBookings.firstWhere((b) => b.id == id);
      } catch (e) {
        return null;
      }
    }
    
    return null;
  }

  Future<Booking> createBooking(Booking booking) async {
    final prefs = await SharedPreferences.getInstance();
    final bookingsJson = prefs.getString(_bookingsKey);
    
    List<Booking> bookings = [];
    if (bookingsJson != null) {
      try {
        final List<dynamic> decoded = json.decode(bookingsJson) as List;
        bookings = decoded.map((b) => Booking.fromJson(b as Map<String, dynamic>)).toList();
      } catch (e) {
        bookings = [];
      }
    }
    
    final newBooking = booking.copyWith(id: _uuid.v4());
    bookings.add(newBooking);
    
    await prefs.setString(_bookingsKey, json.encode(bookings.map((b) => b.toJson()).toList()));
    return newBooking;
  }

  Future<void> updateBookingStatus(String bookingId, String status) async {
    final prefs = await SharedPreferences.getInstance();
    final bookingsJson = prefs.getString(_bookingsKey);
    
    if (bookingsJson != null) {
      try {
        final List<dynamic> decoded = json.decode(bookingsJson) as List;
        final bookings = decoded.map((b) => Booking.fromJson(b as Map<String, dynamic>)).toList();
        
        final index = bookings.indexWhere((b) => b.id == bookingId);
        if (index != -1) {
          bookings[index] = bookings[index].copyWith(
            status: status,
            updatedAt: DateTime.now(),
          );
          await prefs.setString(_bookingsKey, json.encode(bookings.map((b) => b.toJson()).toList()));
        }
      } catch (e) {
        return;
      }
    }
  }
}
