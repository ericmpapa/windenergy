import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:windenergy/features/data/services/db_service.dart';
import 'package:windenergy/features/data/services/supabase/models/pairing_code_supabase_model.dart';
import 'package:windenergy/features/data/services/supabase/models/profile_supabase_model.dart';
import 'package:windenergy/features/data/services/supabase/models/turbine_supabase_model.dart';
import 'package:windenergy/features/domain/entities/pairing_code.dart';
import 'package:windenergy/features/domain/entities/position.dart';
import 'package:windenergy/features/domain/entities/profile.dart';
import 'package:windenergy/features/domain/entities/turbine.dart';
import 'package:windenergy/utils/exceptions.dart';
import 'package:windenergy/utils/result.dart';

class SupabaseService extends DbService{
  final SupabaseClient supabaseClient;

  SupabaseService({required this.supabaseClient});

  @override
  FutureResult<int> createTurbine({String userId = "", String serialNumber = "", String customName ="", Position position = const Position()}) async {
    try{
      final response = await supabaseClient.from("turbines").insert({"serial_number":serialNumber, "custom_name":customName}).select("id").single();
      final newTurbineId = int.parse(response["id"]);
      await supabaseClient.from("user_turbines").insert({
        "profile_id":userId,
        "turbine_id":newTurbineId,
        "custom_name":customName,
        "latitude": position.latitude,
        "longitude":position.longitude
      });
      return Success<int>(value: newTurbineId);
    } catch(e){
      throw ServerException(reason: "an error occurred on the server");
    }
  }

  @override
  FutureResult<dynamic> deleteTurbine({int turbineId = 0}) async {
    try{
      await supabaseClient.from("turbines").delete().eq("id",turbineId);
      return Success();
    } catch(e){
      throw ServerException(reason: "an error occurred on the server");
    }
  }

  @override
  FutureResult<int> readCount({String userId = ""}) async {
    try{
      final response = await supabaseClient.from("user_turbines").select().eq("profile_id",userId).count();
      return Success<int>(value: response.count);
    } catch(e){
      throw ServerException(reason: "an error occurred on the server");
    }
  }

  @override
  FutureResult<PairingCode> readPairingCode({int turbineId = 0}) async {
    try{
      final response = await supabaseClient.from("pairing_codes").select().eq("turbineId", turbineId).single();
      final pairingCode = PairingCodeSupabaseModel.fromMap(map: response);
      return Success(value: pairingCode);
    } catch(e){
      throw ServerException(reason: "an error occurred on the server");
    }
  }

  @override
  FutureResult<Profile> readProfile({String userId = ""}) async {
    try{
      final response = await supabaseClient.from("profiles").select().eq("id", userId).single();
      final profile = ProfileSupabaseModel.fromMap(map: response);
      return Success(value: profile);
    } catch(e){
      throw ServerException(reason: "an error occurred on the server");
    }
  }

  @override
  FutureResult<double> readTotalPowerW({String userId = ""}) async {
    try{
      final response = await supabaseClient.from("total_power_view").select().eq("profile_id", userId).single();
      final totalPowerW = double.parse(response["total_power_w"]);
      return Success(value: totalPowerW);
    } catch(e){
      throw ServerException(reason: "an error occurred on the server");
    }
  }

  @override
  FutureResult<dynamic> readTurbineActivation() async {
    try{
      return Success();
    } catch(e){
      throw ServerException(reason: "an error occurred on the server");
    }
  }

  @override
  FutureResult<List<Turbine>> readTurbines({String userId = ""})async {
    try{
      final responseList = await supabaseClient.from("turbines_detailed_view").select().eq("user_id", userId);
      final ret = <Turbine>[];
      for(final response in responseList){
        ret.add(TurbineSupabaseModel.fromMap(map: response));
      }
      return Success(value: ret);
    } catch(e){
      throw ServerException(reason: "an error occurred on the server");
    }
  }

  @override
  FutureResult<String> signIn({String email = "", String password = ""}) async {
    try{
      final response = await supabaseClient.auth.signInWithPassword(
        email: email,
        password: password
      );
      return Success<String>(value: response.session!.user.id);
    } on AuthException catch(e){
      String reason = "";
      switch(e.code){
        case "invalid_credentials": reason = "invalid credentials";
      }

      throw ServerException(reason: reason);
    }
  }

  @override
  FutureResult<dynamic> signOut() async {
    try{
      await supabaseClient.auth.signOut();
      return Success();
    } catch(e){
      throw ServerException(reason: "");
    }
  }

  @override
  FutureResult<String> signUp({String fullName = "", String email ="", String password = ""}) async {
    try{
      final response = await supabaseClient.auth.signUp(
        email: email,
        password: password,
        data: {"fullName":fullName}
      );
      return Success<String>(value: response.session!.user.id);
    } on AuthException catch(e){
      String reason = "";
      switch(e.code){
        case "email_exists": reason = "email address already exists in the system";
      }
      throw ServerException(reason: reason);
    }
  }

  @override
  FutureResult<dynamic> updateTurbine({int turbineId = 0, String customName = "", Position position = const Position()}) async {
    try{
      await supabaseClient.from("user_turbines").update({"custom_name":customName, "latitude":position.latitude, "longitude":position.longitude}).eq("turbine_id", turbineId);
      return Success();
    } catch(e){
      throw ServerException(reason: "an error occurred on the server");
    }
  }
}