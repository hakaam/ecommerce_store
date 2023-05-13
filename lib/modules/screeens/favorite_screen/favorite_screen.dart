import 'package:ecommerce_store/constants/colors.dart';
import 'package:ecommerce_store/layout/layout_cubit/layout_cubit.dart';
import 'package:ecommerce_store/layout/layout_cubit/layout_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc/bloc.dart';

class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = BlocProvider.of<LayoutCubit>(context);
    return BlocConsumer<LayoutCubit, LayoutStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
            body: Padding(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 12.5),
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(
                    prefixIcon: Icon(Icons.search),
                    hintText: 'Search',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25))),
              ),
              SizedBox(
                height: 12,
              ),
              Expanded(
                  child: ListView.builder(
                      itemCount: cubit.favorites.length,
                      itemBuilder: (context, index) {
                        return Container(
                          margin: EdgeInsets.symmetric(vertical: 10),
                          padding: EdgeInsets.symmetric(
                              vertical: 15, horizontal: 12.5),
                          color: fourthColor,
                          child: Row(
                            children: [
                              Image.network(
                                cubit.favorites[index].image!,
                                width: 120,
                                height: 100,
                                fit: BoxFit.fill,
                              ),
                              SizedBox(
                                width: 7,
                              ),
                              Expanded(
                                  child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    cubit.favorites[index].name!,
                                    maxLines: 1,
                                    style: TextStyle(
                                        fontSize: 16.5,
                                        fontWeight: FontWeight.bold,
                                        color: mainColor,
                                        overflow: TextOverflow.ellipsis),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text('${cubit.favorites[index].price!} \$'),
                                  MaterialButton(
                                    onPressed: () {
                                      cubit.addOrRemoveFromFavorites(
                                          productID: cubit.favorites[index].id
                                              .toString());
                                    },
                                    child: Text('Remove'),
                                    textColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(25)),
                                    color: mainColor,
                                  )
                                ],
                              ))
                            ],
                          ),
                        );
                      }))
            ],
          ),
        ));
      },
    );
  }
}
