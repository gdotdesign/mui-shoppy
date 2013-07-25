

/***  source/components/item  ***/

var Item, _ref,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

Item = (function(_super) {
  __extends(Item, _super);

  function Item() {
    _ref = Item.__super__.constructor.apply(this, arguments);
    return _ref;
  }

  Item.TAGNAME = 'item';

  Item.prototype.markup = [
    {
      checkbox: UI.Checkbox.promise()
    }, UI.promiseElement('i', {
      "class": 'icon-sign-blank'
    }), {
      label: UI.Label.promise()
    }, {
      number: UI.Label.promise()
    }, UI.promiseElement('i', {
      "class": 'icon-remove'
    })
  ];

  Item.get('category', function() {
    return this.getAttribute('category') || null;
  });

  Item.set('category', function(value) {
    if (!value) {
      return this.removeAttribute('category');
    }
    return this.setAttribute('category', value);
  });

  Item.get('quantity', function() {
    return parseFloat(this.number.textContent);
  });

  Item.set('quantity', function(value) {
    return this.number.textContent = value;
  });

  Item.set('name', function(value) {
    return this.label.textContent = value;
  });

  Item.get('name', function() {
    return this.label.textContent;
  });

  Item.get('done', function() {
    return this.checkbox.checked;
  });

  Item.set('done', function(value) {
    this.checkbox.checked = !!value;
    return this.toggleAttribute('done', !!value);
  });

  Item.prototype.events = {
    'action i.icon-remove': 'remove',
    'change ui-checkbox': 'change'
  };

  Item.prototype.remove = function() {
    return this.ref.set(null);
  };

  Item.prototype.change = function() {
    return this.ref.child('done').set(this.done);
  };

  Item.prototype.update = function(snapshot) {
    var data;
    data = snapshot.val();
    if (!data) {
      return;
    }
    return this.name = data.name, this.quantity = data.quantity, this.category = data.category, this.done = data.done, data;
  };

  Item.prototype.init = function(ref) {
    this.ref = ref;
    return this.ref.on('value', this.update.bind(this));
  };

  return Item;

})(Component);


/***  source/components/list  ***/

var List, _ref,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

List = (function(_super) {
  __extends(List, _super);

  function List() {
    _ref = List.__super__.constructor.apply(this, arguments);
    return _ref;
  }

  List.TAGNAME = 'list';

  List.prototype.markup = [
    UI.promiseElement('div', {}, [
      UI.Button.promise({
        name: 'logout',
        type: "info"
      }, [
        UI.promiseElement('i', {
          "class": 'icon-signout'
        })
      ]), {
        select: UI.Select.promise({}, [
          UI.Label.promise(), UI.Dropdown.promise({}, [
            UI.Option.promise({
              value: ''
            }, ['All']), UI.Option.promise({
              value: 'drink'
            }, ['Drinks']), UI.Option.promise({
              value: 'food'
            }, ['Food']), UI.Option.promise({
              value: 'gift'
            }, ['Gifts']), UI.Option.promise({
              value: 'electronics'
            }, ['Electronics']), UI.Option.promise({
              value: 'games'
            }, ['Games']), UI.Option.promise({
              value: 'storage'
            }, ['Storage']), UI.Option.promise({
              value: 'favorite'
            }, ['Favorites'])
          ])
        ])
      }, UI.Button.promise({
        name: 'add',
        type: 'danger'
      }, [
        UI.promiseElement('i', {
          "class": 'icon-plus'
        })
      ]), UI.Button.promise({
        name: 'filter',
        type: 'warning'
      }, [
        UI.promiseElement('i', {
          "class": 'icon-filter'
        })
      ])
    ]), {
      body: UI.promiseElement('div', {
        "class": 'body'
      })
    }
  ];

  List.prototype.events = {
    'action [name=filter]': 'toggleFilter',
    'action [name=add]': 'add',
    'action [name=logout]': 'logout',
    'change ui-select': 'filterCategory'
  };

  List.get('filter', function() {
    return this.hasAttribute('filtered');
  });

  List.set('filter', function(value) {
    this.querySelector('[name=filter]').toggleAttribute('toggled', !!value);
    return this.toggleAttribute('filtered', !!value);
  });

  List.prototype.add = function() {
    return this.fireEvent('navigate', {
      page: 'add'
    });
  };

  List.prototype.logout = function() {
    return this.fireEvent('logout', {
      page: 'login'
    });
  };

  List.prototype.toggleFilter = function() {
    return this.filter = !this.filter;
  };

  List.prototype.filterCategory = function() {
    if (this.select.value === '') {
      return this.removeAttribute('category');
    } else {
      return this.setAttribute('category', this.select.value);
    }
  };

  List.prototype.initialize = function() {
    List.__super__.initialize.apply(this, arguments);
    this.select.label.textContent = "All";
    this.added = this.added.bind(this);
    return this.removed = this.removed.bind(this);
  };

  List.prototype.empty = function() {
    var _ref1, _ref2;
    this.body.innerHTML = '';
    if ((_ref1 = this.ref) != null) {
      _ref1.off('child_added', this.added);
    }
    return (_ref2 = this.ref) != null ? _ref2.off('child_removed', this.added) : void 0;
  };

  List.prototype.added = function(snapshot) {
    var data, item;
    data = snapshot.val();
    item = Item.promise({
      id: snapshot.name()
    })();
    item.init(snapshot.ref());
    return this.body.appendChild(item);
  };

  List.prototype.removed = function(snapshot) {
    return this.body.removeChild(this.body.querySelector("[id='" + (snapshot.name()) + "']"));
  };

  List.prototype.init = function(ref) {
    this.ref = ref;
    this.ref.on('child_added', this.added);
    return this.ref.on('child_removed', this.removed);
  };

  return List;

})(Component);


