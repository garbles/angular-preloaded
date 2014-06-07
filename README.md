# angular-preloaded

[![Build Status](https://secure.travis-ci.org/garbles/angular-preloaded.png?branch=master)](https://travis-ci.org/garbles/angular-preloaded)

This AngularJS plugin allows you to preload data for your application by
putting it into a special script tag. This is especially great for non-SPAs
that want to use AngularJS.

I am motivated by my previous attempts to preload data where I polluted
the global state (_i.e._ `window`) and wrote services to pluck values off
of it. This approach fully integrates with the AngularJS life cycle.

### Installing

`bower install angular-preloaded`

### Using

You can preload any data that you need by wrapping JSON in a script tag
with `type=text/preloaded`.

```html
<script type="text/preloaded">
  {
    "data": "point"
  }
</script>
<script type="text/preloaded" name="another">
  {
    "point": "of data"
  }
</script>
```

You can now access the preloaded data from anywhere in your application by
injecting `$preloaded`.

```javascript
angular.module('app', ['gs.preloaded'])
.controller('SomeCtrl', function ($preloaded) {
  // do something with $preloaded.
  $preloaded; // => { "data": "point", "another": { "point: "of data" } }
});
```

__NOTE__: Your script tags must run _before_ anything using `$preloaded`, so
I suggest putting them in your document's head.
