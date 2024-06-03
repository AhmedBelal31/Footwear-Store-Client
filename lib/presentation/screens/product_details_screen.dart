import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:footwear_store_client/core/utils/styles.dart';
import 'package:footwear_store_client/data/models/product_model.dart';
import 'package:footwear_store_client/presentation/widgets/custom_text_field.dart';

class ProductDetailsScreen extends StatefulWidget {
  final ProductModel product;

  const ProductDetailsScreen({super.key, required this.product});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  String? _imageError;

  bool isValidUrl(String url) {
    const urlPattern =
        r'^(https?:\/\/)?([a-zA-Z0-9-]+\.)+[a-zA-Z]{2,6}(:[0-9]{1,5})?(\/.*)?$';
    return RegExp(urlPattern).hasMatch(url);
  }

  Future<bool> isImageAccessible(String url) async {
    try {
      final response = await http.get(Uri.parse(url));
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  void _validateAndDisplayImage(BuildContext context) async {
    final url = widget.product.imageUrl ??
        'https://upload.wikimedia.org/wikipedia/commons/thumb/6/65/No-Image-Placeholder.svg/1665px-No-Image-Placeholder.svg.png';

    if (!isValidUrl(url)) {
      setState(() {
        _imageError = 'Invalid URL format';
      });
      return;
    }

    if (await isImageAccessible(url)) {
      setState(() {
        _imageError = null;
      });
      showModalBottomSheet(
        context: context,
        builder: (context) => CustomBottomSheet(imageUrl: url),
      );
    } else {
      setState(() {
        _imageError = 'Image not accessible';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        scrolledUnderElevation: 0,
        title: const Text(
          'Product Details',
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
                onTap: () => _validateAndDisplayImage(context),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: Image.network(
                    widget.product.imageUrl ??
                        'https://upload.wikimedia.org/wikipedia/commons/thumb/6/65/No-Image-Placeholder.svg/1665px-No-Image-Placeholder.svg.png',
                    fit: BoxFit.contain,
                    width: double.infinity,
                    height: MediaQuery.sizeOf(context).height * .25,
                    errorBuilder: (context, error, stackTrace) {
                      // return const Text('Invalid URL format');
                      return Center(
                        child: Image.network(
                            height: 200,
                            'https://upload.wikimedia.org/wikipedia/commons/thumb/6/65/No-Image-Placeholder.svg/1665px-No-Image-Placeholder.svg.png'),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                widget.product.name,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 18),
              Text(widget.product.description),
              const SizedBox(height: 20),
              Text(
                'Rs: ${widget.product.price}',
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
              if (_imageError != null)
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Text(
                    _imageError!,
                    style: const TextStyle(color: Colors.red),
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

  const CustomBottomSheet({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10.0),
      child: Image.network(
        imageUrl,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return const Text('Error loading image');
        },
      ),
    );
  }
}
