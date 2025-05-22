/// Normalized a discrete [score] from the range [1, max] into the continuous
/// range [0, 1], based on the [max] value this category of score is expected
/// to reach.
///
/// For example, the full body score is in the range [1, 7], so to normalize
/// a score of this category, you should set [max] to 7.
double normalizeScore(int score, int max) {
  return (score - 1) / (max - 1);
}
