import 'dart:convert';

import 'package:ecommerce_store/home_screen.dart';
import 'package:ecommerce_store/layout/layout_cubit/layout_state.dart';
import 'package:bloc/bloc.dart';
import 'package:ecommerce_store/models/category_model.dart';
import 'package:ecommerce_store/models/user_model.dart';
import 'package:ecommerce_store/modules/screeens/cart_screen/cart_screen.dart';
import 'package:ecommerce_store/modules/screeens/category_screen/category_screen.dart';
import 'package:ecommerce_store/modules/screeens/favorite_screen/favorite_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

import '../../models/banner_model.dart';
import '../../models/product_model.dart';
import '../../modules/screeens/profile_screen/profile_screen.dart';
import '../../shared/constants/constants.dart';

class LayoutCubit extends Cubit<LayoutStates> {
  LayoutCubit() : super(LayoutInitialState());

  int bottomNavIndex = 0;
  List<Widget> layoutScreens = [
    HomeScreen(),
    CategoryScreen(),
    FavoriteScreen(),
    CartScreen(),
    ProfileScreen(),
  ];
  void changeBottomNavIndex({required int index}) {
    bottomNavIndex = index;

    emit(ChangeBottomNavIndexState());
  }

  UserModel? userModel;
  void getUserData() async {
    emit(GetUserDataLoadingState());
    Response response = await http.get(
        Uri.parse('https://student.valuxapps.com/api/profile'),
        headers: {'Authorization': token!, 'lang': 'en'});

    var responseData = jsonDecode(response.body);
    if (responseData['status'] == true) {
      userModel = UserModel.fromJson(data: responseData['data']);
      print('response is : $responseData');
      emit(GetUserDataSuccessState());
    } else {
      emit(FailedToGetUserDataState(error: responseData['message']));
    }
  }

  List<BannerModel> banners = [];
  void getBannersData() async {
    Response response = await http.get(
      Uri.parse('https://student.valuxapps.com/api/banners'),
    );

    final responseBody = jsonDecode(response.body);
    if (responseBody['status'] == true) {
      for (var item in responseBody['data']) {
        banners.add(BannerModel.fromJson(data: item));
      }
      emit(GetBannersDataSuccessState());
    } else {
      emit(FailedToGetBannersState());
    }
  }

  List<CategoryModel> categories = [];
  void getCategoriesData() async {
    Response response = await http.get(
        Uri.parse('https://student.valuxapps.com/api/categories'),
        headers: {'Authorization': token!, 'lang': 'en'});

    final responseBody = jsonDecode(response.body);
    if (responseBody['status'] == true) {
      for (var item in responseBody['data']['data']) {
        categories.add(CategoryModel.fromJson(data: item));
      }
      emit(GetCategoriesDataSuccessState());
    } else {
      emit(FailedToGetCategoriesState());
    }
  }

  List<ProductModel> products = [];
  void getProducts() async {
    Response response = await http.get(
        Uri.parse("https://student.valuxapps.com/api/home"),
        headers: {'Authorization': token!, 'lang': "en"});
    var responseBody = jsonDecode(response.body);

    /// print("Products Data is : $responseBody");
    // loop list
    if (responseBody['status'] == true) {
      for (var item in responseBody['data']['products']) {
        products.add(ProductModel.fromJson(data: item));
      }
      emit(GetProductsSuccessState());
    } else {
      emit(FailedToGetProductsState());
    }
  }

  List<ProductModel> filteredProducts = [];
  void filterProducts({required String input}) {
    filteredProducts = products
        .where((element) =>
            element.name!.toLowerCase().startsWith(input.toLowerCase()))
        .toList();
    emit(FilterProductsSuccessState());
  }

  List<ProductModel> favorites = [];
  // set مفيش تكرار
  Set<String> favoritesID = {};
  Future<void> getFavorites() async {
    favorites.clear();
    Response response = await http.get(
        Uri.parse("https://student.valuxapps.com/api/favorites"),
        headers: {"lang": "en", "Authorization": token!});
    // http
    var responseBody = jsonDecode(response.body);
    if (responseBody['status'] == true) {
      // loop list
      for (var item in responseBody['data']['data']) {
        // Refactoring
        favorites.add(ProductModel.fromJson(data: item['product']));
        favoritesID.add(item['product']['id'].toString());
      }
      print("Favorites number is : ${favorites.length}");
      emit(GetFavoritesSuccessState());
    } else {
      emit(FailedToGetFavoritesState());
    }
  }

  void addOrRemoveFromFavorites({required String productID}) async {
    Response response = await http.post(
        Uri.parse("https://student.valuxapps.com/api/favorites"),
        headers: {"lang": "en", "Authorization": token!},
        body: {"product_id": productID});
    var responseBody = jsonDecode(response.body);
    if (responseBody['status'] == true) {
      if (favoritesID.contains(productID) == true) {
        // delete
        favoritesID.remove(productID);
      } else {
        // add
        favoritesID.add(productID);
      }
      await getFavorites();
      emit(AddOrRemoveItemFromFavoritesSuccessState());
    } else {
      emit(FailedToAddOrRemoveItemFromFavoritesState());
    }
  }

  List<ProductModel> carts = [];
   Set<String> cartsId={

   };
  int totalPrice = 0;
  Future<void> getCarts() async {
    carts.clear();
    Response response = await http.get(
        Uri.parse("https://student.valuxapps.com/api/carts"),
        headers: {"Authorization": token!, "lang": "en"});
    var responseBody = jsonDecode(response.body);
    if (responseBody['status'] == true) {
      // success
      for (var item in responseBody['data']['cart_items']) {
        cartsId.add(item['product']['id'].toString());
        carts.add(ProductModel.fromJson(data: item['product']));
      }
      totalPrice = responseBody['data']['total'];
      debugPrint("Carts length is : ${carts.length}");
      emit(GetCartsSuccessState());
    } else {
      // failed
      emit(FailedToGetCartsState());
    }
  }



  void addOrRemoveProductsFromCart({required String id}) async {
    Response response = await http.post(
        Uri.parse("https://student.valuxapps.com/api/carts"),
        headers: {"lang": "en", "Authorization": token!},
        body: {"product_id": id});
    var responseBody = jsonDecode(response.body);
    if (responseBody['status'] == true) {

        // Success
      cartsId.contains(id) == true ? cartsId.remove(id) : cartsId.add(id) ;
      await  getCarts();
      emit(AddToCartSuccessState());
    } else {
        // Failed
      emit(FailedAddToCartState());
    }
  }

}
