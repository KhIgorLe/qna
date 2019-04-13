$(document).on('turbolinks:load', function () {
  $('.question').on('click', '.edit-question-link', function (e) {
    e.preventDefault();
    $(this).hide();
    var questionId = $(this).data('questionId');
    $('form#edit-question-' + questionId).removeClass('hidden');
  })

  $('.question').on('click', '.button-question-comment', function (e) {
    e.preventDefault();
    $(this).addClass('hidden');
    var questionId = $(this).data('questionId');
    $('form#Add-Question-Comment-' + questionId ).removeClass('hidden');
  })
});
