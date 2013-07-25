class Item extends Component
  @TAGNAME: 'item'
  markup: [
    { checkbox : UI.Checkbox.promise()  }
    UI.promiseElement('i',{class: 'icon-sign-blank'})
    { label    : UI.Label.promise()     }
    { number   : UI.Label.promise()     }
    UI.promiseElement('i',{class: 'icon-remove'})
  ]

  @get 'category', -> @getAttribute('category') or null
  @set 'category', (value) ->
    return @removeAttribute 'category' unless value
    @setAttribute 'category', value

  @get 'quantity', -> parseFloat(@number.textContent)
  @set 'quantity', (value)-> @number.textContent = value

  @set 'name', (value)-> @label.textContent = value
  @get 'name', -> @label.textContent

  @get 'done', -> @checkbox.checked
  @set 'done', (value)->
    @checkbox.checked = !!value
    @toggleAttribute 'done', !!value

  events:
    'action i.icon-remove': 'remove'
    'change ui-checkbox': 'change'

  remove: ->
    @ref.set null

  change: ->
    @ref.child('done').set @done

  update: (snapshot)->
    data = snapshot.val()
    return unless data
    {@name, @quantity, @category, @done} = data

  init: (@ref)->
    @ref.on 'value', @update.bind(@)
