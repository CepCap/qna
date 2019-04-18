$(document).on('turbolinks:load', function() {
  sortByBest.call();
});

function sortByBest() {
  $('.best-answer').insertBefore('.best-answer-placeholder');
};
