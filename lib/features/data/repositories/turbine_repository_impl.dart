import 'package:get_it/get_it.dart';
import 'package:windenergy/features/data/repositories/session.dart';
import 'package:windenergy/features/data/services/db_service.dart';
import 'package:windenergy/features/domain/entities/pairing_code.dart';
import 'package:windenergy/features/domain/entities/position.dart';
import 'package:windenergy/features/domain/entities/turbine.dart';
import 'package:windenergy/features/domain/repositories/turbine_repository.dart';
import 'package:windenergy/utils/exceptions.dart';
import 'package:windenergy/utils/result.dart';

class TurbineRepositoryImpl extends TurbineRepository{
  final DbService dbService;

  TurbineRepositoryImpl({required this.dbService});
  @override
  FutureResult<int> createTurbine({String serialNumber = "", String customName ="",Position position = const Position()}) async {
    try{
      final session = GetIt.instance.get<Session>();
      return await dbService.createTurbine(userId:session.userId,serialNumber: serialNumber, customName: customName, position: position);
    } on ServerException catch(e){
      return Error(reason: e.reason);
    }
  }

  @override
  FutureResult<dynamic> deleteTurbine({int turbineId = 0}) async {
   try{
     return await dbService.deleteTurbine(turbineId: turbineId);
   } on ServerException catch(e){
     return Error(reason: e.reason);
   }
  }

  @override
  FutureResult<int> readCount() async {
    try{
      final session = GetIt.instance.get<Session>();
      return await dbService.readCount(userId: session.userId);
    } on ServerException catch(e){
      return Error(reason: e.reason);
    }
  }

  @override
  FutureResult<PairingCode> readPairingCode({int turbineId = 0}) async {
    try{
      return await dbService.readPairingCode(turbineId: turbineId);
    } on ServerException catch(e){
      return Error(reason: e.reason);
    }
  }

  @override
  FutureResult<double> readTotalPowerW() async {
    try{
      final session = GetIt.instance.get<Session>();
      return await dbService.readTotalPowerW(userId: session.userId);
    } on ServerException catch(e){
      return Error(reason: e.reason);
    }
  }

  @override
  FutureResult<dynamic> readTurbineActivation() async {
    try{
      return await dbService.readTurbineActivation();
    } on ServerException catch(e){
      return Error(reason: e.reason);
    }
  }

  @override
  FutureResult<List<Turbine>> readTurbines() async {
    try{
      final session = GetIt.instance.get<Session>();
      return await dbService.readTurbines(userId: session.userId);
    } on ServerException catch(e){
      return Error(reason:e.reason);
    }
  }

  @override
  FutureResult<dynamic> updateTurbine({int turbineId = 0, String customName = "", Position position = const Position()}) async {
    try{
      return await dbService.updateTurbine(turbineId: turbineId, customName: customName, position: position);
    } on ServerException catch(e){
      return Error(reason: e.reason);
    }
  }
}