import 'package:pet_care/models/appointment.dart';
import 'package:pet_care/models/status.dart';

enum Method { cash, khqr }

class Payment {
  final String id;
  final Appointment appointment;
  final double amount;
  Method? method;
  final PaymentStatus paymentStatus;
  final DateTime paidAt;

  Payment({
    required this.id,
    required this.appointment,
    required this.amount,
    required this.paymentStatus,
    required this.paidAt,
    this.method,
  });
}