/***  source/components/login  ***/

var Login, _ref,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

Login = (function(_super) {
  __extends(Login, _super);

  function Login() {
    _ref = Login.__super__.constructor.apply(this, arguments);
    return _ref;
  }

  Login.TAGNAME = 'login';

  Login.prototype.markup = [
    {
      form: UI.Form.promise({}, [
        {
          email: UI.Email.promise({
            name: 'email',
            required: 'true',
            placeholder: 'Email'
          })
        }, {
          password: UI.promiseElement('input', {
            type: 'password',
            required: 'true',
            name: 'password',
            placeholder: 'Password'
          })
        }, UI.Button.promise({
          type: 'info'
        }, [
          UI.promiseElement('div', {}, [
            UI.promiseElement('i', {
              "class": 'icon-spin icon-spinner'
            })
          ]), UI.promiseElement('span', {}, ['Login'])
        ]), UI.Button.promise({
          type: 'danger'
        }, [
          UI.promiseElement('div', {}, [
            UI.promiseElement('i', {
              "class": 'icon-spin icon-spinner'
            })
          ]), UI.promiseElement('span', {}, ['Register'])
        ])
      ])
    }
  ];

  Login.prototype.events = {
    'validate': 'validate',
    'action ui-button[type=info]': 'login',
    'action ui-button[type=danger]': 'register'
  };

  Login.set('loading', function(value) {
    var el, _i, _j, _len, _len1, _ref1, _ref2, _results;
    if (value) {
      this.querySelector("ui-button[type=" + value + "]").setAttribute('loading', true);
      _ref1 = this.querySelectorAll('ui-button');
      _results = [];
      for (_i = 0, _len = _ref1.length; _i < _len; _i++) {
        el = _ref1[_i];
        _results.push(el.disabled = true);
      }
      return _results;
    } else {
      _ref2 = this.querySelectorAll('ui-button');
      for (_j = 0, _len1 = _ref2.length; _j < _len1; _j++) {
        el = _ref2[_j];
        el.removeAttribute('loading');
      }
      return this.validate();
    }
  });

  Login.prototype.validate = function() {
    var el, _i, _len, _ref1, _results;
    _ref1 = this.querySelectorAll('ui-button');
    _results = [];
    for (_i = 0, _len = _ref1.length; _i < _len; _i++) {
      el = _ref1[_i];
      _results.push(el.disabled = this.form.invalid);
    }
    return _results;
  };

  Login.prototype.start = function() {
    return this.auth = new FirebaseSimpleLogin(REF, this._authentication.bind(this));
  };

  Login.prototype.logout = function() {
    if (!this.auth) {
      return;
    }
    return this.auth.logout();
  };

  Login.prototype.register = function() {
    if (!this.form.validate()) {
      return;
    }
    this.auth.createUser(this.email.value, this.password.value, this._authentication.bind(this));
    return this.loading = 'danger';
  };

  Login.prototype.login = function(e) {
    if (!this.form.validate()) {
      return;
    }
    this.auth.login('password', {
      email: this.email.value,
      password: this.password.value
    });
    return this.loading = 'info';
  };

  Login.prototype.reset = function() {
    this.email.value = this.password.value = "";
    return this.form.validate();
  };

  Login.prototype._authentication = function(error, user) {
    document.body.setAttribute('ready', 'true');
    this.loading = false;
    if (error) {
      return alert(error);
    } else {
      this.reset();
      if (user) {
        return this.fireEvent('authenticated', {
          user: user
        });
      } else {
        return this.fireEvent('unathenticated');
      }
    }
  };

  return Login;

})(Component);


/***  source/components/application  ***/

var Application, _ref,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

