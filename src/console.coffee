assert = require 'assert'

debugLevels =
  log: 1
  info: 2
  warn: 3
  error: 4

class CustomConsole
  constructor: (tag, options) ->
    assert tag, 'tag is required'

    @console = options.console || require 'console'
    @tag = tag

  output: (severity, tag) ->
    debug = process.env.NODE_DEBUG
    if !tag || (debug && (debug == '*' || (new RegExp("\\b#{tag}\\b")).test debug))
      level = process.env.NODE_DEBUG_LEVEL
      return !level || debugLevels[severity] >= debugLevels[level.toLowerCase()]
    false

  prefix: (severity, tag) ->
    time = (new Date()).toISOString()
    "#{time} [#{severity}] #{process.pid} #{tag}:"

  postfix: (severity, tag) ->
    ''

  template = (name) ->
    (args...) ->
      _args = []

      prefix = @prefix(name, @tag)
      _args.push prefix if prefix

      _args = _args.concat args

      postfix = @postfix(name, @tag)
      _args.push postfix if postfix

      @console[name] _args... if @output(name, @tag)

  for name in ['log', 'info', 'warn', 'error']
    @::[name] = template(name)
 
  delegate = (name) ->
    (args...) ->
      @console[name] args...

  for name in ['trace', 'time', 'timeEnd', 'assert', 'dir']
    @::[name] = delegate(name)

module.exports = (tag, options) ->
  new CustomConsole(tag, options)
