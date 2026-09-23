enum PetService {
  groom('Grooming', 10.0),
  hairCut('Hair Cutting', 5.0),
  nailtrim('Nail Trimming', 5.0),
  bath('Bathing', 10.0),
  sitting('Pet Sitting', 20.0);

  final String label;
  final double price;

  const PetService(this.label, this.price);
}
