# node-custom-console

[![NPM version][npm-image]][npm-link]
[![Build Status][build-image]][build-link]
[![Coverage Status][coverage-image]][coverage-link]
[![dependency Status][dep-image]][dep-link]
[![devDependency Status][dev-dep-image]][dev-dep-link]

Custom console for Node.js log.

## Usage

Just replace your console with this module.

```javascript
var console = require('node-custom-console')('module1');
console.log('foo', 'bar')
// > 2014-10-02T06:15:16.830Z [log] 44999 module1: foo bar

var console = require('node-custom-console')('module2');
console.info('foo', 'bar')
// > 2014-10-02T06:15:16.830Z [info] 44999 module2: foo bar
```

### Debug Target

You can specify the debug targets.

```javascript
process.env.NODE_DEBUG='module1'

var console = require('node-custom-console')('module1');
console.log('foo', 'bar')
// > 2014-10-02T06:15:16.830Z [info] 44999 module1: foo bar

var console = require('node-custom-console')('module2');
console.info('foo', 'bar')
// No output
```

You can also set multiple targets with `module1,module2` and all with `*`.

### Debug Level

You can specify the debug levels.

```javascript
process.env.NODE_DEBUG='module1:info'

var console = require('node-custom-console')('module1');
console.log('foo', 'bar')
// No output

console.info('foo', 'bar')
// > 2014-10-02T06:15:16.830Z [info] 44999 module1: foo bar
```

Here is the priority order of available levels.
`log` < `info` < `warn` < `error`

### Custom Formatter

Furthermore, you can use custom formatter as below.

```javascript
var console = require('node-custom-console')('module1', formatter: function() {
  var args = [];
  args.push(this.tag + '-' + this.severity);
  args = args.concat([].slice.call(arguments, 0));
  args.push(';');
  return args;
});
console.info('foo', 'bar')
// > chai-info foo bar ;
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new [Pull Request](../../pull/new/master)

## Copyright

Copyright (c) 2014 Daisuke Taniwaki. See [LICENSE](LICENSE) for details.


[npm-image]: https://badge.fury.io/js/node-custom-console.svg
[npm-link]: http://badge.fury.io/js/node-custom-console
[build-image]: https://secure.travis-ci.org/dtaniwaki/node-custom-console.svg
[build-link]:  http://travis-ci.org/dtaniwaki/node-custom-console
[coverage-image]: https://img.shields.io/coveralls/dtaniwaki/node-custom-console.svg
[coverage-link]: https://coveralls.io/r/dtaniwaki/node-custom-console
[dep-image]: https://david-dm.org/dtaniwaki/node-custom-console/status.svg
[dep-link]: https://david-dm.org/dtaniwaki/node-custom-console#info=dependencies
[dev-dep-image]: https://david-dm.org/dtaniwaki/node-custom-console/dev-status.svg
[dev-dep-link]: https://david-dm.org/dtaniwaki/node-custom-console#info=devDependencies
