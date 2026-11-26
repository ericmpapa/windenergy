import 'package:windenergy/features/domain/entities/position.dart';

class PositionSupabaseModel extends Position{
  const PositionSupabaseModel({super.latitude, super.longitude});

  factory PositionSupabaseModel.fromMap({required Map<String, dynamic> map}){
    final position = PositionSupabaseModel(
      latitude: map["latitude"] as double,
      longitude: map["longitude"] as double
    );
    return position;
  }
}