Application = (function(_super) {
  __extends(Application, _super);

  function Application() {
    _ref = Application.__super__.constructor.apply(this, arguments);
    return _ref;
  }

  Application.TAGNAME = 'application';

  Application.prototype.markup = [
    {
      pager: UI.Pager.promise({}, [
        UI.Page.promise({
          name: 'main'
        }, [
          {
            list: List.promise()
          }
        ]), UI.Page.promise({
          name: 'add'
        }, [
          UI.Form.promise({}, [
            UI.Grid.promise({
              columns: 3
            }, [
              UI.Cell.promise({
                category: 'food'
              }, [
                UI.promiseElement('i', {
                  "class": 'icon-food'
                })
              ]), UI.Cell.promise({
                category: 'drink'
              }, [
                UI.promiseElement('i', {
                  "class": 'icon-glass'
                })
              ]), UI.Cell.promise({
                category: 'gift'
              }, [
                UI.promiseElement('i', {
                  "class": 'icon-gift'
                })
              ]), UI.Cell.promise({
                category: 'electronics'
              }, [
                UI.promiseElement('i', {
                  "class": 'icon-desktop'
                })
              ]), UI.Cell.promise({
                category: 'games'
              }, [
                UI.promiseElement('i', {
                  "class": 'icon-gamepad'
                })
              ]), UI.Cell.promise({
                category: 'storage'
              }, [
                UI.promiseElement('i', {
                  "class": 'icon-archive'
                })
              ]), UI.Cell.promise({
                category: 'favorite'
              }, [
                UI.promiseElement('i', {
                  "class": 'icon-heart'
                })
              ])
            ]), {
              name: UI.Text.promise({
                placeholder: 'What?'
              })
            }, {
              quantity: UI.Number.promise({
                placeholder: 'How many?'
              })
            }, UI.Button.promise({
              type: 'danger',
              action: 'add'
            }, ['Add']), UI.Button.promise({
              action: 'back'
            }, ['Back'])
          ])
        ]), UI.Page.promise({
          name: 'login',
          active: 'true'
        }, [
          UI.promiseElement('div', {
            "class": 'center'
          }, [
            UI.promiseElement('img', {
              src: 'icon.png'
            }), UI.promiseElement('h1', {}, ['Shoppy']), {
              login: Login.promise()
            }
          ])
        ])
      ])
    }
  ];

  Application.prototype.events = {
    'navigate': 'navigate',
    'authenticated': 'authenticated',
    'unathenticated': 'unathenticated',
    'logout': 'logout',
    'action [action=add]': 'add',
    'action [action=back]': 'main',
    'action ui-cell': 'select'
  };

  Application.prototype.main = function() {
    return this.pager.change('main');
  };

  Application.prototype.logout = function() {
    return this.login.logout();
  };

  Application.prototype.init = function() {
    return this.login.start();
  };

  Application.prototype.select = function(e) {
    var el, _i, _len, _ref1;
    _ref1 = this.querySelectorAll('.selected');
    for (_i = 0, _len = _ref1.length; _i < _len; _i++) {
      el = _ref1[_i];
      el.classList.remove('selected');
    }
    return e.target.classList.add('selected');
  };

  Application.prototype.add = function() {
    var category, data, _ref1,
      _this = this;
    if (!this.name.value) {
      return;
    }
    category = ((_ref1 = this.querySelector('.selected')) != null ? _ref1.getAttribute('category') : void 0) || null;
    data = {
      done: false,
      name: this.name.value,
      category: category,
      quantity: this.quantity.value
    };
    return REF.child(this.user.id).push(data, function() {
      return _this.pager.change('main');
    });
  };

  Application.prototype.reset = function() {
    this.list.select.value = "";
    this.list.filter = false;
    return this.list.empty();
  };

  Application.prototype.resetAdd = function() {
    var _ref1;
    this.quantity.value = '';
    this.name.value = '';
    return (_ref1 = this.querySelector('.selected')) != null ? _ref1.classList.remove('selected') : void 0;
  };

  Application.prototype.authenticated = function(e) {
    this.authedOnce = true;
    this.pager.change('main');
    return this.list.init(REF.child((this.user = e.user).id));
  };

  Application.prototype.unathenticated = function() {
    var _this = this;
    setTimeout(function() {
      _this.removeAttribute('loading');
      return _this.reset();
    }, this.authedOnce ? 700 : 0);
    return this.pager.change('login');
  };

  Application.prototype.initialize = function() {
    Application.__super__.initialize.apply(this, arguments);
    return this.setAttribute('loading', true);
  };

  Application.prototype.navigate = function(e) {
    if (e.page === 'add') {
      this.resetAdd();
    }
    return this.pager.change(e.page);
  };

  return Application;

})(Component);


/***  source/shoppy  ***/

window.REF = new Firebase("https://spendi.firebaseio.com/");

window.CATEGORIES = {
  food: 'icon-food',
  drink: 'icon-glass',
  gift: 'icon-gift',
  electronics: 'icon-desktop',
  games: 'icon-gamepad',
  storage: 'icon-archive',
  favorite: 'icon-heart'
};

UI.beforeload = function() {
  window.app = Application.promise()();
  return document.body.appendChild(app);
};

UI.onload = function() {
  return REF.once('value', function() {
    return app.init();
  });
};
