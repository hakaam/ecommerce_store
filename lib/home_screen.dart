import 'package:ecommerce_store/constants/colors.dart';
import 'package:ecommerce_store/layout/layout_cubit/layout_cubit.dart';
import 'package:ecommerce_store/layout/layout_cubit/layout_state.dart';
import 'package:ecommerce_store/models/product_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class HomeScreen extends StatelessWidget {
  final pageController = PageController();
  @override
  Widget build(BuildContext context) {
    final cubit = BlocProvider.of<LayoutCubit>(context);

    return BlocConsumer<LayoutCubit, LayoutStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
            body: Padding(
          padding: const EdgeInsets.all(12.0),
          child: ListView(
            shrinkWrap: true,
            children: [
              TextFormField(
                onChanged: (input) {
                  cubit.filterProducts(input: input);
                },
                decoration: InputDecoration(
                    prefixIcon: Icon(Icons.search),
                    hintText: 'Search',
                    suffixIcon: Icon(Icons.clear),
                    filled: true,
                    fillColor: Colors.grey.withOpacity(0.3),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50)),
                    contentPadding: EdgeInsets.zero),
              ),
              SizedBox(
                height: 15,
              ),
              cubit.banners.isEmpty
                  ? Center(
                      child: CupertinoActivityIndicator(),
                    )
                  : SizedBox(
                      height: 125,
                      width: double.infinity,
                      child: PageView.builder(
                          controller: pageController,
                          physics: BouncingScrollPhysics(),
                          itemCount: 3,
                          itemBuilder: (context, index) {
                            return Container(
                              margin: EdgeInsets.only(right: 20),
                              child: Image.network(
                                cubit.banners[index].url!,
                                fit: BoxFit.fill,
                              ),
                            );
                          }),
                    ),
              SizedBox(
                height: 15,
              ),
              Center(
                child: SmoothPageIndicator(
                  controller: pageController,
                  count: 3,
                  axisDirection: Axis.horizontal,
                  effect: SlideEffect(
                      spacing: 8.0,
                      radius: 25,
                      dotWidth: 16,
                      dotHeight: 16.0,
                      paintStyle: PaintingStyle.stroke,
                      strokeWidth: 1.5,
                      dotColor: Colors.grey,
                      activeDotColor: secondColor),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Categories',
                    style: TextStyle(
                        color: mainColor,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'View all',
                    style: TextStyle(
                        color: secondColor,
                        fontSize: 15,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              SizedBox(
                height: 15,
              ),
              cubit.categories.isEmpty
                  ? Center(
                      child: CupertinoActivityIndicator(),
                    )
                  : SizedBox(
                      height: 70,
                      width: double.infinity,
                      child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          physics: BouncingScrollPhysics(),
                          itemCount: cubit.categories.length,
                          separatorBuilder: (context, index) {
                            return SizedBox(
                              width: 15,
                            );
                          },
                          itemBuilder: (context, index) {
                            return CircleAvatar(
                              radius: 35,
                              backgroundImage: NetworkImage(
                                cubit.categories[index].url!,
                              ),
                            );
                          }),
                    ),
              SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Products',
                    style: TextStyle(
                        color: mainColor,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'View all',
                    style: TextStyle(
                        color: secondColor,
                        fontSize: 15,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              SizedBox(
                height: 15,
              ),
              cubit.products.isEmpty
                  ? Center(
                      child: CupertinoActivityIndicator(),
                    )
                  : GridView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: cubit.filteredProducts.isEmpty
                          ? cubit.products.length
                          : cubit.filteredProducts.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 10,
                          crossAxisSpacing: 12,
                          childAspectRatio: 0.6),
                      itemBuilder: (context, index) {
                        return _productItem(
                            model: cubit.filteredProducts.isEmpty
                                ? cubit.products[index]
                                : cubit.filteredProducts[index],
                            cubit: cubit);
                      })
            ],
          ),
        ));
      },
    );
  }
}

Widget _productItem({required ProductModel model, required LayoutCubit cubit}) {
  return Stack(
    alignment: Alignment.bottomCenter,
    children: [
      Container(
        color: Colors.grey.withOpacity(0.2),
        padding: EdgeInsets.symmetric(vertical: 40, horizontal: 12),
        child: Column(
          children: [
            Expanded(
              child: Image.network(
                model.image!,
                fit: BoxFit.fill,
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Text(
              model.name!,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            SizedBox(
              height: 7,
            ),
            Row(
              children: [
                Expanded(
                    child: Row(
                  children: [
                    Text(
                      '${model.price!} \$',
                      style: TextStyle(
                        fontSize: 13,
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      '${model.oldPrice!} \$',
                      style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                          decoration: TextDecoration.lineThrough),
                    ),
                  ],
                )),
                GestureDetector(
                  child: Icon(
                    Icons.favorite,
                    size: 20,
                    color: cubit.favoritesID.contains(model.id.toString())
                        ? Colors.red
                        : Colors.grey,
                  ),
                  onTap: () {
                    cubit.addOrRemoveFromFavorites(
                        productID: model.id.toString());
                  },
                ),
              ],
            )
          ],
        ),
      ),
      CircleAvatar(
        backgroundColor: Colors.black,
        child: GestureDetector(
          onTap: () {
            cubit.addOrRemoveProductsFromCart(id: model.id.toString());
          },
          child: Icon(
            Icons.shopping_cart,
            color: cubit.cartsId.contains(model.id.toString())
                ? Colors.red
                : Colors.grey,
          ),
        ),
      ),

    ],
  );
}
