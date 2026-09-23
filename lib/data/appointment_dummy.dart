import 'package:pet_care/data/care_taker_dummy.dart';
import 'package:pet_care/data/pet_dummy.dart';
import 'package:pet_care/models/appointment.dart';
import 'package:pet_care/models/pet_service.dart';
import 'package:pet_care/models/status.dart';

final List<Appointment> dummyAppointments = [
  Appointment(
    id: 'apt_1',
    pet: dummyPets[0],
    service: [PetService.groom, PetService.bath],
    careTaker: dummyCareTakers[0],
    date: DateTime.now().add(const Duration(days: 1)),
    appointmentStatus: AppointmentStatus.confirmed,
  ),
];
