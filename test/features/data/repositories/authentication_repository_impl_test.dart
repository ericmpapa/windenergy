import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:windenergy/features/data/repositories/authentication_repository_impl.dart';
import 'package:windenergy/features/data/repositories/session.dart';
import 'package:windenergy/features/data/services/db_service.dart';
import 'package:mocktail/mocktail.dart';
import 'package:windenergy/utils/exceptions.dart';
import 'package:windenergy/utils/result.dart';

class MockDbService extends Mock implements DbService{}

void main(){
   late MockDbService mockDbService;
   late AuthenticationRepositoryImpl authenticationRepositoryImpl;

   setUp((){
     mockDbService = MockDbService();
     authenticationRepositoryImpl = AuthenticationRepositoryImpl(dbService: mockDbService);
   });

   group("signIn",(){
     test("should return Success", () async{
       final email = "test@test.com";
       final password = "pass";
       when(()=>mockDbService.signIn(email:email,password: password)).thenAnswer((_)async => Success<String>(value:"<<"));
       final result = await authenticationRepositoryImpl.signIn(email: email,password: password);
       expect(result, Success());
     });

     test("should return Error", () async{
       final email = "test@test.com";
       final password = "pass";
       when(()=>mockDbService.signIn(email:email,password: password)).thenThrow(ServerException());
       final result = await authenticationRepositoryImpl.signIn(email: email,password: password);
       expect(result, Error());
     });
   });

   group("signUp",(){
     test("should return Success", () async{
       final email = "test@test.com";
       final fullName = "test";
       final password = "pass";
       when(()=>mockDbService.signUp(email:email,fullName:fullName,password: password)).thenAnswer((_)async => Success<String>(value:""));
       final result = await authenticationRepositoryImpl.signUp(email: email, fullName:fullName, password: password);
       expect(result, Success());
     });

     test("should return Error", () async{
       final email = "test@test.com";
       final fullName = "test";
       final password = "pass";
       when(()=>mockDbService.signUp(email:email,fullName:fullName,password: password)).thenThrow(ServerException());
       final result = await authenticationRepositoryImpl.signUp(email: email, fullName:fullName, password: password);
       expect(result, Error());
     });
   });

   group("signOut",(){
     test("should return Success", () async{
       when(()=>mockDbService.signOut()).thenAnswer((_)async => Success());
       final result = await authenticationRepositoryImpl.signOut();
       expect(result, Success());
     });

     test("should return Error", () async{
       when(()=>mockDbService.signOut()).thenThrow(ServerException());
       final result = await authenticationRepositoryImpl.signOut();
       expect(result, Error());
     });
   });

   group("isSignedIn",(){
     test("should return Success", () async{
       final result = await authenticationRepositoryImpl.isSignedIn();
       expect(result, Success<bool>(value:false));
     });
   });
}