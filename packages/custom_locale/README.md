# Ergo4All custom locale package

This flutter package logic for managing an apps custom locale.

## Installation

Reference this package in another part of the project by adding `custom_locale: any`
to the dependencies.

## Usage

Use the functions in [custom_locale](./lib/custom_locale.dart)
to get and set the custom locale. It will then be stored
using [shared preferences](https://docs.flutter.dev/cookbook/persistence/key-value).

## Contributing

In order to generate better release notes, please include the scope `custom_locale` in
your commit messages, eg. `fix(common_locale): some problem`.

This package uses [very_good_analysis](https://pub.dev/packages/very_good_analysis)
for style rules. Please make sure all warnings are fixed before committing.
