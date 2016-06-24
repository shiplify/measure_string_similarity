var app = angular.module('measureStringSimilarity', []);

var LevenshteinDistance = function(a, b) {
  var i, j, matrix;
  if (a === b) {
    return 0;
  }
  if (a.length === 0) {
    return b.length;
  }
  if (b.length === 0) {
    return a.length;
  }
  matrix = [];
  i = 0;
  while (i <= b.length) {
    matrix[i] = [i];
    i++;
  }
  j = 0;
  while (j <= a.length) {
    matrix[0][j] = j;
    j++;
  }
  i = 1;
  while (i <= b.length) {
    j = 1;
    while (j <= a.length) {
      if (b.charAt(i - 1) === a.charAt(j - 1)) {
        matrix[i][j] = matrix[i - 1][j - 1];
      } else {
        matrix[i][j] = Math.min(matrix[i - 1][j - 1] + 1, Math.min(matrix[i][j - 1] + 1, matrix[i - 1][j] + 1));
      }
      j++;
    }
    i++;
  }
  return matrix[b.length][a.length];
};
