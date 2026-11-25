import 'package:windenergy/features/data/services/db_service.dart';
import 'package:windenergy/features/domain/entities/pairing_code.dart';
import 'package:windenergy/features/domain/entities/position.dart';
import 'package:windenergy/features/domain/entities/profile.dart';
import 'package:windenergy/features/domain/entities/turbine.dart';
import 'package:windenergy/utils/result.dart';

class SupabaseService extends DbService{
  @override
  FutureResult<int> createTurbine({String userId = "", String serialNumber = "", String customName ="", Position position = const Position()}) {
    // TODO: implement createTurbine
    throw UnimplementedError();
  }

  @override
  FutureResult<dynamic> deleteTurbine({int turbineId = 0}) {
    // TODO: implement deleteTurbine
    throw UnimplementedError();
  }

  @override
  FutureResult<int> readCount({String userId = ""}) {
    // TODO: implement readCount
    throw UnimplementedError();
  }

  @override
  FutureResult<PairingCode> readPairingCode({int turbineId = 0}) {
    // TODO: implement readPairingCode
    throw UnimplementedError();
  }

  @override
  FutureResult<Profile> readProfile({String userId = ""}) {
    // TODO: implement readProfile
    throw UnimplementedError();
  }

  @override
  FutureResult<double> readTotalPowerW({String userId = ""}) {
    // TODO: implement readTotalPowerW
    throw UnimplementedError();
  }

  @override
  FutureResult<dynamic> readTurbineActivation() {
    // TODO: implement readTurbineActivation
    throw UnimplementedError();
  }

  @override
  FutureResult<List<Turbine>> readTurbines({String userId = ""}) {
    // TODO: implement readTurbines
    throw UnimplementedError();
  }

  @override
  FutureResult<String> signIn({String email = "", String password = ""}) {
    // TODO: implement signIn
    throw UnimplementedError();
  }

  @override
  FutureResult<dynamic> signOut() {
    // TODO: implement signOut
    throw UnimplementedError();
  }

  @override
  FutureResult<String> signUp({String fullName = "", String email ="", String password = ""}) {
    // TODO: implement signUp
    throw UnimplementedError();
  }

  @override
  FutureResult<dynamic> updateTurbine({int turbineId = 0, String customName = "", Position position = const Position()}) {
    // TODO: implement updateTurbine
    throw UnimplementedError();
  }
}