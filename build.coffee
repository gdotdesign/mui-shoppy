fs = require 'fs'
exec = require 'exec'

unless fs.existsSync('release')
  console.log 'Creating release directory...'
  fs.mkdirSync('release')
console.log 'Compiling source...'
environment.findAsset('mui.js').compile (err, asset) ->
  code = asset.toString()
  fs.writeFileSync('release/mui.js', code, 'utf-8')
  console.log 'Compiling default theme...'
  environment.findAsset('default/theme.css').compile (err, asset) ->
    code = asset.toString()
    fs.writeFileSync('release/theme.css', code, 'utf-8')
    console.log 'Done'
