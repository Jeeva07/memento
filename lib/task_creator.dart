import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:memento/model/task.dart';


class TaskCreatorScreen extends StatefulWidget {
  final Function(Task) onTaskCreated;

  const TaskCreatorScreen({super.key, required this.onTaskCreated});

  @override
  _TaskCreatorScreenState createState() => _TaskCreatorScreenState();
}

class _TaskCreatorScreenState extends State<TaskCreatorScreen> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  DateTime? _reminderTime;
  Recurrence _selectedRecurrence = Recurrence.none;

  void _selectReminderTime() async {
    final currentTheme = Theme.of(context).platform;

    if (currentTheme == TargetPlatform.iOS) {
      await showCupertinoModalPopup(
        context: context,
        builder: (_) => Container(
          height: 250,
          color: Colors.white,
          child: Column(
            children: [
              SizedBox(
                height: 200,
                child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.dateAndTime,
                  initialDateTime: DateTime.now(),
                  onDateTimeChanged: (DateTime newDateTime) {
                    setState(() {
                      _reminderTime = newDateTime;
                    });
                  },
                ),
              ),
              CupertinoButton(
                child: const Text('Done'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        ),
      );
    } else {
      final DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime(2101),
      );

      if (pickedDate != null) {
        final TimeOfDay? pickedTime = await showTimePicker(
          context: context,
          initialTime: TimeOfDay.now(),
        );

        if (pickedTime != null) {
          setState(() {
            _reminderTime = DateTime(
              pickedDate.year,
              pickedDate.month,
              pickedDate.day,
              pickedTime.hour,
              pickedTime.minute,
            );
          });
        }
      }
    }
  }

  void _createTask() {
    final title = _titleController.text.trim();
    final description = _descriptionController.text.trim();

    if (title.isEmpty || _reminderTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please provide a title and reminder time!')),
      );
      return;
    }

    final task = Task(
      title: title,
      description: description,
      reminderTime: _reminderTime!,
      recurrence: _selectedRecurrence,
    );

    widget.onTaskCreated(task);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Task'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      _reminderTime == null
                          ? 'No Reminder Time Chosen!'
                          : 'Reminder: ${DateFormat.yMd().add_jm().format(_reminderTime!)}',
                    ),
                  ),
                  ElevatedButton(
                    onPressed: _selectReminderTime,
                    child: const Text('Select Time'),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  const Text('Repeat: '),
                  DropdownButton<Recurrence>(
                    value: _selectedRecurrence,
                    onChanged: (Recurrence? newValue) {
                      setState(() {
                        _selectedRecurrence = newValue!;
                      });
                    },
                    items: Recurrence.values.map((Recurrence recurrence) {
                      return DropdownMenuItem<Recurrence>(
                        value: recurrence,
                        child: Text(recurrence.name.toUpperCase()),
                      );
                    }).toList(),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _createTask,
                child: const Text('Create Task'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


