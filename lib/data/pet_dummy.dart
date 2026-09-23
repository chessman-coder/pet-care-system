import 'package:pet_care/data/pet_owner_dummy.dart';
import 'package:pet_care/models/pet.dart';

final List<Pet> dummyPets = [
  Pet(
    id: 'pet_1',
    name: 'Max',
    species: 'Dog',
    breed: 'Golden Retriever',
    age: 2,
    petOwnerId: dummyPetOwner,
  ),
  Pet(
    id: 'pet_2',
    name: 'Luna',
    species: 'Cat',
    breed: 'British Shorthair',
    age: 3,
    petOwnerId: dummyPetOwner,
  ),
  Pet(
    id: 'pet_3',
    name: 'Bella',
    species: 'Dog',
    breed: 'Poodle',
    age: 1,
    petOwnerId: dummyPetOwner,
  ),
  Pet(
    id: 'pet_4',
    name: 'Rocky',
    species: 'Dog',
    breed: 'French Bulldog',
    age: 4,
    petOwnerId: dummyPetOwner,
  ),
  Pet(
    id: 'pet_5',
    name: 'Milo',
    species: 'Cat',
    breed: 'Persian',
    age: 2,
    petOwnerId: dummyPetOwner,
  ),
];
