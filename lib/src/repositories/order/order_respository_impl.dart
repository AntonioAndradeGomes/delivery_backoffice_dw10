import 'dart:developer';

import '../../core/exceptions/repository_exception.dart';
import '../../core/rest_client/custom_dio.dart';
import '../../models/orders/order_status.dart';
import '../../models/orders/order_model.dart';
import 'order_repository.dart';

class OrderRespositoryImpl implements OrderRepository {
  final CustomDio _dio;

  OrderRespositoryImpl(
    this._dio,
  );

  @override
  Future<void> changeStatus(int id, OrderStatus status) async {
    try {
      await _dio.auth().put(
        '/orders/$id',
        data: {
          'status': status.acronym,
        },
      );
    } catch (e, s) {
      log(
        'Erro ao alterar status do pedido para ${status.acronym}',
        error: e,
        stackTrace: s,
      );
      throw RepositoryException(
        message: 'Erro ao alterar status do pedido para ${status.acronym}',
      );
    }
  }

  @override
  Future<List<OrderModel>> findAllOrders(
    DateTime date, [
    OrderStatus? status,
  ]) async {
    try {
      final response = await _dio.auth().get(
        '/orders',
        queryParameters: {
          'date': date.toIso8601String(),
          if (status != null) 'status': status.acronym,
        },
      );
      return response.data
          .map<OrderModel>((e) => OrderModel.fromMap(e))
          .toList();
    } catch (e, s) {
      log(
        'Erro ao buscar pedidos',
        error: e,
        stackTrace: s,
      );
      throw RepositoryException(
        message: 'Erro ao buscar pedidos',
      );
    }
  }

  @override
  Future<OrderModel> getById(int id) async {
    try {
      final response = await _dio.auth().get(
            '/orders/$id',
          );
      return OrderModel.fromMap(response.data);
    } catch (e, s) {
      log(
        'Erro ao buscar pedido: $id',
        error: e,
        stackTrace: s,
      );
      throw RepositoryException(
        message: 'Erro ao buscar pedido: $id',
      );
    }
  }
}
