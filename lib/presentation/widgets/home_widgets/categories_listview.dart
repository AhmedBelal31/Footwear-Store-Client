import 'package:flutter/material.dart';

class CategoriesListView extends StatelessWidget {
  const CategoriesListView({super.key});

  @override
  Widget build(BuildContext context) {
    List<String> categoryItems = [
      'Boots',
      'Flats',
      'Sandal',
      'Shoes',
      'Heals',
      'Slippers'
    ];
    return SizedBox(
      height: 50,
      child: ListView.builder(
        physics: const BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(5.0),
            child: Chip(
              label: Text(categoryItems[index]),
            ),
          );
        },
        itemCount: categoryItems.length,
      ),
    );
  }
}