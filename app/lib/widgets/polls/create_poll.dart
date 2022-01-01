import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:opengov_app/service/http_service.dart';
import 'package:opengov_common/models/poll.dart';

class CreatePoll extends StatefulWidget {
  const CreatePoll();

  @override
  _CreatePollState createState() => _CreatePollState();
}

class _CreatePollState extends State<CreatePoll> {
  static final _dateFormat = DateFormat('MMM dd, yyyy h:mm aa');

  final _topicController = TextEditingController();
  final _descriptionController = TextEditingController();
  DateTime? _end;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    _topicController.addListener(() {
      setState(() {});
    });

    _descriptionController.addListener(() {
      setState(() {});
    });
  }

  void _cancel() {
    Navigator.pop(context, false);
  }

  Future<void> _save() async {
    if (_formKey.currentState?.validate() ?? false) {
      final poll = Poll(
        id: -1,
        topic: _topicController.text,
        description: _descriptionController.text,
        end: _end!,
      );
      final response = await HttpService.createPoll(poll);

      if (response?.success ?? false) {
        Navigator.pop(context, true);
      }
    }
  }

  String? _isNotEmptyValidator(Object /* String|DateTime */ ? value) =>
      (value == null || (value is String && value.isEmpty))
          ? 'A value is required'
          : null;

  @override
  Widget build(BuildContext context) => AlertDialog(
        title: const Text('Create Poll'),
        content: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _topicController,
                decoration: const InputDecoration(
                  label: Text('Topic'),
                  border: OutlineInputBorder(),
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                ),
                validator: _isNotEmptyValidator,
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
              ),
              const SizedBox(height: 16),
              DateTimeField(
                format: _dateFormat,
                decoration: const InputDecoration(
                  label: Text('End'),
                  border: OutlineInputBorder(),
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                ),
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
            ],
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
    super.dispose();
  }
}
