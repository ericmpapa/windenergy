import 'package:get_it/get_it.dart';
import 'package:windenergy/features/data/repositories/session.dart';
import 'package:windenergy/features/data/services/db_service.dart';
import 'package:windenergy/features/domain/repositories/authentication_repository.dart';
import 'package:windenergy/utils/exceptions.dart';
import 'package:windenergy/utils/result.dart';

class AuthenticationRepositoryImpl extends AuthenticationRepository{
  final DbService dbService;
  Session? session;
  final getIt = GetIt.instance;

  AuthenticationRepositoryImpl({required this.dbService, this.session});

  @override
  FutureResult<dynamic> signIn({String email = "", String password = ""}) async {
    try{
      final ret =  (await dbService.signIn(email: email, password: password)) as Success<String>;
      session = Session(userId: ret.value!);
      if(!getIt.isRegistered<Session>()){
        getIt.registerSingleton<Session>(session!);
      }
      return Success();
    } on ServerException catch(e){
      return Error(reason: e.reason);
    }
  }

  @override
  FutureResult<dynamic> signOut() async {
   try{
     await dbService.signOut();
     session = null;
     if(getIt.isRegistered<Session>()){
       getIt.unregister<Session>();
     }
     return Success();
   } on ServerException catch(e){
     return Error(reason: e.reason);
   }
  }

  @override
  FutureResult<dynamic> signUp({String fullName = "", String email = "", String password = ""}) async {
    try{
      final result =  (await dbService.signUp(fullName: fullName, email: email, password: password)) as Success<String>;
      session = Session(userId: result.value!);
      if(!getIt.isRegistered<Session>()){
        getIt.registerSingleton<Session>(session!);
      }
      return Success();
    } on ServerException catch(e){
      return Error(reason: e.reason);
    }
  }

  @override
  FutureResult<bool> isSignedIn() async {
    return Success<bool>(value: session != null);
  }
}