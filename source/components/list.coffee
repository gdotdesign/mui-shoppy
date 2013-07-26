#= require ./item

class List extends UI.View
  @TAGNAME: 'list'
  @MARKUP: [
    UI.promiseElement('div',{},[
      UI.Button.promise({name:'logout',type:"info"},[UI.promiseElement('i',{class: 'icon-signout'})])
      {select: UI.Select.promise({})}
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

  add          : -> @fireEvent 'navigate', {page: 'add'}
  logout       : -> @fireEvent 'logout', {page: 'login'}
  toggleFilter : -> @filter = !@filter

  filterCategory: ->
    return @removeAttribute 'category' unless @select.value
    @setAttribute 'category', @select.value

  initialize: ->
    super
    @select.label.textContent = "All"
    @added = @added.bind @
    @removed = @removed.bind @

    @select.dropdown.appendChild UI.Option.promise({value: ''},['All'])()
    for key, value of CATEGORIES
      @select.dropdown.appendChild UI.Option.promise({value: key},[value.label])()

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
    @fireEvent 'notify', {message: 'Item removed...', _type: 'info'}

  init: (@ref)->
    @ref.on 'child_added', @added
    @ref.on 'child_removed', @removed


