import 'package:windenergy/features/domain/entities/pairing_code.dart';
import 'package:windenergy/features/domain/entities/position.dart';
import 'package:windenergy/features/domain/entities/turbine.dart';
import 'package:windenergy/utils/result.dart';
import 'package:windenergy/features/domain/entities/profile.dart';

abstract class DbService {
  FutureResult<String> signIn({String email, String password});
  FutureResult<String> signUp({String fullName, String email, String password});
  FutureResult signOut();
  FutureResult<Profile> readProfile({String userId});
  FutureResult<int> readCount({String userId});
  FutureResult<double> readTotalPowerW({String userId});
  FutureResult<List<Turbine>> readTurbines({String userId});
  FutureResult<int> createTurbine({String userId, String serialNumber, String customName, Position position});
  FutureResult<PairingCode> readPairingCode({int turbineId});
  FutureResult readTurbineActivation();
  FutureResult updateTurbine({int turbineId, String customName, Position position});
  FutureResult deleteTurbine({int turbineId});
}