import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:opengov_app/service/http_service.dart';
import 'package:opengov_common/models/poll.dart';

class EditPoll extends StatefulWidget {
  final Poll? poll;

  const EditPoll({this.poll});

  @override
  _EditPollState createState() => _EditPollState();
}

class _EditPollState extends State<EditPoll> {
  static final _dateFormat = DateFormat('MMM dd, yyyy h:mm aa');

  late final TextEditingController _topicController;
  late final TextEditingController _descriptionController;
  DateTime? _end;
  late final TextEditingController _emojiController;
  var _isPermanent = false;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    _topicController = TextEditingController(text: widget.poll?.topic);
    _descriptionController =
        TextEditingController(text: widget.poll?.description);
    _end = widget.poll?.end;
    _emojiController = TextEditingController(
        text: widget.poll?.emoji ?? String.fromCharCode(0x1F4AC));
    _isPermanent = widget.poll?.isPermanent ?? false;

    _topicController.addListener(() {
      setState(() {});
    });

    _descriptionController.addListener(() {
      setState(() {});
    });
  }

  void _cancel() {
    Navigator.pop(context);
  }

  Future<void> _save() async {
    if (_formKey.currentState?.validate() ?? false) {
      final description = _descriptionController.text;
      final poll = Poll(
        id: widget.poll?.id ?? Poll.noId,
        topic: _topicController.text,
        description: description.isEmpty ? null : description,
        end: _end!,
        emoji: _emojiController.text,
        isPermanent: _isPermanent,
      );
      final response = await HttpService.createOrUpdatePoll(poll);

      if (response?.pollId != null) {
        Navigator.pop(context, poll.copyWith(id: response!.pollId!));
      }
    }
  }

  String? _isNotEmptyValidator(Object /* String|DateTime */ ? value) =>
      (value == null || (value is String && value.isEmpty))
          ? 'A value is required'
          : null;

  @override
  Widget build(BuildContext context) => AlertDialog(
        title: Text(widget.poll == null ? 'Create Poll' : 'Edit Poll'),
        content: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _topicController,
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
                  textCapitalization: TextCapitalization.sentences,
                ),
                const SizedBox(height: 16),
                DateTimeField(
                  format: _dateFormat,
                  decoration: const InputDecoration(
                    label: Text('End *'),
                    border: OutlineInputBorder(),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                  ),
                  initialValue: _end,
                  validator: _isNotEmptyValidator,
                  onShowPicker: (context, currentValue) async {
                    final date = await showDatePicker(
                      context: context,
                      firstDate: DateTime.now(),
                      initialDate: currentValue ??
                          DateTime.now().add(const Duration(days: 7)),
                      lastDate: DateTime.now().add(const Duration(days: 365)),
                    );

                    if (date != null) {
                      final time = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.fromDateTime(
                            currentValue ?? DateTime.now()),
                      );

                      return DateTimeField.combine(date, time);
                    } else {
                      return currentValue;
                    }
                  },
                  onChanged: (value) {
                    setState(() {
                      _end = value;
                    });
                  },
                ),
                const SizedBox(height: 16),
                ListTile(
                  leading: SizedBox(
                    width: 20,
                    child: TextFormField(
                      controller: _emojiController,
                      maxLength: 1,
                      decoration: const InputDecoration(counter: SizedBox()),
                      validator: _isNotEmptyValidator,
                    ),
                  ),
                  title: const Text('Emoji'),
                ),
                const SizedBox(height: 16),
                CheckboxListTile(
                  title: const Text('Permanent'),
                  controlAffinity: ListTileControlAffinity.leading,
                  contentPadding: EdgeInsets.zero,
                  value: _isPermanent,
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _isPermanent = value;
                      });
                    }
                  },
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
    _topicController.dispose();
    _descriptionController.dispose();
    _emojiController.dispose();
    super.dispose();
  }
}
