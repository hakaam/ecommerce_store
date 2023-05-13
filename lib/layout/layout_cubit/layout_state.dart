abstract class LayoutStates {}

class LayoutInitialState extends LayoutStates {}

class ChangeBottomNavIndexState extends LayoutStates {}



class GetUserDataSuccessState extends LayoutStates {}
class GetUserDataLoadingState extends LayoutStates {}
class FailedToGetUserDataState extends LayoutStates {
  String error;
  FailedToGetUserDataState({required this.error});
}




class GetFavoritesSuccessState extends LayoutStates {}
class FailedToGetFavoritesState extends LayoutStates {}
class AddOrRemoveItemFromFavoritesSuccessState extends LayoutStates{}
class FailedToAddOrRemoveItemFromFavoritesState extends LayoutStates{}



class GetBannersLoadingState extends LayoutStates {}
class GetBannersDataSuccessState extends LayoutStates {}
class FailedToGetBannersState extends LayoutStates {
  FailedToGetBannersState();
}




class GetCategoriesDataSuccessState extends LayoutStates {}
class FailedToGetCategoriesState extends LayoutStates {
  FailedToGetCategoriesState();
}



class GetProductsSuccessState extends LayoutStates {}
class FailedToGetProductsState extends LayoutStates {
  FailedToGetProductsState();
}
class FilterProductsSuccessState extends LayoutStates {}



class GetCartsSuccessState extends LayoutStates {}
class FailedToGetCartsState extends LayoutStates {}


class AddToCartSuccessState extends LayoutStates {}

class FailedAddToCartState extends LayoutStates {}
