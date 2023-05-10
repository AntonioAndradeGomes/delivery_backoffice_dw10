import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';
import 'package:validatorless/validatorless.dart';
import '../../core/ui/helpers/loader.dart';
import '../../core/ui/helpers/messages.dart';
import '../../core/ui/helpers/size_extensions.dart';
import '../../core/ui/styles/colors_app.dart';
import '../../core/ui/styles/text_styles.dart';
import 'login_controller.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

//rodrigorahman@academiadoflutter.com.br
//123123
class _LoginPageState extends State<LoginPage> with Loader, Messages {
  final _controller = Modular.get<LoginController>();
  final _emailTextController = TextEditingController();
  final _passwordTextController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  late final ReactionDisposer statusReactionDisposer;

  @override
  void initState() {
    statusReactionDisposer = reaction(
      (_) => _controller.loginStatus,
      (status) {
        switch (status) {
          case LoginStateStatus.inital:
            break;
          case LoginStateStatus.loading:
            showLoader();
            break;
          case LoginStateStatus.success:
            hideLoader();
            Modular.to.navigate('/home');
            break;
          case LoginStateStatus.error:
            hideLoader();
            showError(
              _controller.errorMessage ?? 'Erro',
            );
            break;
        }
      },
    );
    super.initState();
  }

  @override
  void dispose() {
    _emailTextController.dispose();
    _passwordTextController.dispose();
    statusReactionDisposer();
    super.dispose();
  }

  void _formSubmit() {
    final formValid = _formKey.currentState?.validate() ?? false;
    if (formValid) {
      _controller.login(
        _emailTextController.text.trim(),
        _passwordTextController.text,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenShotestSide = context.screenShortestSide;
    final screenWidth = context.screenWidth;
    return Scaffold(
      backgroundColor: context.colors.black,
      body: Form(
        key: _formKey,
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: screenShotestSide * .5,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(
                      '/images/lanche.png',
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Container(
              width: screenShotestSide * .5,
              padding: EdgeInsets.only(
                top: context.percentHeigth(.10),
              ),
              child: Image.asset(
                '/images/logo.png',
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: context.percentWidth(
                    screenWidth < 1300 ? .7 : .3,
                  ),
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(30),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        FractionallySizedBox(
                          widthFactor: .3,
                          child: Image.asset(
                            '/images/logo.png',
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            'Login',
                            style: context.textStyles.textTitle,
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          controller: _emailTextController,
                          decoration: const InputDecoration(
                            labelText: 'E-mail',
                          ),
                          onFieldSubmitted: (_) => _formSubmit(),
                          validator: Validatorless.multiple([
                            Validatorless.required(
                              'E-mail obrigatório',
                            ),
                            Validatorless.email(
                              'E-mail obrigatório',
                            ),
                          ]),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          controller: _passwordTextController,
                          obscureText: true,
                          onFieldSubmitted: (_) => _formSubmit(),
                          decoration: const InputDecoration(
                            labelText: 'Senha',
                          ),
                          validator: Validatorless.required(
                            'Password Obrigatório',
                          ),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: _formSubmit,
                            child: const Text(
                              'Entrar',
                            ),
                          ),
                        ),
                      ],
                    ),
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
