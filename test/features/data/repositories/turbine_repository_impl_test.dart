import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:windenergy/features/data/repositories/session.dart';
import 'package:windenergy/features/data/repositories/turbine_repository_impl.dart';
import 'package:windenergy/features/data/services/db_service.dart';
import 'package:mocktail/mocktail.dart';
import 'package:windenergy/features/domain/entities/pairing_code.dart';
import 'package:windenergy/features/domain/entities/position.dart';
import 'package:windenergy/features/domain/entities/turbine.dart';
import 'package:windenergy/utils/exceptions.dart';
import 'package:windenergy/utils/result.dart';

class MockDbService extends Mock implements DbService{}

void main(){
  late MockDbService mockDbService;
  late TurbineRepositoryImpl turbineRepositoryImpl;

  setUp((){
    mockDbService = MockDbService();
    turbineRepositoryImpl = TurbineRepositoryImpl(dbService: mockDbService);
    if(!GetIt.instance.isRegistered<Session>()){
      GetIt.instance.registerSingleton<Session>(Session(userId: "0"));
    }
  });

  group("createTurbine",(){
    test("should return Success", () async{
      final serialNumber = "test_serial";
      final customName = "custom_name";
      final position = Position();
      when(()=>mockDbService.createTurbine(userId:"0", serialNumber: serialNumber, customName: customName, position: position)).thenAnswer((_)async => Success<int>(value: 0));
      final result = await turbineRepositoryImpl.createTurbine(serialNumber: serialNumber, customName: customName, position: position);
      expect(result, Success<int>(value:0));
    });

    test("should return Error", () async{
      final serialNumber = "test_serial";
      final customName = "custom_name";
      final position = Position();
      when(()=>mockDbService.createTurbine(userId:"0", serialNumber: serialNumber, customName: customName, position: position)).thenThrow(ServerException());
      final result = await turbineRepositoryImpl.createTurbine(serialNumber: serialNumber, customName: customName, position: position);
      expect(result, Error<int>());
    });
  });

  group("deleteTurbine",(){
    test("should return Success", () async{
      final turbineId = 0;
      when(()=>mockDbService.deleteTurbine(turbineId: turbineId)).thenAnswer((_)async => Success());
      final result = await turbineRepositoryImpl.deleteTurbine(turbineId: turbineId);
      expect(result, Success());
    });

    test("should return Error", () async{
      final turbineId = 0;
      when(()=>mockDbService.deleteTurbine(turbineId: turbineId)).thenThrow(ServerException());
      final result = await turbineRepositoryImpl.deleteTurbine(turbineId: turbineId);
      expect(result, Error());
    });
  });

  group("readCount",(){
    test("should return Success", () async{
      when(()=>mockDbService.readCount(userId: "0")).thenAnswer((_)async => Success<int>(value: 0));
      final result = await turbineRepositoryImpl.readCount();
      expect(result, Success<int>(value: 0));
    });

    test("should return Error", () async{
      when(()=>mockDbService.readCount(userId: "0")).thenThrow(ServerException());
      final result = await turbineRepositoryImpl.readCount();
      expect(result, Error<int>());
    });
  });

  group("readPairingCode",(){
    test("should return Success", () async{
      final turbineId = 0;
      when(()=>mockDbService.readPairingCode(turbineId: turbineId)).thenAnswer((_)async => Success<PairingCode>());
      final result = await turbineRepositoryImpl.readPairingCode(turbineId: turbineId);
      expect(result, Success<PairingCode>());
    });

    test("should return Error", () async{
      final turbineId = 0;
      when(()=>mockDbService.readPairingCode(turbineId: turbineId)).thenThrow(ServerException());
      final result = await turbineRepositoryImpl.readPairingCode(turbineId: turbineId);
      expect(result, Error<PairingCode>());
    });
  });

  group("readTotalPowerW",(){
    test("should return Success", () async{
      when(()=>mockDbService.readTotalPowerW(userId: "0")).thenAnswer((_)async => Success<double>());
      final result = await turbineRepositoryImpl.readTotalPowerW();
      expect(result, Success<double>());
    });

    test("should return Error", () async{
      when(()=>mockDbService.readTotalPowerW(userId: "0")).thenThrow(ServerException());
      final result = await turbineRepositoryImpl.readTotalPowerW();
      expect(result, Error<double>());
    });
  });

  group("readTurbineActivation",(){
    test("should return Success", () async{
      when(()=>mockDbService.readTurbineActivation()).thenAnswer((_)async => Success());
      final result = await turbineRepositoryImpl.readTurbineActivation();
      expect(result, Success());
    });

    test("should return Error", () async{
      when(()=>mockDbService.readTurbineActivation()).thenThrow(ServerException());
      final result = await turbineRepositoryImpl.readTurbineActivation();
      expect(result, Error());
    });
  });

  group("readTurbines",(){
    test("should return Success", () async{
      when(()=>mockDbService.readTurbines(userId: "0")).thenAnswer((_)async => Success<List<Turbine>>());
      final result = await turbineRepositoryImpl.readTurbines();
      expect(result, Success<List<Turbine>>());
    });

    test("should return Error", () async{
      when(()=>mockDbService.readTurbines(userId: "0")).thenThrow(ServerException());
      final result = await turbineRepositoryImpl.readTurbines();
      expect(result, Error<List<Turbine>>());
    });
  });

  group("updateTurbine",(){
    test("should return Success", () async{
      final turbineId = 0;
      final customName = "";
      final position = Position();
      when(()=>mockDbService.updateTurbine(turbineId: turbineId, customName: customName, position: position)).thenAnswer((_)async => Success<List<Turbine>>());
      final result = await turbineRepositoryImpl.updateTurbine(turbineId: turbineId, customName: customName, position: position);
      expect(result, Success<List<Turbine>>());
    });

    test("should return Error", () async{
      final turbineId = 0;
      final customName = "";
      final position = Position();
      when(()=>mockDbService.updateTurbine(turbineId: turbineId, customName: customName, position: position)).thenThrow(ServerException());
      final result = await turbineRepositoryImpl.updateTurbine(turbineId: turbineId, customName: customName, position: position);
      expect(result, Error());
    });
  });
}