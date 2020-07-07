import 'package:kongnote/model/models.dart';
import 'package:kongnote/repositories/base_repository.dart';

abstract class BaseAuthRepository extends BaseRepository {
  Future<User> loginAnonymously();

  Future<User> signupWithEmailAndPassword({String email, String password});

  Future<User> loginWithEmailAndPassword({String email, String password});

  Future<User> logout();

  Future<User> getCurrentUser();

  Future<bool> isAnonymouse();
}
