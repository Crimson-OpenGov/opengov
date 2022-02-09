// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'announcement_service.dart';

// **************************************************************************
// ShelfRouterGenerator
// **************************************************************************

Router _$AnnouncementServiceRouter(AnnouncementService service) {
  final router = Router();
  router.add('GET', r'/list', service.listAnnouncement);
  router.add(
      'GET', r'/details/<announcementId>', service.getAnnouncementDetails);
  return router;
}
