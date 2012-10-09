
class Audit
  constructor: ->
    @questions = $.parseJSON $('.question-data').html()
    question = new Question @questions.pop()
    $('#next').click -> audit.on_next()
    $('#skip').click -> audit.on_skip()

  on_next: ->
    scorecard = $('#new_scorecard').clone()
    scorecard.find("input[type=hidden]").remove()

    $.ajax
      url: $('#new_scorecard').attr('action')
      data: scorecard.serialize()
      type: 'post'
      success: ->
        $('.audit').animate
            opacity:0
          , 
          500,
          ->
            $('#new_scorecard input[type=hidden]').attr 'value', 0
            $('#new_scorecard input[type=checkbox]').attr 'checked': false#, 'value', 1
            question = new Question audit.questions.pop()

            $('.audit').animate {opacity:1}, 500

  on_skip: ->
    question = new Question @questions.pop()

  bind_events_to_question: ->

class Question
  constructor: (question) ->
    conversation = $('#conversation_template .conversation').clone()
    answer = $('#answer_template h3').clone()

    conversation.find('.question').html question.text
    answer.html question.answer

    incorrects = []
    $.each question.incorrect, (i, inc) -> incorrects.push $('#answer_template h3').clone().html(inc)

    conversation.find('.answers').append answer
    conversation.find('.answers').append incorrects

    question_container = $('.question-container')
    question_container.html conversation

    $("#scorecard_card_id").attr 'value', question.card_id
    $("#scorecard_handle_id").attr 'value', question.handle_id

$ -> 
  window.audit = new Audit