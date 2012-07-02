class Feedback
  sending: false

  constructor: ->
    @find_elements()
    @fill_user_info()
    @bind_elements()
    

  find_elements: ->
    @feedback = $("#feedback")
    @paledator = $('#feedback-paledator')
    @container = $('#feedback-padding')
    @form = @feedback.find('form')
    @user_name  = @form.find("#feedback_name")
    @user_email = @form.find("#feedback_email")

  fill_user_info: ->
    @user_name.val MDC.SETTINGS.read["user_name"]
    @user_email.val MDC.SETTINGS.read["user_email"]

  bind_elements: ->
    MDC.SETTINGS.add_listener 'change', (name, value)=>
      if name == 'user_name' or name == 'user_email'
        @fill_user_info()

    @user_name.change  => MDC.SETTINGS.set "user_name", @user_name.val()
    @user_email.change => MDC.SETTINGS.set "user_email", @user_email.val()

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