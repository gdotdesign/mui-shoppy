#= require mui
#= require components/application

window.REF = new Firebase("https://spendi.firebaseio.com/")
window.CATEGORIES =
  food:        { icon: 'icon-food'    , label: 'Food'        }
  drink:       { icon: 'icon-glass'   , label: 'Drink'       }
  gift:        { icon: 'icon-gift'    , label: 'Gift'        }
  electronics: { icon: 'icon-desktop' , label: 'Electronics' }
  games:       { icon: 'icon-gamepad' , label: 'Games'       }
  storage:     { icon: 'icon-archive' , label: 'Stuff'       }
  favorite:    { icon: 'icon-heart'   , label: 'Favorites'   }

UI.onBeforeLoad = -> document.body.appendChild (@app = Application.promise()())
UI.onLoad = -> REF.once 'value', => @app.init()
