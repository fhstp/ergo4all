# Ergo4All rula package

This dart package contains functions for modelling the RULA sheet.

## Installation

Reference this package in another part of the project by adding `rula: any`
to the dependencies.

## Usage

Create instances of `RulaSheet` by passing angles you previously measured.
Use the functions on the `Degree` class to create angles.
You can then use the functions in the `scoring` module to calculate RULA scores.

## Contributing

In order to generate better release notes, please include the scope `rula` in
your commit messages, eg. `fix(rula): some problem`.

This package uses [very_good_analysis](https://pub.dev/packages/very_good_analysis)
for style rules. Please make sure all warnings are fixed before committing.
