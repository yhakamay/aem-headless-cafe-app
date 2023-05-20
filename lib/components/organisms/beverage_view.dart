import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

import '../../utils/graphql.dart';
import '../../utils/types/beverage.dart';

class BeverageView extends StatelessWidget {
  const BeverageView({
    super.key,
    required List<Beverage> beverages,
  }) : _beverages = beverages;

  final List<Beverage> _beverages;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
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
    );
  }
}
