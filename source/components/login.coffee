class Login extends UI.View
  @TAGNAME: 'login'
  @MARKUP: [
    {
      form: UI.Form.promise({},[
        {email: UI.Email.promise({name: 'email', required: 'true', placeholder: 'Email'})},
        {password: UI.promiseElement('input',{type:'password', required: 'true', name: 'password', placeholder: 'Password'})},
        UI.Button.promise({type: 'info'},[
          UI.promiseElement('div',{},[UI.promiseElement('i',{class:'icon-spin icon-spinner'})])
          UI.promiseElement('span',{},['Login'])
        ]),
        UI.Button.promise({type: 'danger'},[
          UI.promiseElement('div',{},[UI.promiseElement('i',{class:'icon-spin icon-spinner'})])
          UI.promiseElement('span',{},['Register'])
        ])
      ])
    }
  ]

  events:
    'validate'                      : 'validate'
    'action ui-button[type=info]'   : 'login'
    'action ui-button[type=danger]' : 'register'

  @set 'loading', (value)->
    if value
      @querySelector("ui-button[type=#{value}]").setAttribute 'loading', true
      for el in @querySelectorAll('ui-button')
        el.disabled = true
    else
      for el in @querySelectorAll('ui-button')
        el.removeAttribute 'loading'
      @validate()

  validate: ->
    el.disabled = @form.invalid for el in @querySelectorAll('ui-button')

  start: ->
    @auth = new FirebaseSimpleLogin REF, @_authentication.bind @

  logout: ->
    return unless @auth
    @auth.logout()

  register: ->
    return unless @form.validate()
    @auth.createUser @email.value, @password.value, @_authentication.bind(@)
    @loading = 'danger'

  login: (e)->
    return unless @form.validate()
    @auth.login 'password', {email: @email.value, password: @password.value}
    @loading = 'info'

  reset: ->
    @email.value = @password.value = ""
    @form.validate()

  _authentication: (error,user)->
    document.body.setAttribute('ready','true')
    @loading = false
    if error
      @fireEvent 'notify', {message: error, _type: 'danger'}
    else
      @reset()
      if user
        @fireEvent 'authenticated', {user: user}
      else
        @fireEvent 'unathenticated'
