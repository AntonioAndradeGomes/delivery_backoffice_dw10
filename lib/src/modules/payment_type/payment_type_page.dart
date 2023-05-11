import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';
import '../../core/ui/helpers/loader.dart';
import '../../core/ui/helpers/messages.dart';
import 'payment_type_controller.dart';
import 'widgets/payment_type_form/payment_type_form_modal.dart';
import 'widgets/payment_type_item.dart';
import 'package:flutter/material.dart';
import 'widgets/payment_type_header.dart';

class PaymentTypePage extends StatefulWidget {
  const PaymentTypePage({super.key});

  @override
  State<PaymentTypePage> createState() => _PaymentTypePageState();
}

class _PaymentTypePageState extends State<PaymentTypePage>
    with Loader, Messages {
  final _controller = Modular.get<PaymentTypeController>();

  final disposers = <ReactionDisposer>[];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final filterDisposer = reaction(
        (_) => _controller.filterEnabled,
        (_) {
          _controller.loadPayments();
        },
      );

      final statusDisposer = reaction((_) => _controller.status, (status) {
        switch (status) {
          case PaymentTypeStateStatus.initial:
            break;
          case PaymentTypeStateStatus.loading:
            showLoader();
            break;
          case PaymentTypeStateStatus.loaded:
            hideLoader();
            break;
          case PaymentTypeStateStatus.error:
            hideLoader();
            showError(
              _controller.errorMessage ?? 'Erro ao buscar formas de pagamento',
            );
            break;
          case PaymentTypeStateStatus.addOrUpdatePayment:
            hideLoader();
            shorAddOrUpdatePayment();
            break;
          case PaymentTypeStateStatus.saved:
            hideLoader();
            //fechar o modal de edição/atualização
            Navigator.of(
              context,
              rootNavigator: true,
            ).pop();
            _controller.loadPayments();
            break;
        }
      });
      disposers.addAll([statusDisposer, filterDisposer]);
      _controller.loadPayments();
    });
  }

  @override
  void dispose() {
    for (final dispose in disposers) {
      dispose();
    }
    super.dispose();
  }

  void shorAddOrUpdatePayment() {
    showDialog(
      context: context,
      builder: (context) {
        return Material(
          color: Colors.black26,
          child: Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            backgroundColor: Colors.white,
            elevation: 10,
            child: PaymentTypeFormModal(
              model: _controller.paymentTypeSelected,
              controller: _controller,
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[50],
      padding: const EdgeInsets.only(
        left: 40,
        top: 40,
        right: 40,
      ),
      child: Column(
        children: [
          PaymentTypeHeader(
            controller: _controller,
          ),
          const SizedBox(
            height: 50,
          ),
          Expanded(
            child: Observer(
              builder: (_) {
                return GridView.builder(
                  itemCount: _controller.paymentTypes.length,
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    mainAxisExtent: 120,
                    mainAxisSpacing: 20,
                    crossAxisSpacing: 10,
                    maxCrossAxisExtent: 680,
                  ),
                  itemBuilder: (_, index) {
                    final paymentTypeModel = _controller.paymentTypes[index];
                    return PaymentTypeItem(
                      model: paymentTypeModel,
                      controller: _controller,
                    );
                  },
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
