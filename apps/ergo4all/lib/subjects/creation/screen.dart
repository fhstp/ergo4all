import 'package:common_ui/theme/spacing.dart';
import 'package:common_ui/widgets/red_circle_app_bar.dart';
import 'package:ergo4all/subjects/creation/form.dart';
import 'package:ergo4all/subjects/storage/common.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Screen where users can add new subjects.
class SubjectCreationScreen extends StatefulWidget {
  ///
  const SubjectCreationScreen({super.key});

  /// The route name for this screen.
  static const String routeName = 'subject-creation';

  /// Creates a [MaterialPageRoute] to navigate to this screen.
  static MaterialPageRoute<void> makeRoute() {
    return MaterialPageRoute(
      builder: (_) => const SubjectCreationScreen(),
      settings: const RouteSettings(name: routeName),
    );
  }

  @override
  State<SubjectCreationScreen> createState() => _SubjectCreationScreenState();
}

class _SubjectCreationScreenState extends State<SubjectCreationScreen> {
  late final SubjectRepo subjectRepo;

  @override
  void initState() {
    super.initState();

    subjectRepo = Provider.of(context, listen: false);
  }

  Future<void> submitSubject(NewSubject subject) async {
    await subjectRepo.createNew(subject.nickName);
    if (!mounted) return;
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const RedCircleAppBar(
        // TODO: Localize
        titleText: 'New subject',
        withBackButton: true,
      ),
      body: SafeArea(
        child: Align(
          child: Padding(
            padding: const EdgeInsets.all(largeSpace),
            child: NewSubjectForm(
              onSubmit: submitSubject,
            ),
          ),
        ),
      ),
    );
  }
}
