import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:transparent_image/transparent_image.dart';

import '../../utils/types/beverage.dart';
import '../../utils/graphql.dart';
import '../../utils/types/food.dart';

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
      final beveragesRes = await http.get(Uri.https(
        GraphQL.endpointAuthority,
        '${GraphQL.endpointPath}${GraphQL.queryBeveragesAll}',
      ));
      final beveragesJson = jsonDecode(beveragesRes.body);
      final beverageItems = beveragesJson['data']['beverageList']['items'];

      setState(() {
        _beverages = beverageItems.map<Beverage>((item) {
          return Beverage.fromJson(item);
        }).toList();
      });

      final foodsRes = await http.get(Uri.https(
        GraphQL.endpointAuthority,
        '${GraphQL.endpointPath}${GraphQL.queryFoodsAll}',
      ));
      final foodsJson = jsonDecode(foodsRes.body);
      final foodItems = foodsJson['data']['foodList']['items'];

      setState(() {
        _foods = foodItems.map<Food>((item) {
          return Food.fromJson(item);
        }).toList();
      });
    } on Exception catch (e) {
      _error = e.toString();
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
                        ? ListView.builder(
                            shrinkWrap: true,
                            itemCount: _beverages.length,
                            itemBuilder: (context, index) {
                              final beverage = _beverages[index];
                              return ListTile(
                                title: Text(beverage.title),
                                subtitle: Text(
                                  beverage.description?.plaintext ?? '',
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                trailing: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: FadeInImage.memoryNetwork(
                                    image:
                                        'https://${GraphQL.endpointAuthority}${beverage.primaryImage.path}',
                                    placeholder: kTransparentImage,
                                    width: 50,
                                    height: 50,
                                  ),
                                ),
                              );
                            },
                          )
                        : ListView.builder(
                            shrinkWrap: true,
                            itemCount: _foods.length,
                            itemBuilder: (context, index) {
                              final food = _foods[index];
                              return ListTile(
                                title: Text(food.title),
                                subtitle: Text(
                                  food.description?.plaintext ?? '',
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                trailing: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: FadeInImage.memoryNetwork(
                                    image:
                                        'https://${GraphQL.endpointAuthority}${food.primaryImage.path}',
                                    placeholder: kTransparentImage,
                                    width: 50,
                                    height: 50,
                                  ),
                                ),
                              );
                            },
                          ),
                  ],
                ),
    );
  }
}
