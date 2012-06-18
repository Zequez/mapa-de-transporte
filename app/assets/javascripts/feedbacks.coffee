class Feedback
  sending: false

  constructor: ->
    @find_elements()
    @bind_elements()
    

  find_elements: ->
    @feedback = $("#feedback")
    @paledator = $('#feedback-paledator')
    @container = $('#feedback-padding')
    @form = @feedback.find('form')

  bind_elements: ->
    @form.submit (e)=>
      e.preventDefault()
      if not @sending
        @start_sending()
        $.post @form.attr('action'), @serialize_form(), (result)=>
          @stop_sending()
          @container.html result
          @find_elements()
          @bind_elements()

  start_sending: ->
    @sending = true
    @paledator.fadeIn()

  stop_sending: ->
    @sending = false
    @paledator.fadeOut()

  # TODO: Make a serialization function that serializes the form into this. Not this crap.
  serialize_form: ->
    {"feedback": {
      "email":   @form.find('[name="feedback[email]"]').val()
      "name":    @form.find('[name="feedback[name]"]').val()
      "city_id": @form.find('[name="feedback[city_id]"]').val()
      "message": @form.find('[name="feedback[message]"]').val()
    }}

$ ->
  new Feedback