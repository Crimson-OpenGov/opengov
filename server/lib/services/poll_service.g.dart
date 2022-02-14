// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'poll_service.dart';

// **************************************************************************
// ShelfRouterGenerator
// **************************************************************************

Router _$PollServiceRouter(PollService service) {
  final router = Router();
  router.add('GET', r'/list', service.listPolls);
  router.add('GET', r'/details/<pollId>', service.getPollDetails);
  router.add('GET', r'/comment/<commentId>', service.getCommentDetails);
  router.add('GET', r'/report/<pollId>', service.getReport);
  router.add('POST', r'/add-comment', service.addComment);
  router.add('POST', r'/vote', service.vote);
  return router;
}
