import 'package:flutter_test/flutter_test.dart';
import 'package:template_vgv_app/core/router/redirect_resolver.dart';

void main() {
  const loginPath = '/login';
  const splashPath = '/';
  const homePath = '/users';

  String? resolve({required bool isSignedIn, required String location}) =>
      resolveRedirect(
        isSignedIn: isSignedIn,
        location: location,
        loginPath: loginPath,
        splashPath: splashPath,
        homePath: homePath,
      );

  group('resolveRedirect', () {
    group('when signed out', () {
      test('stays on login', () {
        expect(resolve(isSignedIn: false, location: loginPath), isNull);
      });

      test('splash redirects to login', () {
        expect(resolve(isSignedIn: false, location: splashPath), loginPath);
      });

      test('home redirects to login', () {
        expect(resolve(isSignedIn: false, location: homePath), loginPath);
      });

      test('deep link redirects to login', () {
        expect(resolve(isSignedIn: false, location: '/users/7'), loginPath);
      });

      test('another tab redirects to login', () {
        expect(resolve(isSignedIn: false, location: '/settings'), loginPath);
      });
    });

    group('when signed in', () {
      test('login redirects to home', () {
        expect(resolve(isSignedIn: true, location: loginPath), homePath);
      });

      test('splash redirects to home', () {
        expect(resolve(isSignedIn: true, location: splashPath), homePath);
      });

      test('home stays', () {
        expect(resolve(isSignedIn: true, location: homePath), isNull);
      });

      test('deep link stays', () {
        expect(resolve(isSignedIn: true, location: '/users/7'), isNull);
      });

      test('another tab stays', () {
        expect(resolve(isSignedIn: true, location: '/settings'), isNull);
      });
    });
  });
}
