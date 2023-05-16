import 'dart:developer';

import 'package:mobx/mobx.dart';
import '../../models/orders/order_model.dart';
import '../../models/orders/order_status.dart';
import '../../repositories/order/order_repository.dart';
part 'order_controller.g.dart';

enum OrderStateStatus {
  inital,
  loading,
  loaded,
  error,
  showDetailModal,
}

class OrderController = OrderControllerBase with _$OrderController;

abstract class OrderControllerBase with Store {
  final OrderRepository _repository;

  late final DateTime _today;

  OrderControllerBase(
    this._repository,
  ) {
    final todayNow = DateTime.now();
    _today = DateTime(
      todayNow.year,
      todayNow.month,
      todayNow.day,
    );
  }

  @readonly
  var _status = OrderStateStatus.inital;

  @readonly
  OrderStatus? _statusFilter;

  @readonly
  var _orders = <OrderModel>[];

  @readonly
  String? _errorMessage;

  @action
  Future<void> findOrders() async {
    try {
      _status = OrderStateStatus.loading;
      _orders = await _repository.findAllOrders(
        _today,
        _statusFilter,
      );
      _status = OrderStateStatus.loaded;
    } catch (e, s) {
      log(
        'Erro ao buscar pedidos do dia',
        error: e,
        stackTrace: s,
      );
      _status = OrderStateStatus.error;
      _errorMessage = 'Erro ao buscar pedidos do dia';
    }
  }

  Future<void> showDetailModal(OrderModel model) async {
    _status = OrderStateStatus.loading;
    await Future.delayed(Duration.zero);
    _status = OrderStateStatus.showDetailModal;
  }
}
