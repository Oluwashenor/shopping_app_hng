class GroceryProduct {
  String name;
  String category;
  int amount;

  GroceryProduct(
      {required this.name, required this.category, required this.amount});

  factory GroceryProduct.fromJson(Map<String, dynamic> json) {
    return GroceryProduct(
      name: json['name'],
      category: json['category'],
      amount: json['amount'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'category': category,
      'amount': amount,
    };
  }
}
