

        import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_1/database.dart';
import 'package:test_1/model/cart_model.dart';
import 'package:test_1/model/item_model.dart';
import 'package:test_1/provider/cart_provider.dart';
import 'package:test_1/screensa/cart_screen.dart';
import 'package:test_1/screensa/favorite.dart';

class ProductList2 extends StatefulWidget {
  const ProductList2({Key? key}) : super(key: key);

  @override
  State<ProductList2> createState() => _ProductListState();
}

class _ProductListState extends State<ProductList2> {
  DBHelper dbHelper = DBHelper();

  List<Item> products = [
    Item(
         id: 6,
         name: 'Kiwi', 
         unit: 'Pc', 
         price: 40, 
         image: 'images/kiwi.png'),
    Item(
        id: 7,
        name: 'Orange',
        unit: 'Doz',
        price: 15,
        image: 'images/orange.png'),
    Item(
      id: 8,
      name: 'Peach', 
      unit: 'Pc', 
      price: 8, 
      image: 'images/peach.png'),
  ];

  //List<bool> clicked = List.generate(10, (index) => false, growable: true);
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    void saveData(int index) {
      dbHelper
          .insert(
        Cart(
          id: index,
          productId: index.toString(),
          productName: products[index].name,
          initialPrice: products[index].price,
          productPrice: products[index].price,
          quantity: ValueNotifier(1),
          unitTag: products[index].unit,
          image: products[index].image,
        ),
      )
          .then((value) {
        cart.addTotalPrice(products[index].price.toDouble());
        cart.addCounter();
        print('Product Added to cart');
      }).onError((error, stackTrace) {
        print(error.toString());
      });
    }

      void saveDataToFavorites(int index) {
      dbHelper
          .insertToFavorite(
            Item(
              id: products[index].id,
              name: products[index].name,
              unit: products[index].unit,
              price: products[index].price,
              image: products[index].image,
            ),
          )
          .then((value) {
        print('Product Added to favorites');
      }).onError((error, stackTrace) {
        print(error.toString());
      });
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Product List'),
        actions: [
          badges.Badge(
            badgeContent: Consumer<CartProvider>(
              builder: (context, value, child) {
                return Text(
                  value.getCounter().toString(),
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                );
              },
            ),
            position: badges.BadgePosition.topEnd(top: -10, end: -12),
            child: IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const CartScreen()));
              },
              icon: const Icon(Icons.shopping_cart),
            ),
          ),
          const SizedBox(
            width: 20.0,
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FavoritesScreen(),
                ),
              );
            },
            icon: const Icon(Icons.favorite),
          ),
          const SizedBox(
            width: 20.0,
          ),
        ],
      ),
      body: ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 8.0),
          shrinkWrap: true,
          itemCount: products.length,
          itemBuilder: (context, index) {
            return Card(
              color: Colors.blueGrey.shade200,
              elevation: 5.0,
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Image(
                      height: 50,
                      width: 50,
                      image: AssetImage(products[index].image.toString()),
                    ),
                    SizedBox(
                      width: 20,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 5.0,
                          ),
                          RichText(
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            text: TextSpan(
                                text: 'Name: ',
                                style: TextStyle(
                                    color: Colors.blueGrey.shade800,
                                    fontSize: 16.0),
                                children: [
                                  TextSpan(
                                      text:
                                          '${products[index].name.toString()}\n',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold)),
                                ]),
                          ),
                          RichText(
                            maxLines: 1,
                            text: TextSpan(
                                text: 'Unit: ',
                                style: TextStyle(
                                    color: Colors.blueGrey.shade800,
                                    fontSize: 16.0),
                                children: [
                                  TextSpan(
                                      text:
                                          '${products[index].unit.toString()}\n',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold)),
                                ]),
                          ),
                          RichText(
                            maxLines: 1,
                            text: TextSpan(
                                text: 'Price: ' r"$",
                                style: TextStyle(
                                    color: Colors.blueGrey.shade800,
                                    fontSize: 16.0),
                                children: [
                                  TextSpan(
                                      text:
                                          '${products[index].price.toString()}\n',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold)),
                                ]),
                          ),
                        ],
                      ),
                    ),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blueGrey.shade900),
                        onPressed: () {
                          saveData(index);
                        },
                        child: const Text('Add to Cart')),

                         ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                    onPressed: () {
                      saveDataToFavorites(index);
                    },
                    child: const Text('Add to Favorites'),
                  ),
                  ],
                ),
              ),
            );
          }),
    );
  }
}