import 'dart:async';

import 'package:common_ui/theme/styles.dart';
import 'package:common_ui/widgets/red_circle_app_bar.dart';
import 'package:ergo4all/subjects/common.dart';
import 'package:ergo4all/subjects/creation/screen.dart';
import 'package:ergo4all/subjects/storage/common.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Screen where users can manage the subjects filmed by the app.
class SubjectManagementScreen extends StatefulWidget {
  ///
  const SubjectManagementScreen({super.key});

  /// The route name for this screen.
  static const String routeName = 'subject-management';

  /// Creates a [MaterialPageRoute] to navigate to this screen.
  static MaterialPageRoute<void> makeRoute() {
    return MaterialPageRoute(
      builder: (_) => const SubjectManagementScreen(),
      settings: const RouteSettings(name: routeName),
    );
  }

  @override
  State<SubjectManagementScreen> createState() =>
      _SubjectManagementScreenState();
}

class _SubjectEntry extends StatelessWidget {
  const _SubjectEntry(this.subject);

  final Subject subject;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(subject.nickname),
    );
  }
}

class _SubjectManagementScreenState extends State<SubjectManagementScreen> {
  List<Subject> subjects = List.empty();

  @override
  void initState() {
    super.initState();

    Provider.of<SubjectRepo>(context, listen: false).getAll().then((subjects) {
      setState(() {
        this.subjects = subjects;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final navigator = Navigator.of(context);

    void goToSubjectCreator() {
      unawaited(navigator.push(SubjectCreationScreen.makeRoute()));
    }

    return Scaffold(
      appBar: const RedCircleAppBar(
        // TODO: Localize
        titleText: 'Subjects',
        withBackButton: true,
      ),
      body: SafeArea(
        child: Align(
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemBuilder: (context, i) => _SubjectEntry(subjects[i]),
                  itemCount: subjects.length,
                ),
              ),
              ElevatedButton(
                onPressed: goToSubjectCreator,
                style: primaryTextButtonStyle,
                // TODO: Localize
                child: const Text('New Subject'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
