import 'package:flutter/material.dart';

import 'model/grocery.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<GroceryProduct> groceryList = [
    GroceryProduct(name: 'Apples', category: 'Fruits', amount: 10),
    GroceryProduct(name: 'Bananas', category: 'Fruits', amount: 15),
    GroceryProduct(name: 'Carrots', category: 'Vegetables', amount: 8),
    GroceryProduct(name: 'Chicken Breast', category: 'Meat', amount: 12),
    GroceryProduct(name: 'Milk', category: 'Dairy', amount: 7),
    GroceryProduct(name: 'Cheese', category: 'Dairy', amount: 9),
    GroceryProduct(name: 'Bread', category: 'Bakery', amount: 20),
    GroceryProduct(name: 'Eggs', category: 'Dairy', amount: 30),
    GroceryProduct(name: 'Rice', category: 'Grains', amount: 10),
    GroceryProduct(name: 'Tomatoes', category: 'Vegetables', amount: 18),
    GroceryProduct(name: 'Oranges', category: 'Fruits', amount: 12),
  ];

  List<GroceryProduct> myCart = [];

  showSnackBar(String message) {
    SnackBar snackbar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }

  int currentScreen = 0;
  double total = 0;

  void removeFromCart(String productName) {
    showSnackBar("Removing $productName from cart");
    GroceryProduct product = myCart.firstWhere((x) => x.name == productName);
    myCart.remove(product);
    total -= product.amount;
    setState(() {});
  }

  void addToCart(String productName) {
    GroceryProduct? productInCart;
    if (myCart.isNotEmpty) {
      productInCart = myCart.firstWhere((x) => x.name == productName);
    }
    if (productInCart == null) {
      showSnackBar("Adding $productName from cart");
      GroceryProduct product =
          groceryList.firstWhere((x) => x.name == productName);
      myCart.add(product);
      total += product.amount;
      setState(() {});
    } else {
      showSnackBar("$productName is already in cart");
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = [
      Products(groceryList: groceryList, buttonPressed: addToCart),
      ShoppingCart(myCart: myCart, buttonPressed: removeFromCart)
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(currentScreen == 0 ? "Shopping" : "Cart Total - $total"),
        centerTitle: true,
      ),
      body: screens[currentScreen],
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Theme.of(context).colorScheme.primary,
        currentIndex: currentScreen,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.list_outlined), label: "Products"),
          BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart), label: "Cart")
        ],
        onTap: (value) {
          setState(() {
            currentScreen = value;
          });
        },
      ),
    );
  }
}

class Products extends StatelessWidget {
  const Products({
    super.key,
    required this.groceryList,
    required this.buttonPressed,
  });

  final List<GroceryProduct> groceryList;
  final Function(String) buttonPressed;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: groceryList.length,
        itemBuilder: (BuildContext context, int index) {
          return ProductWidget(
            grocery: groceryList[index],
            index: index,
            buttonPressed: buttonPressed,
          );
        });
  }
}

class ProductWidget extends StatelessWidget {
  const ProductWidget(
      {super.key,
      required this.grocery,
      this.cartItem = false,
      required this.buttonPressed,
      required this.index});

  final GroceryProduct grocery;
  final bool cartItem;
  final int index;
  final Function(String) buttonPressed;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(grocery.name),
      trailing: IconButton(
        icon: Icon(cartItem ? Icons.remove : Icons.add),
        onPressed: () => buttonPressed(grocery.name),
      ),
      subtitle: Text("\$${grocery.amount}"),
    );
  }
}

class ShoppingCart extends StatelessWidget {
  const ShoppingCart(
      {super.key, required this.myCart, required this.buttonPressed});

  final List<GroceryProduct> myCart;
  final Function(String) buttonPressed;
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Expanded(
        flex: 9,
        child: ListView.builder(
            shrinkWrap: true,
            itemCount: myCart.length,
            itemBuilder: (BuildContext context, int index) {
              if (myCart.isEmpty) {
                return const Text("You have no item on cart");
              } else {
                return ProductWidget(
                  grocery: myCart[index],
                  cartItem: true,
                  buttonPressed: buttonPressed,
                  index: index,
                );
              }
            }),
      ),
      if (myCart.isNotEmpty)
        Expanded(
            flex: 1,
            child: Container(
              child: TextButton(
                  child: const Text("Checkout"),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const CheckOutScreen()));
                  }),
            ))
    ]);
  }
}

class CheckOutScreen extends StatelessWidget {
  const CheckOutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text("Thank you for shopping with us"),
      ),
    );
  }
}
