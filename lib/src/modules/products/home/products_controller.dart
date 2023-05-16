import 'dart:developer';

import 'package:mobx/mobx.dart';
import '../../../models/product_model.dart';
import '../../../repositories/products/products_repository.dart';
part 'products_controller.g.dart';

enum ProductStateStatus {
  inital,
  loading,
  loaded,
  error,
  addOrUpdateProduct,
}

class ProductsController = ProductsControllerBase with _$ProductsController;

abstract class ProductsControllerBase with Store {
  final ProductsRepository _productsRepository;

  ProductsControllerBase(
    this._productsRepository,
  );

  @readonly
  var _status = ProductStateStatus.inital;

  @readonly
  var _products = <ProductModel>[];

  @readonly
  String? _filterName;

  @readonly
  ProductModel? _productSelected;

  @action
  Future<void> loadProducts() async {
    try {
      _status = ProductStateStatus.loading;
      _products = await _productsRepository.findAll(_filterName);
      _status = ProductStateStatus.loaded;
    } catch (e, s) {
      log(
        'Erro ao buscar produtos',
        error: e,
        stackTrace: s,
      );
      _status = ProductStateStatus.error;
    }
  }

  @action
  Future<void> filterByName(String value) async {
    _filterName = value;
    await loadProducts();
  }

  @action
  Future<void> addProduct() async {
    _status = ProductStateStatus.loading;
    await Future.delayed(Duration.zero);
    _productSelected = null;
    _status = ProductStateStatus.addOrUpdateProduct;
  }

  @action
  Future<void> editProduct(ProductModel value) async {
    _status = ProductStateStatus.loading;
    await Future.delayed(Duration.zero);
    _productSelected = value;
    _status = ProductStateStatus.addOrUpdateProduct;
  }
}
