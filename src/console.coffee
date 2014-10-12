assert = require 'assert'

class CustomConsole
  @getDebugLevel = (s) ->
    return 0 unless s
    switch s.toLowerCase()
      when 'log' then 1
      when 'info' then 2
      when 'warn' then 3
      when 'error' then 4
      else 0

  constructor: (tag, options) ->
    options = options || {}
    assert tag, 'tag is required'

    @console = options.console || require 'console'
    @tag = tag

    @init()

    @formatter = options.formatter if options.formatter

  init: ->
    debug = process.env.NODE_DEBUG || ''
    match = debug.match new RegExp("\\*(\\:(.+))?|\\b#{@tag}(\\:(.+))?\\b")
    @enabled = !!match
    match ||= []
    @level = CustomConsole.getDebugLevel(match[2] || match[4])

  formatter: (args...) ->
    time = (new Date()).toISOString()
    ["#{time} [#{@severity}] #{process.pid} #{@tag}:"].concat args...

  template = (severity) ->
    (args...) ->
      return unless @enabled && CustomConsole.getDebugLevel(severity) >= @level
      _args = do (@tag, @formatter) ->
        @severity = severity
        @formatter args...
      @console[severity] _args...

  for name in ['log', 'info', 'warn', 'error']
    @::[name] = template(name)
 
  delegate = (name) ->
    (args...) ->
      @console[name] args...

  for name in ['trace', 'time', 'timeEnd', 'assert', 'dir']
    @::[name] = delegate(name)

module.exports = (tag, options) ->
  new CustomConsole(tag, options)
