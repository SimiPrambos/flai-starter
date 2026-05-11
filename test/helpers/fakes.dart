import 'package:mocktail/mocktail.dart';
import 'package:template_vgv_app/features/users/domain/repositories/user_repository.dart';

class MockUserRepository extends Mock implements UserRepository {}

class FakeUserRepository extends Fake implements UserRepository {}
