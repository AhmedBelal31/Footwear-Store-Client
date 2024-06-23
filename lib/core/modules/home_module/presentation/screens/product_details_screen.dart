import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:footwear_store_client/core/utils/styles.dart';
import '../../../../utils/widgets/custom_snack_bar.dart';
import '../../../../utils/widgets/custom_text_field.dart';
import '../../data/models/order_product_model.dart';
import '../../data/models/product_model.dart';
import '../controller/products_cubit.dart';
import '../controller/products_state.dart';
import 'home_screen.dart';

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
    var formKey = GlobalKey<FormState>();
    var customerNameController = TextEditingController();
    var phoneController = TextEditingController();
    var addressController = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        scrolledUnderElevation: 0,
        title: const Text(
          'Product Details',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: BlocProvider(
        create: (context) => ProductsCubit(),
        child: BlocConsumer<ProductsCubit, ProductsStates>(
          listener: (context, state) {
            if (state is CreateOrderSuccessState) {
              CustomSnackBarOverlay.show(context,
                  message: 'Success',
                  messageDescription: 'Order Created Successfully',
                  msgColor: Colors.green);
              customerNameController.clear();
              phoneController.clear();
              addressController.clear();
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const HomeScreen(),
              ));
            }
            if (state is CreateOrderFailureState) {
              CustomSnackBarOverlay.show(context,
                  message: 'Error',
                  messageDescription:
                      'Order creation failed. Please try again.',
                  msgColor: Colors.red);
            }
            if (state is StripeFailureState) {
              CustomSnackBarOverlay.show(context,
                  message: 'Error',
                  messageDescription:
                      "Something went wrong. Please try again later.",
                  msgColor: Colors.red);
            }
          },
          builder: (context, state) {
            var cubit = BlocProvider.of<ProductsCubit>(context);
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () => _validateAndDisplayImage(context),
                        child: Hero(
                          tag: widget.product.id,
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
                        'Price: ${widget.product.price}',
                        style: const TextStyle(
                          color: AppStyles.kPrimaryColor,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      CustomTextField(
                        hintText: 'Enter Your Name',
                        labelText: 'Name',
                        prefixIcon: Icons.person,
                        keyboardType: TextInputType.name,
                        controller: customerNameController,
                        validator: (value) => validateTextFieldInput(
                          value,
                          errorMsg: 'Name Required ',
                        ),
                        onFieldSubmitted: (_) {
                          // if (formKey.currentState!.validate()) {
                          //   cubit.createPayment(
                          //     amount: (widget.product.price).toInt(),
                          //     currency: 'USD',
                          //   );
                          // }
                        },
                      ),
                      const SizedBox(height: 4),
                      CustomTextField(
                        hintText: 'Enter Your Phone',
                        labelText: 'Phone Number',
                        prefixIcon: Icons.phone,
                        keyboardType: TextInputType.phone,
                        controller: phoneController,
                        validator: (value) => validateTextFieldInput(
                          value,
                          errorMsg: 'Phone Number Required ',
                        ),
                        onFieldSubmitted: (_) {
                          // if (formKey.currentState!.validate()) {
                          //   cubit.createPayment(
                          //     amount: (widget.product.price).toInt(),
                          //     currency: 'USD',
                          //   );
                          // }
                        },
                      ),
                      const SizedBox(height: 4),
                      CustomTextField(
                        maxLines: 2,
                        hintText: 'Enter Your Billing Address',
                        labelText: 'Billing Address',
                        prefixIcon: Icons.home,
                        keyboardType: TextInputType.text,
                        controller: addressController,
                        validator: (value) => validateTextFieldInput(
                          value,
                          errorMsg: 'Billing Address Required ',
                        ),
                        onFieldSubmitted: (_) {
                          final orderProductModel = OrderProductModel(
                              address: addressController.text,
                              customer: customerNameController.text,
                              productName: widget.product.name,
                              phone: phoneController.text,
                              price: widget.product.price,
                              transactionId: '',
                              // This will be updated after payment
                              dateTime: DateTime.now().toIso8601String(),
                              productBrand: widget.product.brand,
                              productCategory: widget.product.category,
                              productImageUrl: widget.product.imageUrl ??
                                  'https://upload.wikimedia.org/wikipedia/commons/thumb/6/65/No-Image-Placeholder.svg/1665px-No-Image-Placeholder.svg.png',
                              description: widget.product.description,
                              isShipped: false,
                              orderId: '');
                          cubit.createPayment(
                            amount: widget.product.price.toInt(),
                            currency: 'USD',
                            orderProductModel: orderProductModel,
                          );
                        },
                      ),
                      const SizedBox(height: 10),
                      if (state is StripeLoadingState)
                        const Padding(
                          padding: EdgeInsets.only(top: 20),
                          child: Center(
                            child: CircularProgressIndicator(
                                color: AppStyles.kPrimaryColor),
                          ),
                        ),
                      if (state is! StripeLoadingState)
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: AppStyles.kPrimaryColor,
                            ),
                            onPressed: () {
                              if (formKey.currentState!.validate()) {
                                final orderProductModel = OrderProductModel(
                                  address: addressController.text,
                                  customer: customerNameController.text,
                                  productName: widget.product.name,
                                  phone: phoneController.text,
                                  price: widget.product.price,
                                  transactionId: '',
                                  // This will be updated after payment
                                  dateTime: DateTime.now().toIso8601String(),
                                  productBrand: widget.product.brand,
                                  productCategory: widget.product.category,
                                  productImageUrl: widget.product.imageUrl ??
                                      'https://upload.wikimedia.org/wikipedia/commons/thumb/6/65/No-Image-Placeholder.svg/1665px-No-Image-Placeholder.svg.png',
                                  description: widget.product.description,
                                  isShipped: false,
                                  orderId: '',
                                );
                                cubit.createPayment(
                                  amount: widget.product.price.toInt(),
                                  currency: 'USD',
                                  orderProductModel: orderProductModel,
                                );
                              }
                            },
                            icon: const Icon(Icons.payment, size: 18),
                            label: const Text(
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
          },
        ),
      ),
    );
  }
}

String? validateTextFieldInput(String? value, {required String errorMsg}) {
  if (value?.isEmpty ?? true) {
    return errorMsg;
  }
  return null;
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
