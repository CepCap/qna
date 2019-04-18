$(document).on('turbolinks:load', function() {
  $('.vote-link').on('ajax:success', function(e) {
    var voteCount = e.detail[0].new_count;
    var voteNode = $(this).closest('.votes').find('.vote-result');
    $(this).closest('.votes').find('.vote-result').replaceWith('<div class=\'col-md-1 vote-result\'>' + voteCount + '</div>');
  })
});
