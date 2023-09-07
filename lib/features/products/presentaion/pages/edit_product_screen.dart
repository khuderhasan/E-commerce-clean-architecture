import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/shared_widgets/app_sanck_bar.dart';
import '../../../../core/shared_widgets/error_dialog.dart';

import '../../domain/entities/product.dart';
import '../Blocs/add_update_delete_product_bloc/add_update_delete_product_bloc_bloc.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = '/edit-product';

  const EditProductScreen({Key? key}) : super(key: key);

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _desFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _imageUrlFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  var _editedProduct = Product(
    id: null,
    title: '',
    description: '',
    imageUrl: '',
    price: 0,
  );
  var _initState = true;

  var _initialValues = {
    'title': '',
    'description': '',
    'price': '',
    'imageUrl': '',
  };

  @override
  void initState() {
    _imageUrlFocusNode.addListener(_imageUrlUpdate);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_initState) {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args != null) {
        var argsMap = args as Map<String, dynamic>;
        if (argsMap["id"] != null) {
          _editedProduct = Product(
              id: argsMap["id"],
              title: argsMap["title"],
              description: argsMap["description"],
              price: argsMap["price"],
              imageUrl: argsMap["imageUrl"]);
          _initialValues = {
            'title': _editedProduct.title,
            'description': _editedProduct.description,
            'price': _editedProduct.price.toString(),
            // 'imageUrl': _editedProduct.imageUrl,
            'imageUrl': '',
          };
          _imageUrlController.text = _editedProduct.imageUrl;
        }
      }
    }
    _initState = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _imageUrlFocusNode.removeListener(_imageUrlUpdate);
    _priceFocusNode.dispose();
    _desFocusNode.dispose();
    _imageUrlController.dispose();
    _imageUrlFocusNode.dispose();
    super.dispose();
  }

  void _imageUrlUpdate() {
    if (!_imageUrlFocusNode.hasFocus) {
      if ((!_imageUrlController.text.startsWith('http') &&
              !_imageUrlController.text.startsWith('https')) ||
          (!_imageUrlController.text.endsWith('.png') &&
              !_imageUrlController.text.endsWith('.jpg') &&
              !_imageUrlController.text.endsWith('.jpeg'))) {
        return;
      }
      setState(() {});
    }
  }

  Future<void> _saveForm() async {
    final validateValue = _form.currentState
        ?.validate(); // returns null if there is something wrong;
    if (!validateValue!) return;
    _form.currentState?.save();

    if (_editedProduct.id != null) {
      context.read<AddUpdateDeleteProductBloc>().add(UpdateProductEvent(
          updatedProduct: _editedProduct, productId: _editedProduct.id!));
      Navigator.of(context).pop();
    } else {
      context
          .read<AddUpdateDeleteProductBloc>()
          .add(AddProductEvent(newProduct: _editedProduct));
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Edit Product'),
          actions: [
            IconButton(onPressed: _saveForm, icon: const Icon(Icons.save))
          ],
        ),
        body: BlocListener<AddUpdateDeleteProductBloc,
            AddUpdateDeleteProductState>(
          listener: (context, state) {
            if (state is SuccessAddUpdateDeleteProductState) {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar(reason: SnackBarClosedReason.hide)
                ..showSnackBar(appSnackBar(text: state.message));
            } else if (state is ErrorAddUpdateDeleteProductState) {
              showErrorDialog(context, state.errorMessage);
            }
          },
          child: _buildProductForm(context),
        ));
  }

  Padding _buildProductForm(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _form,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  initialValue: _initialValues['title'],
                  decoration: const InputDecoration(labelText: 'Title'),
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(_priceFocusNode);
                  },
                  onSaved: (value) => {
                    _editedProduct = Product(
                        title: value!,
                        description: _editedProduct.description,
                        imageUrl: _editedProduct.imageUrl,
                        price: _editedProduct.price,
                        id: _editedProduct.id,
                        isFavourite: _editedProduct.isFavourite),
                  },
                  validator: (value) {
                    if (value!.isEmpty) return 'Please enter a value';
                    return null;
                  },
                ),
                TextFormField(
                  initialValue: _initialValues['price'],
                  decoration: const InputDecoration(labelText: 'Price'),
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.number,
                  focusNode: _priceFocusNode,
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(_desFocusNode);
                  },
                  onSaved: (value) => {
                    _editedProduct = Product(
                        id: _editedProduct.id,
                        title: _editedProduct.title,
                        description: _editedProduct.description,
                        imageUrl: _editedProduct.imageUrl,
                        price: double.parse(value!),
                        isFavourite: _editedProduct.isFavourite)
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter a value';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Please enter a valid number';
                    }
                    if (double.parse(value) <= 0) {
                      return 'Please enter a value greater than zero';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  initialValue: _initialValues['description'],
                  decoration: const InputDecoration(labelText: 'Description'),
                  keyboardType: TextInputType.multiline,
                  maxLines: 3,
                  focusNode: _desFocusNode,
                  onSaved: (value) => {
                    _editedProduct = Product(
                      id: _editedProduct.id,
                      title: _editedProduct.title,
                      description: value!,
                      imageUrl: _editedProduct.imageUrl,
                      price: _editedProduct.price,
                      isFavourite: _editedProduct.isFavourite,
                    )
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter a description.';
                    }
                    if (value.length < 10) {
                      return 'Please enter at least 10 characters';
                    }
                    return null;
                  },
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      height: 100,
                      width: 100,
                      margin: const EdgeInsets.only(top: 8, right: 10),
                      decoration: BoxDecoration(
                        border: Border.all(width: 1, color: Colors.grey),
                      ),
                      child: _imageUrlController.text.isEmpty
                          ? const Text('Enter the Url')
                          : FittedBox(
                              fit: BoxFit.contain,
                              child: Image.network(_imageUrlController.text),
                            ),
                    ),
                    Expanded(
                      child: TextFormField(
                          decoration:
                              const InputDecoration(labelText: 'image URL'),
                          keyboardType: TextInputType.url,
                          textInputAction: TextInputAction.done,
                          controller: _imageUrlController,
                          focusNode: _imageUrlFocusNode,
                          onFieldSubmitted: (_) => {_saveForm()},
                          onSaved: (value) => {
                                _editedProduct = Product(
                                    id: _editedProduct.id,
                                    title: _editedProduct.title,
                                    description: _editedProduct.description,
                                    imageUrl: value!,
                                    price: _editedProduct.price,
                                    isFavourite: _editedProduct.isFavourite)
                              },
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter image URL';
                            }
                            if (!value.startsWith('http') &&
                                !value.startsWith('https')) {
                              return 'Please enter a valid image URL';
                            }
                            if (!value.endsWith('.jpeg') &&
                                !value.endsWith('.jpg') &&
                                !value.endsWith('.png')) {
                              return 'Please enter a valid image URL';
                            }
                            return null;
                          }),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
