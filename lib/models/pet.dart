import 'package:pet_care/models/pet_owner.dart';

class Pet {
  final String id;
  final String name;
  final String species; // enum
  final String breed;
  final int age;
  final PetOwner petOwnerId;

  Pet({
    required this.id,
    required this.name,
    required this.species,
    required this.breed,
    required this.age,
    required this.petOwnerId
  });
}
