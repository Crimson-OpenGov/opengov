import 'package:flutter/material.dart';
import 'package:opengov_app/service/http_service.dart';
import 'package:opengov_common/models/announcement.dart';
import 'package:opengov_common/models/poll.dart';

class EditAnnouncement extends StatefulWidget {
  final Announcement? announcement;

  const EditAnnouncement({this.announcement});

  @override
  _EditAnnouncementState createState() => _EditAnnouncementState();
}

class _EditAnnouncementState extends State<EditAnnouncement> {
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _emojiController;
  int? _pollId;

  List<Poll>? _polls;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    _titleController = TextEditingController(text: widget.announcement?.title);
    _descriptionController =
        TextEditingController(text: widget.announcement?.description);
    _emojiController = TextEditingController(
        text: widget.announcement?.emoji ?? String.fromCharCode(0x1F4E2));
    _pollId = widget.announcement?.pollId;

    _titleController.addListener(() {
      setState(() {});
    });

    _descriptionController.addListener(() {
      setState(() {});
    });

    _fetchData();
  }

  Future<void> _fetchData() async {
    final pollsResponse = await HttpService.listPolls();

    if (pollsResponse != null) {
      setState(() {
        _polls = pollsResponse.polls;
      });
    }
  }

  void _cancel() {
    Navigator.pop(context);
  }

  Future<void> _save() async {
    if (_formKey.currentState?.validate() ?? false) {
      final announcement = Announcement(
        id: widget.announcement?.id ?? Announcement.noId,
        pollId: _pollId,
        title: _titleController.text,
        description: _descriptionController.text,
        postedTime: DateTime.now(),
        emoji: _emojiController.text,
      );
      final response =
          await HttpService.createOrUpdateAnnouncement(announcement);

      if (response?.id != null) {
        Navigator.pop(context);
      }
    }
  }

  String? _isNotEmptyValidator(String? value) =>
      value == null || value.isEmpty ? 'A value is required' : null;

  @override
  Widget build(BuildContext context) => AlertDialog(
        title: Text(widget.announcement == null
            ? 'Create Announcement'
            : 'Edit Announcement'),
        content: _polls == null
            ? const CircularProgressIndicator()
            : Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        controller: _titleController,
                        maxLines: null,
                        decoration: const InputDecoration(
                          label: Text('Topic *'),
                          border: OutlineInputBorder(),
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                        ),
                        validator: _isNotEmptyValidator,
                        textCapitalization: TextCapitalization.sentences,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _descriptionController,
                        decoration: const InputDecoration(
                          label: Text('Description'),
                          border: OutlineInputBorder(),
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                        ),
                        maxLines: 10,
                        validator: _isNotEmptyValidator,
                        textCapitalization: TextCapitalization.sentences,
                      ),
                      const SizedBox(height: 16),
                      ListTile(
                        leading: SizedBox(
                          width: 20,
                          child: TextFormField(
                            controller: _emojiController,
                            maxLength: 1,
                            decoration:
                                const InputDecoration(counter: SizedBox()),
                            validator: _isNotEmptyValidator,
                          ),
                        ),
                        title: const Text('Emoji'),
                      ),
                      const SizedBox(height: 16),
                      ListTile(
                        leading: const Text('Poll'),
                        title: DropdownButton<int>(
                          value: _pollId,
                          items: [
                            const DropdownMenuItem(child: Text('')),
                            for (final poll in _polls!)
                              DropdownMenuItem(
                                value: poll.id,
                                child: Text(
                                  poll.topic,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                          ],
                          onChanged: (value) {
                            setState(() {
                              _pollId = value;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
        actions: [
          TextButton(
            onPressed: _cancel,
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: _save,
            child: const Text('Save'),
          ),
        ],
      );

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _emojiController.dispose();
    super.dispose();
  }
}
