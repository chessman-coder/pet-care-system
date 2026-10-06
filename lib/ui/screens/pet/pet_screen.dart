import 'package:flutter/material.dart';
import 'package:pet_care/data/pet_dummy.dart';
import 'package:pet_care/models/pet.dart';
import 'package:pet_care/ui/screens/pet/pet_form.dart';
import 'package:pet_care/ui/widgets/header_section.dart';
import 'package:pet_care/ui/widgets/pet_card.dart';

class PetScreen extends StatefulWidget {
  const PetScreen({super.key});

  @override
  State<PetScreen> createState() => _PetScreenState();
}

class _PetScreenState extends State<PetScreen> {
  late List<Pet> _pets;

  @override
  void initState() {
    super.initState();
    _pets = List<Pet>.from(dummyPets);
  }

  void _deletePet(Pet pet) {
    final petIndex = _pets.indexOf(pet);
    setState(() {
      _pets.removeWhere((p) => p.id == pet.id);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${pet.name} was removed'),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        action: SnackBarAction(
          label: 'Undo',
          textColor: const Color(0xFF4976FF),
          onPressed: () {
            setState(() {
              if (petIndex >= 0 && petIndex <= _pets.length) {
                _pets.insert(petIndex, pet);
              } else {
                _pets.add(pet);
              }
            });
          },
        ),
      ),
    );
    Future.delayed(const Duration(seconds: 3), () {
      ScaffoldMessenger.of(context).clearSnackBars();
    });
  }

  Future<void> _openPetForm([Pet? pet]) async {
    final result = await Navigator.of(context)
        .push<Pet>(MaterialPageRoute(builder: (context) => PetForm(pet: pet)));

    if (result != null) {
      setState(() {
        if (pet != null) {
          final index = _pets.indexWhere((p) => p.id == result.id);
          if (index != -1) {
            _pets[index] = result;
          }
        } else {
          _pets.add(result);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const HeaderSection(icon: Icons.pets, title: 'My Furry Family'),
            const SizedBox(height: 16),
            _petList(context),
          ],
        ),
      ),
      floatingActionButton: Transform.translate(
        offset: const Offset(-10, -30),
        child: FloatingActionButton(
          onPressed: () => _openPetForm(),
          backgroundColor: const Color(0xFF4976FF),
          foregroundColor: Colors.white,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
          child: const Icon(
            Icons.add_rounded,
            size: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _petList(BuildContext context) {
    if (_pets.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 40.0),
          child: Column(
            children: [
              Icon(Icons.pets, size: 48, color: Colors.grey.shade400),
              const SizedBox(height: 12),
              Text(
                'No pets found',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      children: _pets.map((pet) {
        return PetCard(
          key: ValueKey(pet.id),
          pet: pet,
          onTap: () => _openPetForm(pet),
          onDelete: () => _deletePet(pet),
        );
      }).toList(),
    );
  }
}
