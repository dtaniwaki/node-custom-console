assert = require 'assert'

# auto-commit-test

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
    assert tag, 'tag is required'

    @console = options.console || require 'console'
    @tag = tag

    @init()

    @prefix = options.prefix if options.prefix
    @postfix = options.postfix if options.postfix

  init: ->
    debug = process.env.NODE_DEBUG || ''
    match = debug.match new RegExp("\\*(\\:(.+))?|\\b#{@tag}(\\:(.+))?\\b")
    @enabled = !!match
    match ||= []
    @level = CustomConsole.getDebugLevel(match[2] || match[4])

  prefix: (tag, severity) ->
    time = (new Date()).toISOString()
    "#{time} [#{severity}] #{process.pid} #{tag}:"

  postfix: (tag, severity) ->
    ''

  template = (severity) ->
    (args...) ->
      _args = []

      prefix = @prefix(@tag, severity)
      _args.push prefix if prefix

      _args = _args.concat args

      postfix = @postfix(@tag, severity)
      _args.push postfix if postfix

      @console[severity] _args... if @enabled && CustomConsole.getDebugLevel(severity) >= @level

  for name in ['log', 'info', 'warn', 'error']
    @::[name] = template(name)
 
  delegate = (name) ->
    (args...) ->
      @console[name] args...

  for name in ['trace', 'time', 'timeEnd', 'assert', 'dir']
    @::[name] = delegate(name)

module.exports = (tag, options) ->
  new CustomConsole(tag, options)
