import 'package:ecommerce_store/layout/layout_cubit/layout_cubit.dart';
import 'package:ecommerce_store/models/category_model.dart';
import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<CategoryModel> categoriesData =
        BlocProvider.of<LayoutCubit>(context).categories;
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        child: GridView.builder(
            itemCount: categoriesData.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, mainAxisSpacing: 20, crossAxisSpacing: 15),
            itemBuilder: (context, index) {
              return Container(
                child: Column(
                  children: [
                    Expanded(
                      child: Image.network(
                        categoriesData[index].url!,
                        fit: BoxFit.fill,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(categoriesData[index].title!),
                  ],
                ),
              );
            }),
      ),
    );
  }
}
