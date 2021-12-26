// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_service.dart';

// **************************************************************************
// ShelfRouterGenerator
// **************************************************************************

Router _$AuthServiceRouter(AuthService service) {
  final router = Router();
  router.add('POST', r'/login', service.login);
  router.add('POST', r'/verify', service.verify);
  return router;
}
