import 'package:flutter/material.dart';

import '../../utils/types/beverage.dart';
import '../../utils/graphql.dart';
import '../../utils/types/food.dart';
import '../organisms/beverage_view.dart';
import '../organisms/food_view.dart';

enum Product { beverage, food }

class Home extends StatefulWidget {
  const Home({
    super.key,
  });

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Beverage> _beverages = [];
  List<Food> _foods = [];
  bool _isLoading = true;
  String? _error;
  Product productView = Product.beverage;

  Future<void> fetchItems() async {
    try {
      final graphQl = GraphQL();

      final beverages = await graphQl.fetchBeveragesAll();
      final foods = await graphQl.fetchFoodsAll();

      setState(() {
        _beverages = beverages;
        _foods = foods;
      });
    } on Exception catch (e) {
      setState(() => _error = e.toString());
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  void initState() {
    super.initState();
    fetchItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AEM Headless Cafe'),
      ),
      body: _error != null
          ? Center(child: Text(_error!))
          : _isLoading
              ? const Center(
                  child: SizedBox(
                    width: 160,
                    child: LinearProgressIndicator(),
                  ),
                )
              : Column(
                  children: [
                    SegmentedButton<Product>(
                      segments: const <ButtonSegment<Product>>[
                        ButtonSegment<Product>(
                          value: Product.beverage,
                          label: Text('Beverages'),
                          icon: Icon(Icons.coffee),
                        ),
                        ButtonSegment<Product>(
                          value: Product.food,
                          label: Text('Foods'),
                          icon: Icon(Icons.cookie),
                        ),
                      ],
                      selected: <Product>{productView},
                      onSelectionChanged: (Set<Product> newSelection) {
                        setState(() => productView = newSelection.first);
                      },
                    ),
                    productView == Product.beverage
                        ? BeverageView(beverages: _beverages)
                        : FoodView(foods: _foods),
                  ],
                ),
    );
  }
}
