import 'package:windenergy/features/domain/entities/pairing_code.dart';
import 'package:windenergy/features/domain/entities/position.dart';
import 'package:windenergy/features/domain/entities/turbine.dart';
import 'package:windenergy/utils/result.dart';
import 'package:windenergy/features/domain/entities/profile.dart';

abstract class DbService {
  FutureResult signIn({String email, String password});
  FutureResult signUp({String fullName, String email, String password});
  FutureResult signOut();
  FutureResult<Profile> readProfile();
  FutureResult<int> readCount();
  FutureResult<double> readTotalPowerW();
  FutureResult<List<Turbine>> readTurbines();
  FutureResult<int> createTurbine({String serialNumber, String customName, Position position});
  FutureResult<PairingCode> readPairingCode({int turbineId});
  FutureResult readTurbineActivation();
  FutureResult updateTurbine({int turbineId, String customName, Position position});
  FutureResult deleteTurbine({int turbineId});
}