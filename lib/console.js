var CustomConsole, assert,
  __slice = [].slice;

assert = require('assert');

CustomConsole = (function() {
  var delegate, name, template, _i, _j, _len, _len1, _ref, _ref1;

  CustomConsole.getDebugLevel = function(s) {
    if (!s) {
      return 0;
    }
    switch (s.toLowerCase()) {
      case 'log':
        return 1;
      case 'info':
        return 2;
      case 'warn':
        return 3;
      case 'error':
        return 4;
      default:
        return 0;
    }
  };

  function CustomConsole(tag, options) {
    assert(tag, 'tag is required');
    this.console = options.console || require('console');
    this.tag = tag;
    this.init();
  }

  CustomConsole.prototype.init = function() {
    var debug, match;
    debug = process.env.NODE_DEBUG || '';
    match = debug.match(new RegExp("\\*(\\:(.+))?|\\b" + this.tag + "(\\:(.+))?\\b"));
    this.enabled = !!match;
    match || (match = []);
    return this.level = CustomConsole.getDebugLevel(match[2] || match[4]);
  };

  CustomConsole.prototype.prefix = function(tag, severity) {
    var time;
    time = (new Date()).toISOString();
    return "" + time + " [" + severity + "] " + process.pid + " " + tag + ":";
  };

  CustomConsole.prototype.postfix = function(tag, severity) {
    return '';
  };

  template = function(severity) {
    return function() {
      var args, postfix, prefix, _args, _ref;
      args = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
      _args = [];
      prefix = this.prefix(this.tag, severity);
      if (prefix) {
        _args.push(prefix);
      }
      _args = _args.concat(args);
      postfix = this.postfix(this.tag, severity);
      if (postfix) {
        _args.push(postfix);
      }
      if (this.enabled && CustomConsole.getDebugLevel(severity) >= this.level) {
        return (_ref = this.console)[severity].apply(_ref, _args);
      }
    };
  };

  _ref = ['log', 'info', 'warn', 'error'];
  for (_i = 0, _len = _ref.length; _i < _len; _i++) {
    name = _ref[_i];
    CustomConsole.prototype[name] = template(name);
  }

  delegate = function(name) {
    return function() {
      var args, _ref1;
      args = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
      return (_ref1 = this.console)[name].apply(_ref1, args);
    };
  };

  _ref1 = ['trace', 'time', 'timeEnd', 'assert', 'dir'];
  for (_j = 0, _len1 = _ref1.length; _j < _len1; _j++) {
    name = _ref1[_j];
    CustomConsole.prototype[name] = delegate(name);
  }

  return CustomConsole;

})();

module.exports = function(tag, options) {
  return new CustomConsole(tag, options);
};

//# sourceMappingURL=console.js.map