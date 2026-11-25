import 'package:get_it/get_it.dart';
import 'package:windenergy/features/data/services/db_service.dart';
import 'package:windenergy/features/domain/entities/profile.dart';
import 'package:windenergy/features/domain/repositories/profile_repository.dart';
import 'package:windenergy/utils/exceptions.dart';
import 'package:windenergy/utils/result.dart';
import 'package:windenergy/features/data/repositories/session.dart';

class ProfileRepositoryImpl extends ProfileRepository{
  final DbService dbService;

  ProfileRepositoryImpl({required this.dbService});

  @override
  FutureResult<Profile> readProfile() async {
    try{
      final session = GetIt.instance.get<Session>();
      return await dbService.readProfile(userId: session.userId);
    } on ServerException catch(e){
      return Error(reason: e.reason);
    }
  }
}