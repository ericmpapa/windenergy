import 'package:windenergy/utils/result.dart';

abstract class AuthenticationRepository {
  FutureResult signIn({String email, String password});
  FutureResult signUp({String fullName, String email, String password});
  FutureResult signOut();
  FutureResult<bool> isSignedIn();
}