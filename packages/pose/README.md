# Ergo4All pose package

This flutter package contains data types and logic for interacting with pose data.

It also has a built-in adapter for [mlkit pose detection](https://developers.google.com/ml-kit/vision/pose-detection).

## Installation

Reference this package in another part of the project by adding `pose: any`
to the dependencies.

## Usage

In order to get a pose, you first need to start the pose detector
using `startPoseDetection`.

Next you need to construct a `PoseDetectInput`. If you are working with the flutter camera
then the easiest way to get an input object is to use
`poseDetectInputFromCamera`.

Once you have your input, your can detect a pose from it using `detectPose`.

A pose is a `Map` where the keys are `KeyPoints` and the values
`Landmark`s. A `Landmark` contains both a 3D position and a visibility scalar. You can get these values using the
`posOf` and `visibilityOf` functions.

Once you are done with the pose detector, you should stop it
using `stopPoseDetection`.

## Contributing

In order to generate better release notes, please include the scope `pose` in
your commit messages, eg. `fix(pose): some problem`.
