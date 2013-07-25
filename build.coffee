fs = require 'fs'
{exec} = require 'child_process'

exec "rm -rf release"
exec "mkdir release"
exec "mkdir release/assets"
exec "cp -r static/* release"
UglifyJS = require("uglify-js");

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
environment.appendPath('mui/core')
environment.appendPath('mui/components')
environment.appendPath('mui/polyfills')
environment.appendPath('mui/themes/default')

environment.findAsset('shoppy.js').compile (err, asset) ->
  fs.writeFileSync('release/assets/shoppy.js', UglifyJS.minify(asset.toString(), {fromString: true}).code, 'utf-8')
  environment.findAsset('shoppy.css').compile (err, asset) ->
    fs.writeFileSync('release/assets/shoppy.css', asset.toString(), 'utf-8')
