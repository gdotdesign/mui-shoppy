#= require components/application

window.REF = new Firebase("https://spendi.firebaseio.com/")
window.CATEGORIES =
  food: 'icon-food'
  drink: 'icon-glass'
  gift: 'icon-gift'
  electronics: 'icon-desktop'
  games: 'icon-gamepad'
  storage: 'icon-archive'
  favorite: 'icon-heart'

UI.beforeload = ->
  window.app = Application.promise()()
  document.body.appendChild app

UI.onload = ->
  REF.once 'value', -> app.init()
