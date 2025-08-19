import 'package:common_ui/theme/styles.dart';
import 'package:flutter/material.dart';

/// Contains data that was entered in a [NewSubjectForm] and can be used
/// to create a new [Subject].
@immutable
class NewSubject {}

/// A form for entering the information needed for new subjects.
class NewSubjectForm extends StatefulWidget {
  ///
  const NewSubjectForm({super.key, this.onSubmit});

  /// Callback for when a [NewSubject] is submitted from this form.
  final void Function(NewSubject)? onSubmit;

  @override
  State<NewSubjectForm> createState() => _NewSubjectFormState();
}

class _NewSubjectFormState extends State<NewSubjectForm> {
  final formKey = GlobalKey<FormState>();

  FormState get formState => formKey.currentState!;

  void submit() {
    widget.onSubmit?.call(NewSubject());
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          const Spacer(),
          ElevatedButton(
            onPressed: submit,
            style: primaryTextButtonStyle,
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }
}
