import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import '../../../../core/error/exceptions.dart';

import '../../../../core/services/service_locator.dart';
import '../../../../core/strings/urls.dart';
import '../../../../providers/current_user.dart';
import '../models/produt_model.dart';

abstract class ProductRemoteDatasource {
  Future<List<ProductModel>> getAllProducts([bool filterByUser = false]);
  Future<Unit> addProduct(ProductModel newProduct);
  Future<Unit> deleteProduct(String productId);
  Future<Unit> updateProduct(ProductModel updatedProduct, String productId);
  Future<Unit> toggleFavourite(bool currentFavouriteState, String productId);
}

final authToken = sl<CurrentUser>().authToken;
final userId = sl<CurrentUser>().userId;

class ProductsRemoteDatasourceImpl extends ProductRemoteDatasource {
  final http.Client _client;

  ProductsRemoteDatasourceImpl({required http.Client client})
      : _client = client;
  @override
  Future<List<ProductModel>> getAllProducts([bool filterByUser = false]) async {
    try {
      final filterString =
          filterByUser ? 'orderBy="creatorId"&equalTo="$userId"' : '';
      // getting all products

      final getAllProductsEndPoint =
          Uri.parse("${URLs.GetAllProductsUrl}$authToken&$filterString");
      final getAllProductsResponse = await _client.get(getAllProductsEndPoint);
      final listOfProductsMapData = jsonDecode(getAllProductsResponse.body);

      // getting favourite products data

      final getFavouritesEndPoitn = Uri.parse(
          "${URLs.GetFavouriteProductsUrl}$userId.json?auth=$authToken");
      final getFavouritesResponse = await _client.get(getFavouritesEndPoitn);
      final favouritesData = jsonDecode(getFavouritesResponse.body);

      final List<ProductModel> products =
          _mapJsonProdutsAndJsonFavouritesToProductsList(
              listOfProductsMapData, favouritesData);

      return products;
    } catch (error) {
      throw ServerException();
    }
  }

  @override
  Future<Unit> addProduct(ProductModel newProduct) {
    final addProductEndPoint = Uri.parse("${URLs.AddProductUrl}$authToken");
    final addProductBody = jsonEncode({
      'title': newProduct.title,
      'description': newProduct.description,
      'imageUrl': newProduct.imageUrl,
      'price': newProduct.price,
      'creatorId': userId
    });
    try {
      _client.post(addProductEndPoint, body: addProductBody);
      return Future.value(unit);
    } catch (error) {
      throw ServerException();
    }
  }

  @override
  Future<Unit> deleteProduct(String productId) {
    final deleteProdcutEndPoint =
        Uri.parse("${URLs.DeleteProdutcUrl}$productId.json?auth=$authToken");
    try {
      _client.delete(deleteProdcutEndPoint);
      print(_client.delete(deleteProdcutEndPoint));
      return Future.value(unit);
    } catch (error) {
      throw ServerException();
    }
  }

  @override
  Future<Unit> updateProduct(
      ProductModel updatedProduct, String productId) async {
    final updatePostEndPoint =
        Uri.parse("${URLs.UpdateProductUrl}$productId.auth=$authToken");
    final updateProductBody = jsonEncode({
      "title": updatedProduct.title,
      "description": updatedProduct.description,
      "imageUrl": updatedProduct.imageUrl,
      "price": updatedProduct.price
    });
    try {
      _client.patch(updatePostEndPoint, body: updateProductBody);
      print("the try bloc made it successfully");
      return Future.value(unit);
    } catch (error) {
      throw ServerException();
    }
  }

  @override
  Future<Unit> toggleFavourite(
      bool currentFavouriteState, String productId) async {
    bool newIsFavouriteState = !currentFavouriteState;
    final toggleFavouritesEndPoint = Uri.parse(
        "${URLs.ToggleFavouriteUrl}$userId/$productId.json?auth=$authToken");
    try {
      final response = await _client.put(toggleFavouritesEndPoint,
          body: json.encode(
            newIsFavouriteState,
          ));
      if (response.statusCode >= 400) {
        throw ServerException();
      }
      return Future.value(unit);
    } catch (error) {
      throw ServerException();
    }
  }
}

List<ProductModel> _mapJsonProdutsAndJsonFavouritesToProductsList(
    Map<String, dynamic> listOfProductsMapData, dynamic favouritesData) {
  return listOfProductsMapData.entries
      .map<ProductModel>(
        (product) => ProductModel.fromJson(
            product.key,
            product.value,
            (favouritesData == null)
                ? false
                : favouritesData[product.key] ?? false),
      )
      .toList();
}
