import 'package:ergo4all/providers/custom_locale.dart';

/// [CustomLocale] with no behaviour. The custom locale stored in this
/// provider will always be [null] and never update.
CustomLocale makeStubCustomLocale() {
  return CustomLocale(() async {
    return null;
  }, (_) async {});
}
