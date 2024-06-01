import 'package:flutter/material.dart';
import 'package:footwear_store_client/core/utils/styles.dart';
import 'package:footwear_store_client/data/models/product_model.dart';
import 'package:footwear_store_client/presentation/widgets/custom_text_field.dart';

class ProductDetailsScreen extends StatelessWidget {
  final ProductModel product;

  const ProductDetailsScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        scrolledUnderElevation: 0,
        title: const Text(
          'Product Deatils ',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (context) => CustomBottomSheet(
                      imageUrl: product.imageUrl,
                    ),
                  );
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: Image.network(
                    product.imageUrl,
                    fit: BoxFit.contain,
                    width: double.infinity,
                    height: MediaQuery.sizeOf(context).height * .25,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                product.name ?? 'No-Name',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 18),
              Text(product.description ?? 'No-Description'),
              const SizedBox(height: 20),
              Text(
                'Rs: ${product.price}',
                style: const TextStyle(
                  color: Colors.green,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              const CustomTextField(
                maxLines: 3,
                hintText: 'Enter Your Billing Address',
                labelText: 'Billing Address',
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: AppStyles.kPrimaryColor,
                  ),
                  onPressed: () {
                    ///Add Payment METHOD !!
                  },
                  child: const Text(
                    'Buy Now',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomBottomSheet extends StatelessWidget {
  final String imageUrl;

  const CustomBottomSheet({
    super.key,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10.0),
      child: Image.network(
        imageUrl,
        fit: BoxFit.cover,
        // width: double.infinity,
        // height: MediaQuery.sizeOf(context).height * .35,
      ),
    );
  }
}
