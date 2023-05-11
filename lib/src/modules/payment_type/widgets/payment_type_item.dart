import 'package:flutter/material.dart';
import '../../../core/ui/styles/text_styles.dart';
import '../../../models/payment_type_model.dart';

class PaymentTypeItem extends StatelessWidget {
  final PaymentTypeModel model;
  const PaymentTypeItem({
    super.key,
    required this.model,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Image.asset(
              '/images/icons/payment_${model.acronym.toLowerCase()}_icon.png',
              errorBuilder: (_, error, stackTrace) {
                return Image.asset(
                  '/images/icons/payment_notfound_icon.png',
                );
              },
            ),
            const SizedBox(
              width: 20,
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Forma de Pagamento',
                  style: context.textStyles.textRegular,
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  model.name,
                  style: context.textStyles.textTitle,
                ),
              ],
            ),
            Expanded(
              child: Align(
                alignment: Alignment.bottomRight,
                child: TextButton(
                  onPressed: () {},
                  child: const Text(
                    'Editar',
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
