import 'package:ergo4all/app.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Add font licenses
  LicenseRegistry.addLicense(() async* {
    final montserrat = await rootBundle.loadString('fonts/montserrat/OFL.txt');
    yield LicenseEntryWithLineBreaks(<String>['google_fonts'], montserrat);

    final nunito = await rootBundle.loadString('fonts/nunito/OFL.txt');
    yield LicenseEntryWithLineBreaks(<String>['google_fonts'], nunito);
  });

  runApp(const Ergo4AllApp());
}
