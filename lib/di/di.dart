import 'package:get_it/get_it.dart';
import 'package:wishlist/data/firebase_service.dart';
import 'package:wishlist/data/repositories/wish_repository_impl.dart';
import 'package:wishlist/domain/repositories/wish_repository.dart';
import 'package:wishlist/domain/usecases/create_wish_usecase.dart';
import 'package:wishlist/domain/usecases/delete_wish_usecase.dart';
import 'package:wishlist/domain/usecases/edit_wish_usecase.dart';
import 'package:wishlist/domain/usecases/get_wish_by_uid_usecase.dart';
import 'package:wishlist/domain/usecases/get_wish_list_stream_usecase.dart';

class DI {
  static final GetIt getit = GetIt.instance;

  static Future<void> registerDependencies() async {
    final firebaseService = FirebaseService();
    await firebaseService.init();
    getit.registerSingleton<FirebaseService>(firebaseService);
    getit.registerFactory<WishRepository>(() => WishRepositoryImpl(firebaseService: firebaseService));
    getit.registerFactory<CreateWishUseCase>(() => CreateWishUseCase(wishRepository: getit.get<WishRepository>()));
    getit.registerFactory<EditWishUseCase>(() => EditWishUseCase(wishRepository: getit.get<WishRepository>()));
    getit.registerFactory<GetWishListStreamUseCase>(() => GetWishListStreamUseCase(wishRepository: getit.get<WishRepository>()));
    getit.registerFactory<GetWishByUidUseCase>(() => GetWishByUidUseCase(wishRepository: getit.get<WishRepository>()));
    getit.registerFactory<DeleteWishUseCase>(() => DeleteWishUseCase(wishRepository: getit.get<WishRepository>()));
  }
}
