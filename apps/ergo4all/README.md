# Ergo4all app

The main Ergo4All mobile app.

## Development

### Project structure

Dart code is mostly grouped by screen. Each screen has a view-model which holds screen state. This project also uses [flutter_hooks](https://pub.dev/packages/flutter_hooks).

### Localization

This project uses [l10n Flutter localization](https://docs.flutter.dev/ui/accessibility-and-internationalization/internationalization).
The relevant files are in the `l10n/` directory.

### Building

This app mainly targets Android, but could also be compatible with iOS.

### Testing

This app has unit tests in [test](./test) and integration tests
in [integration_test](./integration_test/).
