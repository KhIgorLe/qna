$(document).on('turbolinks:load', function () {
  $('.question').on('ajax:success', function(e) {
    var question = e.detail[0];
    $el = $('.question');
    rating($el, question)
  });

  $('.answers').on('ajax:success', function (e) {
    var answer = e.detail[0];
    $el = $('#answer_' + answer.id);
    rating($el, answer)
  });
});

function rating(el, resource) {
  el.find('.vote').html('<p>'+ resource.klass + ' ' + 'rating:' + ' ' + resource.rating + '</p>')
  el.find('.change-rating').toggle();
  el.find('.cancel-rating').toggle()
}
