# Ergo4All pose transforming package

This flutter package contains data types and logic for transforming 3d pose
data.

## Installation

Reference this package in another part of the project by adding `pose_transforming: any`
to the dependencies.

## Usage

### Normalization

Use the functions in `normalization` to normalize poses for further processing.

### Denoising / Averaging

Use the `denoise` library to average multiple poses in order to reduce noise.

### 2D pose projection

This package allows you to project a previously normalized pose onto the
anatomical planes, resulting in 2d poses.

Use the functions in [pose_2d](lib/pose_2d.dart) for this.

## Contributing

In order to generate better release notes, please include the scope `pose_transforming` in
your commit messages, eg. `fix(pose_transforming): some problem`.

This package uses [very_good_analysis](https://pub.dev/packages/very_good_analysis)
for style rules. Please make sure all warnings are fixed before committing.
