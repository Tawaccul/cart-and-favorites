import 'package:badges/badges.dart' as badges;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:test_1/database.dart';
import 'package:test_1/model/cart_model.dart';
import 'package:test_1/model/item_model.dart';
import 'package:test_1/provider/cart_provider.dart';
import 'package:test_1/screensa/cart_screen.dart';
import 'package:test_1/screensa/favorite.dart';

class ProductList extends StatefulWidget {
    final List<Item> products;

  const ProductList({Key? key, required this.products}) : super(key: key);

  @override
  State<ProductList> createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  DBHelper dbHelper = DBHelper();

   late List<Item> products;

  @override
  void initState() {
    super.initState();
    products = widget.products;
  }


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
            return 
            Container( 
              height: 100,
              child: 
            Card(
              shadowColor: const Color.fromARGB(0, 255, 193, 7),
              color: Color.fromARGB(46, 182, 231, 255),
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
                      width: 120,
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
                    GestureDetector(
                        onTap: () {
                          saveData(index);
                        },
                        child: const Icon(Icons.shopping_basket_outlined),
                    ),
                         GestureDetector(
                   
                    onTap: () {
                      saveDataToFavorites(index);
                    },
                    child: const Icon(Icons.favorite, color: Colors.red,),
                  ),
                  ],
                ),
              ),
            ));
          }),
    );
  }
}