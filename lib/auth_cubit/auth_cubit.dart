import 'dart:convert';

import 'package:ecommerce_store/auth_cubit/auth_states.dart';
import 'package:bloc/bloc.dart';
import 'package:ecommerce_store/shared/network/local_network.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class AuthCubit extends Cubit<AuthStates> {
  AuthCubit() : super(AuthInitialState());

  void register({
    required String name,
    required String email,
    required String phone,
    required String password,
  }) async {
    emit(RegisterLoadingState());
    Response response = await http.post(
        Uri.parse('https://student.valuxapps.com/api/register'),
        headers: {
          'lang': 'en'
        },
        body: {
          'name': name,
          'email': email,
          'phone': phone,
          'password': password,
          'image': 'jdfjfj'
        });
    var responseBody = jsonDecode(response.body);
    if (responseBody['status'] == true) {
      // emit success
      print(responseBody);
      emit(RegisterSuccessState());
    } else {
      // emit fail
      print(responseBody);
      emit(FailedToRegisterState(message: responseBody['message']));
    }
  }

  void login({required String email, required String password}) async {
    emit(LoginLoadingState());
    try {
      Response response = await http.post(
          Uri.parse('https://student.valuxapps.com/api/login'),
          body: {'email': email, 'password': password});
      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);
        if (responseData['status'] == true) {
          // debugPrint('User login success and his data is : $data');

         await CacheNetwork.insertToCache(key: 'token', value: responseData['data']['token']);
          emit(LoginSuccessState());
        } else {
          debugPrint('Failed to login ,reason is : ${responseData['message']}');

          emit(FailedToLoginState(message: responseData['message']));
        }
      }
    } catch (e) {
      emit(FailedToLoginState(message: e.toString()));
    }
  }
}
