import 'detail/order_detail_modal.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';
import '../../core/ui/helpers/loader.dart';
import '../../core/ui/helpers/messages.dart';
import 'order_controller.dart';
import 'widgets/order_item.dart';
import 'package:flutter/material.dart';
import 'widgets/order_header.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({super.key});

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> with Loader, Messages {
  final _controller = Modular.get<OrderController>();
  late final ReactionDisposer statusDisposer;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      statusDisposer = reaction((_) => _controller.status, (status) async {
        switch (status) {
          case OrderStateStatus.inital:
            break;
          case OrderStateStatus.loading:
            showLoader();
            break;
          case OrderStateStatus.loaded:
            hideLoader();
            break;
          case OrderStateStatus.error:
            hideLoader();
            showError(
              _controller.errorMessage ?? 'Erro interno',
            );
            break;
          case OrderStateStatus.showDetailModal:
            hideLoader();
            showOrderDetail();
            break;
          case OrderStateStatus.statusChanged:
            hideLoader();
            Navigator.of(
              context,
              rootNavigator: true,
            ).pop();
            _controller.findOrders();
            break;
        }
      });
      _controller.findOrders();
    });
    super.initState();
  }

  void showOrderDetail() {
    showDialog(
      context: context,
      builder: (context) {
        return OrderDetailModal(
          controller: _controller,
          order: _controller.orderDtoSelected!,
        );
      },
    );
  }

  @override
  void dispose() {
    statusDisposer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, constrains) {
        return Container(
          padding: const EdgeInsets.only(
            top: 40,
          ),
          child: Column(
            children: [
              OrderHeader(
                controller: _controller,
              ),
              const SizedBox(
                height: 50,
              ),
              Expanded(
                child: Observer(
                  builder: (_) {
                    return GridView.builder(
                      itemCount: _controller.orders.length,
                      gridDelegate:
                          const SliverGridDelegateWithMaxCrossAxisExtent(
                        mainAxisExtent: 91,
                        maxCrossAxisExtent: 600,
                      ),
                      itemBuilder: (context, index) {
                        return OrderItem(
                          orderModel: _controller.orders[index],
                        );
                      },
                    );
                  },
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
