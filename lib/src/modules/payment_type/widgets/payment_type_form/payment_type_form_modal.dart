import 'package:flutter/material.dart';
import 'package:validatorless/validatorless.dart';

import '../../../../core/ui/helpers/size_extensions.dart';
import '../../../../core/ui/styles/text_styles.dart';
import '../../../../models/payment_type_model.dart';
import '../../payment_type_controller.dart';

class PaymentTypeFormModal extends StatefulWidget {
  final PaymentTypeModel? model;
  final PaymentTypeController controller;
  const PaymentTypeFormModal({
    super.key,
    required this.model,
    required this.controller,
  });

  @override
  State<PaymentTypeFormModal> createState() => _PaymentTypeFormModalState();
}

class _PaymentTypeFormModalState extends State<PaymentTypeFormModal> {
  final _nameTextEditingController = TextEditingController();
  final _acronymTextEditingController = TextEditingController();
  bool _enabled = false;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    final payment = widget.model;
    if (payment != null) {
      _nameTextEditingController.text = payment.name;
      _acronymTextEditingController.text = payment.acronym;
      _enabled = payment.enabled;
    }
    super.initState();
  }

  @override
  void dispose() {
    _nameTextEditingController.dispose();
    _acronymTextEditingController.dispose();
    super.dispose();
  }

  void _closeModal() => Navigator.of(context).pop();

  @override
  Widget build(BuildContext context) {
    final screenWidth = context.screenWidth;
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(30),
        width: screenWidth * (screenWidth > 1200 ? .5 : .7),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Stack(
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      '${widget.model == null ? 'Adicionar' : 'Editar'} forma de pagamento',
                      textAlign: TextAlign.center,
                      style: context.textStyles.textTitle,
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: InkWell(
                      onTap: _closeModal,
                      child: const Icon(
                        Icons.close,
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: _nameTextEditingController,
                decoration: const InputDecoration(
                  label: Text(
                    'Nome',
                  ),
                ),
                validator: Validatorless.required(
                  'Nome obrigatório',
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: _acronymTextEditingController,
                decoration: const InputDecoration(
                  label: Text(
                    'Sigla',
                  ),
                ),
                validator: Validatorless.required(
                  'Sigla obrigatória',
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Text(
                    'Ativo: ',
                    style: context.textStyles.textRegular,
                  ),
                  Switch(
                    value: _enabled,
                    onChanged: (value) {
                      setState(() {
                        _enabled = value;
                      });
                    },
                  ),
                ],
              ),
              const Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    height: 60,
                    padding: const EdgeInsets.all(8),
                    child: OutlinedButton(
                      onPressed: _closeModal,
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(
                          color: Colors.red,
                        ),
                      ),
                      child: Text(
                        'Cancelar',
                        style: context.textStyles.textExtraBold.copyWith(
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: 60,
                    padding: const EdgeInsets.all(8),
                    child: ElevatedButton.icon(
                      onPressed: () {
                        final valid =
                            _formKey.currentState?.validate() ?? false;
                        if (valid) {
                          final name = _nameTextEditingController.text.trim();
                          final acronym =
                              _acronymTextEditingController.text.trim();
                          widget.controller.savePayment(
                            name: name,
                            acronym: acronym,
                            enabled: _enabled,
                            id: widget.model?.id,
                          );
                        }
                      },
                      icon: const Icon(
                        Icons.save,
                      ),
                      label: const Text(
                        'Salvar',
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
