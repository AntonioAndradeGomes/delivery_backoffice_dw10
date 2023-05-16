import 'package:flutter/material.dart';

import '../../../core/ui/widgets/base_header.dart';
import '../../../models/orders/order_status.dart';

class OrderHeader extends StatefulWidget {
  const OrderHeader({Key? key}) : super(key: key);

  @override
  State<OrderHeader> createState() => _OrderHeaderState();
}

class _OrderHeaderState extends State<OrderHeader> {
  OrderStatus? statusSelected;
  @override
  Widget build(BuildContext context) {
    return BaseHeader(
      title: 'Administrar Pedidos',
      addButton: false,
      filterWidget: DropdownButton<OrderStatus?>(
        items: [
          const DropdownMenuItem(
            value: null,
            child: Text(
              'Todos',
            ),
          ),
          ...OrderStatus.values
              .map(
                (e) => DropdownMenuItem(
                  value: e,
                  child: Text(
                    e.name,
                  ),
                ),
              )
              .toList(),
        ],
        onChanged: (value) {
          setState(() {
            statusSelected = value;
          });
        },
        value: statusSelected,
      ),
    );
  }
}
