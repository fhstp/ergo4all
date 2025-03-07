# Ergo4All pose detect package

This flutter package contains functions for detecting poses in images. It is
essentially a wrapper around [mlkit pose detection](https://developers.google.com/ml-kit/vision/pose-detection).

## Installation

Reference this package in another part of the project by adding `pose_detect: any`
to the dependencies.

## Usage

In order to get a pose, you first need to start the pose detector
using `startPoseDetection`.

Next you need to construct a `PoseDetectInput`. If you are working with the flutter camera
then the easiest way to get an input object is to use
`poseDetectInputFromCamera`.

Once you have your input, your can detect a pose from it using `detectPose`.

Once you are done with the pose detector, you should stop it
using `stopPoseDetection`.

## Contributing

In order to generate better release notes, please include the scope `pose_detect` in
your commit messages, eg. `fix(pose_detect): some problem`.

This package uses [very_good_analysis](https://pub.dev/packages/very_good_analysis)
for style rules. Please make sure all warnings are fixed before committing.
