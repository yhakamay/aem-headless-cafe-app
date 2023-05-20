import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:transparent_image/transparent_image.dart';

import '../../utils/beverage.dart';
import '../../utils/graphql.dart';

class Home extends StatefulWidget {
  const Home({
    super.key,
  });

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Beverage> _beverages = [];
  bool _isLoading = true;

  Future<void> fetchItems() async {
    // https://publish-p111360-e1081459.adobeaemcloud.com/graphql/execute.json/wknd-shared/beverages-all
    final response = await http.get(Uri.https(
      GraphQL.endpointAuthority,
      '${GraphQL.endpointPath}${GraphQL.queryBeveragesAll}',
    ));
    final json = jsonDecode(response.body);
    final items = json['data']['beverageList']['items'];

    _beverages = items.map<Beverage>((item) {
      return Beverage.fromJson(item);
    }).toList();
  }

  @override
  void initState() {
    super.initState();
    fetchItems().then(
      (_) => setState(() {
        _isLoading = false;
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AEM Headless Cafe'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
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
            ),
    );
  }
}
