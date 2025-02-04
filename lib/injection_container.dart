import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/features/auth/data/datasources/networkDataSource.dart';
import 'package:ecommerce/features/auth/data/repositories/userRepositoryImpl.dart';
import 'package:ecommerce/features/auth/domain/repositories/userRepository.dart';
import 'package:ecommerce/features/auth/domain/usecases/login_usecase.dart';
import 'package:ecommerce/features/auth/domain/usecases/signup_usecase.dart';
import 'package:ecommerce/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:ecommerce/features/homePage/data/datasources/productfetchonline.dart';
import 'package:ecommerce/features/homePage/domain/repositories/home_page_repository.dart';
import 'package:ecommerce/features/homePage/domain/usecases/fetch_product_usecase.dart';
import 'package:ecommerce/features/homePage/presentation/bloc/home_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;

import 'features/homePage/data/repositories/data_product_repository.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //!bloc

  sl.registerFactory(() => AuthBloc(signupUseCase: sl(), loginUseCase: sl()));
  sl.registerFactory(() => HomeBloc(usecase: sl()));

  //! usecases
  sl.registerLazySingleton(() => SignupUseCase(repository: sl()));
  sl.registerLazySingleton(() => LoginUseCase(repository: sl()));
  sl.registerLazySingleton(() => FetchProductsOnlineUsecase(repository: sl()));

  //! repository

  sl.registerLazySingleton<UserRepository>(
      () => userRepositoryImpl(networkDataSource: sl()));

  sl.registerLazySingleton<HomePageRepository>(
      () => DataProductRepositoryImpl(fetchData: sl()));

  //! data sources
  sl.registerLazySingleton<NetworkDataSource>(
      () => NetworksDataSourceImpl(auth: sl(), firestore: sl()));

  sl.registerLazySingleton<FetchData>(
      () => FetchDataImpl(firestore: sl(), auth: sl()));

  //! core

  //! external
  sl.registerLazySingleton(() => FirebaseFirestore.instance);
  sl.registerLazySingleton(() => FirebaseAuth.instance);
}
