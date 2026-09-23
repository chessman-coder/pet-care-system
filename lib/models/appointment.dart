import 'package:pet_care/models/care_taker.dart';
import 'package:pet_care/models/pet.dart';
import 'package:pet_care/models/pet_service.dart';
import 'package:pet_care/models/status.dart';

class Appointment {
  final String id;
  final Pet pet;
  final List<PetService> service;
  final CareTaker careTaker;
  final DateTime date;
  final AppointmentStatus appointmentStatus;

  Appointment({
    required this.id,
    required this.pet,
    required this.service,
    required this.careTaker,
    required this.date,
    required this.appointmentStatus,
  });

  double get totalPrice => service.fold(0.0, (sum, s) => sum + s.price);
}
