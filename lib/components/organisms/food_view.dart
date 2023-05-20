import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

import '../../utils/graphql.dart';
import '../../utils/types/food.dart';

class FoodView extends StatelessWidget {
  const FoodView({
    super.key,
    required List<Food> foods,
  }) : _foods = foods;

  final List<Food> _foods;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
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
    );
  }
}
