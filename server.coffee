connect      = require("connect")
Mincer       = require("mincer")
autoprefixer = require('autoprefixer')

class AutoPrefix extends Mincer.Template
  evaluate: (context, locals, callback)->
    callback null, autoprefixer.compile @data

Mincer.registerPostProcessor('text/css', AutoPrefix)

environment = new Mincer.Environment()
environment.appendPath('static')
environment.appendPath('source')
environment.appendPath('stylesheets')

app = connect()
app.use "/", connect.static process.cwd()+"/static"
app.use "/assets", Mincer.createServer(environment)
app.listen(process.env.PORT || 4000)

console.log 'MUI-Shoppy development server running on port 4000...'
