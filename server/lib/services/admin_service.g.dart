// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_service.dart';

// **************************************************************************
// ShelfRouterGenerator
// **************************************************************************

Router _$AdminServiceRouter(AdminService service) {
  final router = Router();
  router.add('POST', r'/create-or-update-poll', service.createOrUpdatePoll);
  router.add('POST', r'/delete-poll', service.deletePoll);
  router.add('POST', r'/update-comment', service.updateComment);
  router.add('POST', r'/create-or-update-announcement',
      service.createOrUpdateAnnouncement);
  return router;
}
