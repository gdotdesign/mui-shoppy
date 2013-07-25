fs = require 'fs'
{exec} = require 'child_process'

exec "rm -rf release"
exec "mkdir release"
exec "mkdir release/assets"
exec "cp -r static/* release"

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

environment.findAsset('shoppy.js').compile (err, asset) ->
  code = asset.toString()
  fs.writeFileSync('release/assets/shoppy.js', code, 'utf-8')
  environment.findAsset('shoppy.css').compile (err, asset) ->
    code = asset.toString()
    fs.writeFileSync('release/assets/shoppy.css', code, 'utf-8')
