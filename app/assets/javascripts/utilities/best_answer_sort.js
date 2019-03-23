$(document).on('turbolinks:load', function() {
  sortByBest.call();
});

function sortByBest() {
  var bestAnswer = $('.best-answer');

  $(bestAnswer).insertBefore('.best-answer-placeholder');
};
