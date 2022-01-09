// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_service.dart';

// **************************************************************************
// ShelfRouterGenerator
// **************************************************************************

Router _$AdminServiceRouter(AdminService service) {
  final router = Router();
  router.add('POST', r'/create-poll', service.createPoll);
  router.add('GET', r'/poll-details/<pollId>', service.getPollDetails);
  router.add('POST', r'/update-comment', service.updateComment);
  return router;
}
