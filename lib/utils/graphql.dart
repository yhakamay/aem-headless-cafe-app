import 'dart:convert';

import 'package:http/http.dart' as http;

import 'types/beverage.dart';
import 'types/food.dart';

class GraphQL {
  static const endpointAuthority = 'publish-p111360-e1081459.adobeaemcloud.com';
  static const endpointPath = 'graphql/execute.json/wknd-shared/';
  static const queryBeveragesAll = 'beverages-all';
  static const queryFoodsAll = 'foods-all';

  Future<List<Beverage>> fetchBeveragesAll() async {
    final beveragesRes = await http.get(Uri.https(
      GraphQL.endpointAuthority,
      '${GraphQL.endpointPath}${GraphQL.queryBeveragesAll}',
    ));
    final beveragesJson = jsonDecode(beveragesRes.body);
    final beverageItems = beveragesJson['data']['beverageList']['items'];
    final beverages = beverageItems.map<Beverage>((item) {
      return Beverage.fromJson(item);
    }).toList();

    return beverages;
  }

  Future<List<Food>> fetchFoodsAll() async {
    final foodsRes = await http.get(Uri.https(
      GraphQL.endpointAuthority,
      '${GraphQL.endpointPath}${GraphQL.queryFoodsAll}',
    ));
    final foodsJson = jsonDecode(foodsRes.body);
    final foodItems = foodsJson['data']['foodList']['items'];
    final foods = foodItems.map<Food>((item) {
      return Food.fromJson(item);
    }).toList();

    return foods;
  }
}
