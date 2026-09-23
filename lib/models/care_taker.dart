class CareTaker {
  final String id;
  final String name;
  final String phone;
  bool available;

  CareTaker({
    required this.id,
    required this.name,
    required this.phone,
    this.available = true,
  });
}
