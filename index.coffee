debug   = require('debug')('thing-that-uses-meshblu-websocket')
Meshblu = require 'meshblu-websocket'
Config  = require 'meshblu-config'
_       = require 'lodash'

class Command
  run: =>
    config = new Config
    meshblu = new Meshblu config.toJSON()
    meshblu.connect =>
      meshblu.subscribe 'bddfead0-6804-48ad-a904-98581ca8639e'

    meshblu.on '*', (data) ->
      return if this.event == 'error'
      console.log this.event, data
      # process.exit  0 unless _.contains ['open', 'ready'], this.event

    meshblu.on 'error', (error) ->
      console.error 'error', error.message
      process.exit 1

command = new Command()
command.run()
