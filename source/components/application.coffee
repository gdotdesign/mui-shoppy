#= require ./list
#= require ./login

class Application extends Component
  @TAGNAME: 'application'
  markup: [
    {pager: UI.Pager.promise({},[
      UI.Page.promise({name: 'main'},[{list: List.promise()}])
      UI.Page.promise({name: 'add'},[
        UI.Form.promise({},[
          UI.Grid.promise({columns: 3},[
            UI.Cell.promise({category: 'food'},[ UI.promiseElement('i',{class: 'icon-food'}) ])
            UI.Cell.promise({category: 'drink'},[ UI.promiseElement('i',{class: 'icon-glass'}) ])
            UI.Cell.promise({category: 'gift'},[ UI.promiseElement('i',{class: 'icon-gift'}) ])
            UI.Cell.promise({category: 'electronics'},[ UI.promiseElement('i',{class: 'icon-desktop'}) ])
            UI.Cell.promise({category: 'games'},[ UI.promiseElement('i',{class: 'icon-gamepad'}) ])
            UI.Cell.promise({category: 'storage'},[ UI.promiseElement('i',{class: 'icon-archive'}) ])
            UI.Cell.promise({category: 'favorite'},[ UI.promiseElement('i',{class: 'icon-heart'}) ])
          ])
          {name: UI.Text.promise({placeholder: 'What?'})}
          {quantity: UI.Number.promise({placeholder: 'How many?'})}
          UI.Button.promise({type: 'danger', action: 'add'},['Add'])
          UI.Button.promise({action: 'back'},['Back'])
        ])
      ])
      UI.Page.promise({name: 'login', active: 'true'},[
        UI.promiseElement('div',{class: 'center'},[
          UI.promiseElement('img',{src: '/assets/icon.png'})
          UI.promiseElement('h1',{},['Shoppy'])
          {login: Login.promise()}
        ])
      ])
    ])}
  ]

  events:
    'navigate'             : 'navigate'
    'authenticated'        : 'authenticated'
    'unathenticated'       : 'unathenticated'
    'logout'               : 'logout'
    'action [action=add]'  : 'add'
    'action [action=back]' : 'main'
    'action ui-cell'       : 'select'

  main: -> @pager.change 'main'
  logout: -> @login.logout()
  init: -> @login.start()

  select: (e)->
    el.classList.remove('selected') for el in @querySelectorAll('.selected')
    e.target.classList.add 'selected'

  add: ->
    return unless @name.value
    category = @querySelector('.selected')?.getAttribute('category') or null
    data = {done: false, name: @name.value, category: category, quantity: @quantity.value}
    REF.child(@user.id).push data, => @pager.change 'main'

  reset: ->
    @list.select.value = ""
    @list.filter = false
    @list.empty()

  resetAdd: ->
    @quantity.value = ''
    @name.value = ''
    @querySelector('.selected')?.classList.remove('selected')

  authenticated: (e)->
    @authedOnce = true
    @pager.change 'main'
    @list.init REF.child (@user = e.user).id

  unathenticated: ->
    setTimeout =>
      @removeAttribute 'loading'
      @reset()
    , if @authedOnce then 700 else 0
    @pager.change 'login'

  initialize: ->
    super
    @setAttribute 'loading', true

  navigate: (e)->
    @resetAdd() if e.page is 'add'
    @pager.change e.page
