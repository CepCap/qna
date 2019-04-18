$(document).on('turbolinks:load', function() {
  $('.edit-answer-link').on('click', function(e) {
    e.preventDefault();
    $(this).addClass('hidden');
    var answerId = $(this).closest('.answer').data('answerId');
    $('[data-answer-id=' + answerId + '] .edit-answer').removeClass('hidden');
  })
});
