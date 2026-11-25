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
      return await dbService.createTurbine(serialNumber: serialNumber, customName: customName, position: position);
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
      return await dbService.readCount();
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
      return await dbService.readTotalPowerW();
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
      return await dbService.readTurbines();
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