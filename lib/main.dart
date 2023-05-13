import 'package:ecommerce_store/auth_cubit/auth_cubit.dart';
import 'package:ecommerce_store/layout/layout_cubit/layout_cubit.dart';
import 'package:ecommerce_store/layout/layout_cubit/layout_screen.dart';
import 'package:ecommerce_store/shared/constants/constants.dart';
import 'package:ecommerce_store/shared/network/local_network.dart';
import 'package:flutter/material.dart';
import 'login_screen/login_screen.dart';
import 'shared/bloc_observer/bloc_observer.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = MyBlocObserver();
  await CacheNetwork.cacheInitialization();
  token = await CacheNetwork.getCacheData(key: 'token');
  debugPrint("token is : $token");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MultiBlocProvider(
          providers: [
            BlocProvider(create: (context) => AuthCubit()),
            BlocProvider(create: (context) => LayoutCubit()..getCarts()..getFavorites()..getBannersData()..getCategoriesData()..getProducts()),          ],
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            home: token != null ? const LayoutScreen():LoginScreen()
          ),
        );
      },
    );
  }
}
