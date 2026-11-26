import 'package:windenergy/features/data/services/supabase/models/position_supabase_model.dart';
import 'package:windenergy/features/domain/entities/turbine.dart';

class TurbineSupabaseModel extends Turbine{
  const TurbineSupabaseModel({
    super.id,
    super.customName,
    super.position,
    super.serialNumber,
    super.createdAt,
    super.status,
  });

  factory TurbineSupabaseModel.fromMap({required Map<String, dynamic> map}){
    final turbine = TurbineSupabaseModel(
      id: map["turbine_id"] as int,
      customName: map["custom_name"] as String,
      position: PositionSupabaseModel.fromMap(map: map),
      serialNumber: map["serial_number"] as String,
      createdAt: DateTime.parse(map["created_at"]),
      status: map["status"] == "active"? TurbineStatus.active: TurbineStatus.inactive
    );

    return turbine;
  }
}