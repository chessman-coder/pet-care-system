import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pet_care/data/pet_owner_dummy.dart';
import 'package:pet_care/models/pet.dart';
import 'package:pet_care/models/pet_owner.dart';
import 'package:pet_care/ui/widgets/header_section.dart';

class PetForm extends StatefulWidget {
  final Pet? pet;
  final PetOwner? petOwner;

  const PetForm({super.key, this.pet, this.petOwner});

  @override
  State<PetForm> createState() => _PetFormState();
}

class _PetFormState extends State<PetForm> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameController;
  late final TextEditingController _breedController;
  late final TextEditingController _ageController;

  String _selectedSpecies = 'Dog';
  final List<Map<String, dynamic>> _speciesOptions = const [
    {'name': 'Dog', 'icon': Icons.pets_rounded},
    {'name': 'Cat', 'icon': Icons.cruelty_free_rounded},
  ];

  final Map<String, List<String>> _popularBreeds = {
    'Dog': [
      'Golden Retriever',
      'Poodle',
      'French Bulldog',
      'German Shepherd',
      'Labrador',
    ],
    'Cat': ['British Shorthair', 'Persian', 'Maine Coon', 'Siamese', 'Ragdoll'],
  };

  bool get _isEditing => widget.pet != null;

  @override
  void initState() {
    super.initState();
    final pet = widget.pet;
    _nameController = TextEditingController(text: pet?.name ?? '');
    _breedController = TextEditingController(text: pet?.breed ?? '');
    _ageController = TextEditingController(
      text: pet != null ? pet.age.toString() : '1',
    );

    if (pet != null) {
      _selectedSpecies = pet.species;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _breedController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  void _incrementAge() {
    final currentAge = int.tryParse(_ageController.text) ?? 0;
    setState(() {
      _ageController.text = (currentAge + 1).toString();
    });
  }

  void _decrementAge() {
    final currentAge = int.tryParse(_ageController.text) ?? 1;
    if (currentAge > 1) {
      setState(() {
        _ageController.text = (currentAge - 1).toString();
      });
    }
  }

  void _submitForm() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final finalSpecies = _selectedSpecies;

    final finalAge = int.tryParse(_ageController.text.trim()) ?? 1;
    final petOwner = widget.petOwner ?? widget.pet?.petOwnerId ?? dummyPetOwner;

    final createdPet = Pet(
      id: widget.pet?.id ?? 'pet_${DateTime.now().millisecondsSinceEpoch}',
      name: _nameController.text.trim(),
      species: finalSpecies,
      breed: _breedController.text.trim(),
      age: finalAge,
      petOwnerId: petOwner,
    );

    Navigator.of(context).pop(createdPet);
  }

  @override
  Widget build(BuildContext context) {
    const themePrimary = Color(0xFF4976FF);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      appBar: AppBar(
        backgroundColor: themePrimary,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.white,
            size: 20,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          _isEditing ? 'Edit Pet Profile' : 'Add New Pet',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Species Selection Section
                HeaderSection(
                  icon: Icons.category_rounded,
                  title: 'Select Species',
                ),
                const SizedBox(height: 12),
                _buildSpeciesSelector(themePrimary),
                const SizedBox(height: 24),

                // Pet Details Section
                HeaderSection(icon: Icons.badge_outlined, title: 'Pet Details'),
                const SizedBox(height: 14),

                // Name Input
                _buildLabel('Pet Name', isRequired: true),
                const SizedBox(height: 8),
                _buildNameField(themePrimary),
                const SizedBox(height: 20),

                // Breed Input
                _buildLabel('Breed', isRequired: true),
                const SizedBox(height: 8),
                _buildBreedField(themePrimary),
                if (_popularBreeds.containsKey(_selectedSpecies)) ...[
                  const SizedBox(height: 10),
                  _buildBreedSuggestions(themePrimary),
                ],
                const SizedBox(height: 20),

                // Age Input
                _buildLabel('Age (In Years)', isRequired: true),
                const SizedBox(height: 8),
                _buildAgeStepper(themePrimary),
                const SizedBox(height: 32),

                // Submit Button
                _buildSubmitButton(themePrimary),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text, {bool isRequired = false}) {
    return Row(
      children: [
        Text(
          text,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF333333),
          ),
        ),
        if (isRequired)
          const Text(
            ' *',
            style: TextStyle(
              color: Colors.redAccent,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
      ],
    );
  }

  Widget _buildSpeciesSelector(Color themePrimary) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: _speciesOptions.map((species) {
          final isSelected = _selectedSpecies == species['name'];
          return Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: InkWell(
              onTap: () {
                setState(() {
                  _selectedSpecies = species['name'] as String;
                });
              },
              borderRadius: BorderRadius.circular(16),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: isSelected ? themePrimary : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isSelected ? themePrimary : Colors.grey.shade300,
                    width: 1.5,
                  ),
                  boxShadow: [
                    if (isSelected)
                      BoxShadow(
                        color: themePrimary.withValues(alpha: 0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      )
                    else
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.02),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                  ],
                ),
                child: Row(
                  children: [
                    Icon(
                      species['icon'] as IconData,
                      size: 20,
                      color: isSelected ? Colors.white : Colors.grey.shade700,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      species['name'] as String,
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.black87,
                        fontWeight: isSelected
                            ? FontWeight.bold
                            : FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildNameField(Color themePrimary) {
    return TextFormField(
      controller: _nameController,
      textCapitalization: TextCapitalization.words,
      onChanged: (_) => setState(() {}),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Please enter your pet name';
        }
        if (value.trim().length < 2) {
          return 'Pet name must be at least 2 characters';
        }
        return null;
      },
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        hintText: 'e.g. Max, Luna, Charlie',
        hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
        prefixIcon: Icon(Icons.pets_rounded, color: themePrimary, size: 20),
        suffixIcon: _nameController.text.isNotEmpty
            ? IconButton(
                icon: const Icon(Icons.clear_rounded, size: 18),
                onPressed: () {
                  _nameController.clear();
                  setState(() {});
                },
              )
            : null,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: themePrimary, width: 1.8),
        ),
      ),
    );
  }

  Widget _buildBreedField(Color themePrimary) {
    return TextFormField(
      controller: _breedController,
      textCapitalization: TextCapitalization.words,
      onChanged: (_) => setState(() {}),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Please enter the breed';
        }
        return null;
      },
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        hintText: 'e.g. Golden Retriever, Persian, Mixed',
        hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
        prefixIcon: Icon(
          Icons.fingerprint_rounded,
          color: themePrimary,
          size: 20,
        ),
        suffixIcon: _breedController.text.isNotEmpty
            ? IconButton(
                icon: const Icon(Icons.clear_rounded, size: 18),
                onPressed: () {
                  _breedController.clear();
                  setState(() {});
                },
              )
            : null,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: themePrimary, width: 1.8),
        ),
      ),
    );
  }

  Widget _buildBreedSuggestions(Color themePrimary) {
    final suggestions = _popularBreeds[_selectedSpecies] ?? [];
    return Wrap(
      spacing: 8,
      runSpacing: 6,
      children: suggestions.map((breed) {
        final isSelected =
            _breedController.text.trim().toLowerCase() == breed.toLowerCase();
        return InkWell(
          onTap: () {
            setState(() {
              _breedController.text = breed;
            });
          },
          borderRadius: BorderRadius.circular(10),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: isSelected
                  ? themePrimary.withValues(alpha: 0.12)
                  : Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: isSelected ? themePrimary : Colors.grey.shade300,
                width: 1,
              ),
            ),
            child: Text(
              breed,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: isSelected ? themePrimary : Colors.grey.shade700,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildAgeStepper(Color themePrimary) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          Icon(Icons.calendar_month_rounded, color: themePrimary, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: TextFormField(
              controller: _ageController,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(2),
              ],
              onChanged: (_) => setState(() {}),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter pet age';
                }
                final parsed = int.tryParse(value);
                if (parsed == null || parsed <= 0) {
                  return 'Age must be at least 1';
                }
                if (parsed > 50) {
                  return 'Please enter a valid age';
                }
                return null;
              },
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: 'Age',
                suffixText: 'years old',
                suffixStyle: TextStyle(
                  color: Colors.grey,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
          SizedBox(width: 10),
          // Stepper Minus
          Material(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(10),
            child: InkWell(
              borderRadius: BorderRadius.circular(10),
              onTap: _decrementAge,
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(
                  Icons.remove_rounded,
                  size: 18,
                  color: Colors.black87,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          // Stepper Plus
          Material(
            color: themePrimary.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(10),
            child: InkWell(
              borderRadius: BorderRadius.circular(10),
              onTap: _incrementAge,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(Icons.add_rounded, size: 18, color: themePrimary),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubmitButton(Color themePrimary) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: _submitForm,
        style: ElevatedButton.styleFrom(
          backgroundColor: themePrimary,
          foregroundColor: Colors.white,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _isEditing
                  ? Icons.check_circle_outline_rounded
                  : Icons.add_circle_outline_rounded,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              _isEditing ? 'Save Changes' : 'Add Pet',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
