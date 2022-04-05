// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reply_service.dart';

// **************************************************************************
// ShelfRouterGenerator
// **************************************************************************

Router _$ReplyServiceRouter(ReplyService service) {
  final router = Router();
  router.add('GET', r'/<commentId>', service.getCommentReplies);
  router.add('POST', r'/add-reply', service.addReply);
  router.add('POST', r'/vote-reply', service.voteReply);
  router.add('GET', r'/reply/<replyId>', service.getReplyDetails);
  router.add('GET', r'/report/<commentId>', service.getReplyReport);
  return router;
}
