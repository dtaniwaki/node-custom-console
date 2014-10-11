var CustomConsole, assert, debugLevels,
  __slice = [].slice;

assert = require('assert');

debugLevels = {
  log: 1,
  info: 2,
  warn: 3,
  error: 4
};

CustomConsole = (function() {
  var delegate, name, template, _i, _j, _len, _len1, _ref, _ref1;

  function CustomConsole(tag, options) {
    assert(tag, 'tag is required');
    this.console = options.console || require('console');
    this.tag = tag;
  }

  CustomConsole.prototype.output = function(severity, tag) {
    var debug, level;
    debug = process.env.NODE_DEBUG;
    if (!tag || (debug && (debug === '*' || (new RegExp("\\b" + tag + "\\b")).test(debug)))) {
      level = process.env.NODE_DEBUG_LEVEL;
      return !level || debugLevels[severity] >= debugLevels[level.toLowerCase()];
    }
    return false;
  };

  CustomConsole.prototype.prefix = function(severity, tag) {
    var time;
    time = (new Date()).toISOString();
    return "" + time + " [" + severity + "] " + process.pid + " " + tag + ":";
  };

  CustomConsole.prototype.postfix = function(severity, tag) {
    return '';
  };

  template = function(name) {
    return function() {
      var args, postfix, prefix, _args, _ref;
      args = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
      _args = [];
      prefix = this.prefix(name, this.tag);
      if (prefix) {
        _args.push(prefix);
      }
      _args = _args.concat(args);
      postfix = this.postfix(name, this.tag);
      if (postfix) {
        _args.push(postfix);
      }
      if (this.output(name, this.tag)) {
        return (_ref = this.console)[name].apply(_ref, _args);
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