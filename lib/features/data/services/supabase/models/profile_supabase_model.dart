import 'package:windenergy/features/domain/entities/profile.dart';

class ProfileSupabaseModel extends Profile{

  const ProfileSupabaseModel({super.id, super.email, super.fullName, super.createdAt});

  factory ProfileSupabaseModel.fromMap({required Map<String, dynamic> map}){
    final profile = ProfileSupabaseModel(
        email: map["email"],
        fullName: map["full_name"],
        createdAt: DateTime.parse(map["created_at"]),
        id: map["id"]
    );

    return profile;
  }
}