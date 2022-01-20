import 'package:flutter/material.dart';
import 'package:opengov_app/service/http_service.dart';
import 'package:opengov_app/widgets/polls/neapolitan.dart';
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
    final response = await HttpService.getReport(widget.poll);

    if (response != null) {
      setState(() {
        _report = response;
      });
    }
  }

  List<int> pieces(ReportComment comment) {
    var pieces = [comment.agreeCount, comment.passCount, comment.disagreeCount];

    assert(() {
      if (comment.comment.startsWith('Limit')) {
        pieces = [600, 290, 1000];
      } else if (comment.comment.startsWith('Through')) {
        pieces = [800, 550, 725];
      } else if (comment.comment.startsWith('Launch')) {
        pieces = [2100, 160, 50];
      }
      return true;
    }());

    return pieces;
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Report')),
        body: _report == null
            ? const Center(child: CircularProgressIndicator())
            : Padding(
                padding: const EdgeInsets.all(8),
                child: ListView(
                  children: [
                    Text(
                      widget.poll.topic,
                      style: const TextStyle(
                        fontSize: 34,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 16),
                    if (widget.poll.description != null) ...[
                      Text(
                        widget.poll.description!,
                        style: const TextStyle(fontSize: 20),
                      ),
                      const SizedBox(height: 16),
                    ],
                    const Text(
                      'Responses',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    for (final comment in _report!.comments) ...[
                      Row(
                        children: [
                          Flexible(
                            flex: 3,
                            child: Text(
                              comment.comment,
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Flexible(
                            flex: 0,
                            child: Neapolitan(
                              pieces: pieces(comment),
                              colors: const [
                                Colors.green,
                                Colors.white,
                                Colors.red,
                              ],
                            ),
                          ),
                        ],
                      ),
                      const Divider(),
                    ],
                  ],
                ),
              ),
      );
}
