import 'package:flutter/material.dart';

import '../../../core/ui/styles/text_styles.dart';
import '../../../models/orders/order_model.dart';

class OrderItem extends StatelessWidget {
  final OrderModel orderModel;
  const OrderItem({Key? key, required this.orderModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textStyles = context.textStyles;
    return InkWell(
      onTap: () {},
      child: Row(
        children: [
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: Colors.grey,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  children: [
                    Text(
                      'Pedido',
                      style: textStyles.textBold,
                    ),
                    Text(
                      orderModel.id.toString(),
                      style: textStyles.textExtraBold,
                    ),
                    Expanded(
                      child: Text(
                        orderModel.status.name,
                        textAlign: TextAlign.end,
                        style: textStyles.textExtraBold.copyWith(
                          fontSize: 20,
                          color: orderModel.status.color,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 5,
                      height: double.infinity,
                    ),
                  ],
                ),
              ),
            ),
          ),
          const VerticalDivider(
            thickness: 1,
            color: Colors.grey,
          ),
        ],
      ),
    );
  }
}
