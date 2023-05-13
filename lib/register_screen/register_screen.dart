import 'package:ecommerce_store/auth_cubit/auth_cubit.dart';
import 'package:ecommerce_store/constants/colors.dart';
import 'package:ecommerce_store/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../auth_cubit/auth_states.dart';

class RegisterScreen extends StatelessWidget {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthStates>(
      listener: (context, state) {
        if (state is RegisterSuccessState) {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => HomeScreen()));
        } else if (state is FailedToRegisterState) {
          showDialog(
              context: context,
              builder: (context) => AlertDialog(
                content: Text(
                  state.message,
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                backgroundColor: Colors.red,
              ));
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Sign Up',
                    style:
                    TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  _textFieldItem(
                      controller: nameController, hintText: 'User Name'),
                  SizedBox(
                    height: 20,
                  ),
                  _textFieldItem(
                      controller: emailController, hintText: 'Email'),
                  SizedBox(
                    height: 20,
                  ),
                  _textFieldItem(
                      controller: phoneController, hintText: 'Phone'),
                  SizedBox(
                    height: 20,
                  ),
                  _textFieldItem(
                      isSecure: true,
                      controller: passwordController,
                      hintText: 'Password'),
                  SizedBox(
                    height: 20,
                  ),
                  MaterialButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        BlocProvider.of<AuthCubit>(context).register(
                            name: nameController.text,
                            email: emailController.text,
                            phone: phoneController.text,
                            password: passwordController.text);
                      }
                    },
                    child: Text(
                      state is RegisterLoadingState
                          ? 'Loading.....'
                          : 'Register',
                      style: TextStyle(
                          fontSize: 17, fontWeight: FontWeight.bold),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 12.5),
                    color: mainColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4)),
                    textColor: Colors.white,
                    minWidth: double.infinity,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

Widget _textFieldItem({
  bool? isSecure,
  required TextEditingController controller,
  required String hintText,
}) {
  return TextFormField(
    controller: controller,
    validator: (input) {
      if (controller.text.isEmpty) {
        return '$hintText must not be empty';
      } else {
        return null;
      }
    },
    obscureText: isSecure ?? false,
    decoration:
        InputDecoration(border: OutlineInputBorder(), hintText: hintText),
  );
}
