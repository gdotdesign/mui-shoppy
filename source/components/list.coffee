#= require ./item

class List extends Component
  @TAGNAME: 'list'
  markup: [
    UI.promiseElement('div',{},[
      UI.Button.promise({name:'logout',type:"info"},[UI.promiseElement('i',{class: 'icon-signout'})])
      {select: UI.Select.promise({},[
        UI.Label.promise(),
        UI.Dropdown.promise({},[
          UI.Option.promise({value: ''},['All'])
          UI.Option.promise({value: 'drink'},['Drinks'])
          UI.Option.promise({value: 'food'},['Food'])
          UI.Option.promise({value: 'gift'},['Gifts'])
          UI.Option.promise({value: 'electronics'},['Electronics'])
          UI.Option.promise({value: 'games'},['Games'])
          UI.Option.promise({value: 'storage'},['Storage'])
          UI.Option.promise({value: 'favorite'},['Favorites'])
        ])
      ])}
      UI.Button.promise({name:'add',type:'danger'},[UI.promiseElement('i',{class: 'icon-plus'})])
      UI.Button.promise({name:'filter',type:'warning'},[UI.promiseElement('i',{class: 'icon-filter'})])
    ])
    {body: UI.promiseElement('div',{class:'body'})}
  ]

  events:
    'action [name=filter]' : 'toggleFilter'
    'action [name=add]'    : 'add'
    'action [name=logout]' : 'logout'
    'change ui-select'     : 'filterCategory'

  @get 'filter', -> @hasAttribute 'filtered'
  @set 'filter', (value)->
    @querySelector('[name=filter]').toggleAttribute 'toggled', !!value
    @toggleAttribute 'filtered', !!value

  add: ->    @fireEvent 'navigate', {page: 'add'}
  logout: -> @fireEvent 'logout', {page: 'login'}
  toggleFilter: -> @filter = !@filter

  filterCategory: ->
    if @select.value is ''
      @removeAttribute 'category'
    else
      @setAttribute 'category', @select.value

  initialize: ->
    super
    @select.label.textContent = "All"
    @added = @added.bind @
    @removed = @removed.bind @

  empty: ->
    @body.innerHTML = ''
    @ref?.off 'child_added', @added
    @ref?.off 'child_removed', @added

  added: (snapshot)->
    data = snapshot.val()
    item = Item.promise({id: snapshot.name()})()
    item.init snapshot.ref()
    @body.appendChild item

  removed: (snapshot)->
    @body.removeChild @body.querySelector("[id='#{snapshot.name()}']")

  init: (@ref)->
    @ref.on 'child_added', @added
    @ref.on 'child_removed', @removed


