# Ergo4All pose package

This dart package contains data types and logic for interacting with pose data.

## Installation

Reference this package in another part of the project by adding `pose: any`
to the dependencies.

## Usage

A pose is a `Map` where the keys are `KeyPoints` and the values
`Landmark`s. A `Landmark` contains both a 3D position and a visibility scalar.
You can get these values using the `posOf` and `visibilityOf` functions.

## Contributing

In order to generate better release notes, please include the scope `pose` in
your commit messages, eg. `fix(pose): some problem`.

This package uses [very_good_analysis](https://pub.dev/packages/very_good_analysis)
for style rules. Please make sure all warnings are fixed before committing.
