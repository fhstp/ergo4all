/// Makes the function [f] null-friendly, by making both its input and output nullable. If the input is null, the function returns null.
TOut? Function(TIn?) doMaybe<TIn extends Object, TOut>(TOut? Function(TIn) f) {
  return (input) => input != null ? f(input) : null;
}
