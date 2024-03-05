import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:test_1/model/item_model.dart';
import 'package:test_1/screensa/product_list.dart';

class CategorySelectionPage extends StatelessWidget {
  const CategorySelectionPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select a Category'),
      ),
      body: 
      Center ( 
        child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
         Container(
                      margin: EdgeInsets.all(10),

            width: 150,
            height: 150,
            color: Color.fromARGB(255, 215, 255, 176),
            child: Center (
              child:
          GestureDetector(
            onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductList(
          products: [
            Item(
              id: 1,
              name: 'Apple',
              unit: 'Kg',
              price: 20,
              image: 'images/apple.png',
            ),
            Item(
              id: 2,
              name: 'Mango',
              unit: 'Doz',
              price: 30,
              image: 'images/mango.png',
            ),
            Item(
              id: 3,
              name: 'Banana',
              unit: 'Doz',
              price: 10,
              image: 'images/banana.png',
            ),
            // Add more items for Category 1
          ],
        ),
      ),
    );
  },
  child: const Text('Category 1',  style: TextStyle(color: Colors.blueGrey, fontSize: 18, fontWeight: FontWeight.normal)),
))),
          
          Container(
            margin: EdgeInsets.all(10),
            width: 150,
            height: 150,
            color: Color.fromARGB(255, 215, 255, 176),
            child: Center (
              child:
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProductList(
                    products: [
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
                      // Add more items for Category 2
                    ],
                  ),
                ),
              );
            },
            child: const Text('Category 2', style: TextStyle(color: Colors.blueGrey, fontSize: 18, fontWeight: FontWeight.normal),),
          ))),
        ],
      ),
    ));
  }
}
