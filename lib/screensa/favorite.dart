import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_1/database.dart';
import 'package:test_1/model/item_model.dart'; // Assuming Item is the model for favorite items
import 'package:test_1/provider/cart_provider.dart';

// ignore: must_be_immutable
class FavoritesScreen extends StatelessWidget {
  DBHelper dbHelper = DBHelper();

  FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Favorites'),
      ),
      body: FutureBuilder<List<Item>>(
        future: dbHelper.getFavoritesList(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text('No favorite items.'),
            );
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(snapshot.data![index].name),
                  subtitle: Text(snapshot.data![index].unit),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      // Implement logic to remove item from favorites
                        dbHelper.removeFromFavorites(snapshot.data![index].id!);

                      // Optionally, notify the cart provider if needed
                      cartProvider.removeFavorite(snapshot.data![index]);
                    },
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
