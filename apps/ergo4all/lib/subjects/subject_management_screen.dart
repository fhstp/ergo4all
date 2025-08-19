import 'dart:async';

import 'package:common_ui/theme/colors.dart';
import 'package:common_ui/theme/spacing.dart';
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
  const _SubjectEntry(this.subject, {this.onDismissed});

  final Subject subject;
  final void Function()? onDismissed;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(subject.id.toString()),
      onDismissed: (_) {
        onDismissed?.call();
      },
      confirmDismiss: (_) async {
        final isDefaultUser = subject.id == SubjectRepo.defaultSubject.id;

        // TODO: Localize
        if (isDefaultUser) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Can't delete default subject")),
          );
        }

        return !isDefaultUser;
      },
      background: Container(color: cardinal),
      child: ListTile(
        title: Text(subject.nickname),
      ),
    );
  }
}

class _SubjectManagementScreenState extends State<SubjectManagementScreen> {
  List<Subject> subjects = List.empty();

  late final SubjectRepo subjectRepo;

  @override
  void initState() {
    super.initState();
    subjectRepo = Provider.of<SubjectRepo>(context, listen: false);
    subjectRepo.getAll().then((subjects) {
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

    Future<void> deleteSubject(Subject subject) async {
      await subjectRepo.deleteById(subject.id);

      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Deleted ${subject.nickname}')),
      );
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
                child: ListView.separated(
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: smallSpace),
                  itemBuilder: (context, i) => _SubjectEntry(
                    subjects[i],
                    onDismissed: () {
                      deleteSubject(subjects[i]);
                    },
                  ),
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
