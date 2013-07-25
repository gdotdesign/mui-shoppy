casper = require('casper').create
  viewportSize: width: 320, height: 480

color = require('colorizer').create('Colorizer');

casper.userAgent 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/28.0.1500.71 Safari/537.36'
casper.on 'page.error', (message)-> console.log(message)
casper.on 'remote.message', (message)-> console.log(message)

casper.test.assertElementCount = (selector,length)->
  result = casper.evaluate """
    function(){
      return document.querySelectorAll('#{selector}').length;
    }
  """
  @assert result is length, "There are #{color.colorize(length,"TRACE")} items"

casper.touchend = (selector,message)->
  @evaluate """
    function(){
      document.querySelector('#{selector}').fireEvent('touchend');
    }
  """
  @test.pass message if message
casper.fill = (selector, value, message)->
  @evaluate """
    function(){
      document.querySelector('#{selector}').value = "#{value}";
    }
  """
  @test.pass "I fill in #{color.colorize(selector,"TRACE")} with #{color.colorize(value,"TRACE")}."

casper.waitForPage = (name)->
  @waitForSelector "[name=#{name}][active]"
  @then -> @test.assertExists "[name=#{name}][active]", "I am on the #{color.colorize(name,"TRACE")} page"

log = (message)->
  casper.test.info message
  logEnd()

logEnd = ->
  casper.test.info "-----------------------------------------------------------------"

createItem = (name, quantity, category)-> casper.then ->
  log "Create item: {name: #{name}, quantity: #{quantity}, category: #{category}}"
  @evaluate 'function(){app.fireEvent("navigate",{page: "add"})}'
  @waitForSelector 'ui-number:empty'
  @then ->
    @fill "ui-text", name
    if quantity
      @fill "ui-number", quantity
    if category
      @touchend "ui-cell[category=#{category}]", "I choose #{color.colorize(category,"TRACE")} category"
    @touchend 'ui-button[action=add]'
    @waitForPage "main"
  @then -> logEnd()

removeAllItems = ->
  casper.evaluate """
    function(){
      Array.prototype.slice.call(document.querySelectorAll('ui-item .icon-remove')).forEach(function(el){
        el.fireEvent('touchend');
      })
    }
  """
  casper.test.pass "All items are removed"

casper.start "http://localhost:4000/"
casper.waitForSelector('body[ready]',null,null,10000)
casper.then ->
  log 'Login'
  @test.assertExists '[name=login][active]', "I am on the #{color.colorize("login","TRACE")} page"
  @fill 'ui-email', 'test@test.com'
  @fill 'input[type=password]', '12345'
  @touchend '[name=login] ui-button[type=info]', "I click on the #{color.colorize("Login","TRACE")} button"
  @test.assertExists 'ui-button[type=info]:not([disabled])', "The button is not disabled"
  @test.assertExists 'ui-button[type=info][loading]', "The button is in loading state"
  @waitForPage "main"

  @then ->
    log 'Create items for every category...'
    @test.assertElementCount 'ui-item', 0
    @touchend 'ui-button[name=add]', 'I click on the + button'
    @waitForPage "add"

    createItem "Milk", null, null
    createItem "Strongbow", 4, "drink"
    createItem "Bread", null, "food"
    createItem "Earrings", 1, "gift"
    createItem "Earphones", null, 'electronics'
    createItem "GTA V", null, "games"
    createItem "Boxes", 10, "storage"
    createItem "Teaddy Bear", null, "favorite"

  @then ->
    @test.assertElementCount 'ui-item', 8
    removeAllItems()
    @test.assertElementCount 'ui-item', 0

casper.then -> @wait 1000
casper.then ->
  @test.renderResults(true)
  exitCode = if @test.getFailures().length is 0 then 0 else 1
  @exit exitCode

casper.run()
