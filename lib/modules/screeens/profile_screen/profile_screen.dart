import 'package:ecommerce_store/layout/layout_cubit/layout_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../layout/layout_cubit/layout_state.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => LayoutCubit()..getUserData(),
        child: BlocConsumer<LayoutCubit, LayoutStates>(
          listener: (context, state) {},
          builder: (context, state) {
            final cubit = BlocProvider.of<LayoutCubit>(context);
            return Scaffold(
                body: cubit.userModel != null
                    ? Center(
                        child: Column(children: [
                          SizedBox(
                            height: 20,
                          ),
                          Text('Profile Screen',
                            style: Theme.of(context).textTheme.titleLarge!.copyWith(color: Colors.blue),
                          ),
                          Image.network('https://student.valuxapps.com/storage/uploads/users/CpFliPNQdd_1677580291.jpeg'),


                          Text(cubit.userModel!.name!,
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(cubit.userModel!.email!,
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                        ]),
                      )
                    : Center(
                        child: CircularProgressIndicator(),
                      ));
          },
        ));
  }
}
