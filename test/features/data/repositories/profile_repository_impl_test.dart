import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:windenergy/features/data/repositories/profile_repository_impl.dart';
import 'package:windenergy/features/data/repositories/session.dart';
import 'package:windenergy/features/data/services/db_service.dart';
import 'package:mocktail/mocktail.dart';
import 'package:windenergy/features/domain/entities/profile.dart';
import 'package:windenergy/utils/exceptions.dart';
import 'package:windenergy/utils/result.dart';

class MockDbService extends Mock implements DbService{}

void main(){
  late MockDbService mockDbService;
  late ProfileRepositoryImpl profileRepositoryImpl;

  setUp((){
    mockDbService = MockDbService();
    profileRepositoryImpl = ProfileRepositoryImpl(dbService: mockDbService);
    if(!GetIt.instance.isRegistered<Session>()){
      GetIt.instance.registerSingleton<Session>(Session(userId: "0"));
    }
  });

  group("readProfile",(){
    test("should return Success", () async{
      when(()=>mockDbService.readProfile(userId: "0")).thenAnswer((_)async => Success());
      final result = await profileRepositoryImpl.readProfile();
      expect(result, Success<Profile>());
    });

    test("should return Error", () async{
      when(()=>mockDbService.readProfile(userId: "0")).thenThrow(ServerException());
      final result = await profileRepositoryImpl.readProfile();
      expect(result, Error<Profile>());
    });
  });
}