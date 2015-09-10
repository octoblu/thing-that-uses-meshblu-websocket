debug   = require('debug')('thing-that-uses-meshblu-websocket')
Meshblu = require 'meshblu-websocket'
Config  = require 'meshblu-config'
_       = require 'lodash'
Backoff = require 'backo'

class Command
  constructor: ->
    @backoff = new Backoff min: 1000, max: 60 * 60 * 1000

  run: =>
    config = new Config
    options = _.extend {pingInterval: 1000, pingTimeout: 2000}, config.toJSON()

    meshblu = new Meshblu options
    meshblu.connect =>
      meshblu.subscribe 'bddfead0-6804-48ad-a904-98581ca8639e'

    meshblu.on '*', (data) ->
      return if this.event == 'error'
      # console.log "on '#{this.event}': ", data

    meshblu.on 'error', (error) =>
      randomNumber =  Math.random() * 5
      setTimeout meshblu.reconnect, @backoff.duration() * randomNumber

command = new Command()
command.run()
