// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'poll_service.dart';

// **************************************************************************
// ShelfRouterGenerator
// **************************************************************************

Router _$PollServiceRouter(PollService service) {
  final router = Router();
  router.add('GET', r'/list', service.listPolls);
  router.add('GET', r'/details/<pollId>', service.getPollDetails);
  return router;
}
