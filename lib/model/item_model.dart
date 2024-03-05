class Item {
  final int? id;
  final String name;
  final String unit;
  final int price;
  final String image;
  

  Item({required this.name, required this.unit, required this.price, required this.image, required this.id});

  Map<String, dynamic> toMap() {
    return {
      'id' : id,
      'name': name,
      'unit': unit,
      'price': price,
      'image': image,
    };
  }

  factory Item.fromMap(Map<String, dynamic> map) {
    return Item(
      id: map['id'],
      name: map['name'],
      unit: map['unit'],
      price: map['price'],
      image: map['image'],
    );
  }
 Map<String, dynamic> toJson() {
    return {

      'id': id,
      'name': name,
      'unit': unit,
      'price': price,
      'image': image,
    };
  }

  // If needed, you can also add a factory method to create an Item from a JSON map
  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      id: json['id'],
      name: json['name'],
      unit: json['unit'],
      price: json['price'],
      image: json['image'],
    );
  }
}
