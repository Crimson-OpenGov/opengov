import 'dart:math';

import 'package:flutter/material.dart';
import 'package:opengov_app/service/http_service.dart';
import 'package:opengov_app/widgets/base/linked_text.dart';
import 'package:opengov_app/widgets/base/list_header.dart';
import 'package:opengov_app/widgets/polls/neapolitan.dart';
import 'package:opengov_common/models/comment.dart';
import 'package:opengov_common/models/poll.dart';
import 'package:opengov_common/models/report.dart';

class PollReport extends StatefulWidget {
  final Poll poll;
  const PollReport({required this.poll});

  @override
  _PollReportState createState() => _PollReportState();
}

class _PollReportState extends State<PollReport> {
  Report? _report;

  @override
  void initState() {
    super.initState();
    _fetchReport();
  }

  Future<void> _fetchReport() async {
    final response = await HttpService.getReport(widget.poll.id,0);

    if (response != null) {
      setState(() {
        _report = response;
      });
    }
  }

  List<int> pieces(CommentStats stats) {
    var pieces = [stats.agreeCount, stats.passCount, stats.disagreeCount];

    assert(() {
      final random = Random();
      pieces = [
        random.nextInt(2000) + 500,
        random.nextInt(1000),
        random.nextInt(2000) + 500,
      ];
      return true;
    }());

    return pieces;
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Report')),
        body: _report == null
            ? const Center(child: CircularProgressIndicator())
            : ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Text(
                      widget.poll.topic,
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (widget.poll.description != null) ...[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: LinkedText(
                        widget.poll.description!,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                  const ListHeader('Responses'),
                  const SizedBox(height: 8),
                  for (final comment in _report!.comments) ...[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Row(
                        children: [
                          Flexible(
                            flex: 3,
                            fit: FlexFit.tight,
                            child: LinkedText(
                              comment.comment,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Flexible(
                            flex: 0,
                            child: Neapolitan(
                              pieces: pieces(comment.stats!),
                              colors: const [
                                Colors.green,
                                Colors.white,
                                Colors.red,
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Divider(),
                  ],
                ],
              ),
      );
}
