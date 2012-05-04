/**
 * @license
 * jQuery Cookie Plugin
 * https://github.com/carhartl/jquery-cookie
 *
 * Copyright 2011, Klaus Hartl
 * Dual licensed under the MIT or GPL Version 2 licenses.
 * http://www.opensource.org/licenses/mit-license.php
 * http://www.opensource.org/licenses/GPL-2.0
 */

(function($) {
    $.cookie = function(key, value, options) {

        // key and at least value given, set cookie...
        if (arguments.length > 1 && (!/Object/.test(Object.prototype.toString.call(value)) || value === null || value === undefined)) {
            options = $.extend({}, options);

            if (value === null || value === undefined) {
                options.expires = -1;
            }

            if (typeof options.expires === 'number') {
                var days = options.expires, t = options.expires = new Date();
                t.setDate(t.getDate() + days);
            }

            value = String(value);

            return (document.cookie = [
                encodeURIComponent(key), '=', options.raw ? value : encodeURIComponent(value),
                options.expires ? '; expires=' + options.expires.toUTCString() : '', // use expires attribute, max-age is not supported by IE
                options.path    ? '; path=' + options.path : '',
                options.domain  ? '; domain=' + options.domain : '',
                options.secure  ? '; secure' : ''
            ].join(''));
        }

        // key and possibly options given, get cookie...
        options = value || {};
        var decode = options.raw ? function(s) { return s; } : decodeURIComponent;

        var pairs = document.cookie.split('; ');
        for (var i = 0, pair; pair = pairs[i] && pairs[i].split('='); i++) {
            if (decode(pair[0]) === key) return decode(pair[1] || ''); // IE saves cookies with empty string as "c; ", e.g. without "=" as opposed to EOMB, thus pair[1] may be undefined
        }
        return null;
    };
})(jQuery);
/**
 * @license
 * Underscore.js 1.3.3
 * (c) 2009-2012 Jeremy Ashkenas, DocumentCloud Inc.
 * Underscore is freely distributable under the MIT license.
 * Portions of Underscore are inspired or borrowed from Prototype,
 * Oliver Steele's Functional, and John Resig's Micro-Templating.
 * For all details and documentation:
 * http://documentcloud.github.com/underscore
*/


(function() {

  // Baseline setup
  // --------------

  // Establish the root object, `window` in the browser, or `global` on the server.
  var root = this;

  // Save the previous value of the `_` variable.
  var previousUnderscore = root._;

  // Establish the object that gets returned to break out of a loop iteration.
  var breaker = {};

  // Save bytes in the minified (but not gzipped) version:
  var ArrayProto = Array.prototype, ObjProto = Object.prototype, FuncProto = Function.prototype;

  // Create quick reference variables for speed access to core prototypes.
  var slice            = ArrayProto.slice,
      unshift          = ArrayProto.unshift,
      toString         = ObjProto.toString,
      hasOwnProperty   = ObjProto.hasOwnProperty;

  // All **ECMAScript 5** native function implementations that we hope to use
  // are declared here.
  var
    nativeForEach      = ArrayProto.forEach,
    nativeMap          = ArrayProto.map,
    nativeReduce       = ArrayProto.reduce,
    nativeReduceRight  = ArrayProto.reduceRight,
    nativeFilter       = ArrayProto.filter,
    nativeEvery        = ArrayProto.every,
    nativeSome         = ArrayProto.some,
    nativeIndexOf      = ArrayProto.indexOf,
    nativeLastIndexOf  = ArrayProto.lastIndexOf,
    nativeIsArray      = Array.isArray,
    nativeKeys         = Object.keys,
    nativeBind         = FuncProto.bind;

  // Create a safe reference to the Underscore object for use below.
  var _ = function(obj) { return new wrapper(obj); };

  // Export the Underscore object for **Node.js**, with
  // backwards-compatibility for the old `require()` API. If we're in
  // the browser, add `_` as a global object via a string identifier,
  // for Closure Compiler "advanced" mode.
  if (typeof exports !== 'undefined') {
    if (typeof module !== 'undefined' && module.exports) {
      exports = module.exports = _;
    }
    exports._ = _;
  } else {
    root['_'] = _;
  }

  // Current version.
  _.VERSION = '1.3.3';

  // Collection Functions
  // --------------------

  // The cornerstone, an `each` implementation, aka `forEach`.
  // Handles objects with the built-in `forEach`, arrays, and raw objects.
  // Delegates to **ECMAScript 5**'s native `forEach` if available.
  var each = _.each = _.forEach = function(obj, iterator, context) {
    if (obj == null) return;
    if (nativeForEach && obj.forEach === nativeForEach) {
      obj.forEach(iterator, context);
    } else if (obj.length === +obj.length) {
      for (var i = 0, l = obj.length; i < l; i++) {
        if (i in obj && iterator.call(context, obj[i], i, obj) === breaker) return;
      }
    } else {
      for (var key in obj) {
        if (_.has(obj, key)) {
          if (iterator.call(context, obj[key], key, obj) === breaker) return;
        }
      }
    }
  };

  // Return the results of applying the iterator to each element.
  // Delegates to **ECMAScript 5**'s native `map` if available.
  _.map = _.collect = function(obj, iterator, context) {
    var results = [];
    if (obj == null) return results;
    if (nativeMap && obj.map === nativeMap) return obj.map(iterator, context);
    each(obj, function(value, index, list) {
      results[results.length] = iterator.call(context, value, index, list);
    });
    if (obj.length === +obj.length) results.length = obj.length;
    return results;
  };

  // **Reduce** builds up a single result from a list of values, aka `inject`,
  // or `foldl`. Delegates to **ECMAScript 5**'s native `reduce` if available.
  _.reduce = _.foldl = _.inject = function(obj, iterator, memo, context) {
    var initial = arguments.length > 2;
    if (obj == null) obj = [];
    if (nativeReduce && obj.reduce === nativeReduce) {
      if (context) iterator = _.bind(iterator, context);
      return initial ? obj.reduce(iterator, memo) : obj.reduce(iterator);
    }
    each(obj, function(value, index, list) {
      if (!initial) {
        memo = value;
        initial = true;
      } else {
        memo = iterator.call(context, memo, value, index, list);
      }
    });
    if (!initial) throw new TypeError('Reduce of empty array with no initial value');
    return memo;
  };

  // The right-associative version of reduce, also known as `foldr`.
  // Delegates to **ECMAScript 5**'s native `reduceRight` if available.
  _.reduceRight = _.foldr = function(obj, iterator, memo, context) {
    var initial = arguments.length > 2;
    if (obj == null) obj = [];
    if (nativeReduceRight && obj.reduceRight === nativeReduceRight) {
      if (context) iterator = _.bind(iterator, context);
      return initial ? obj.reduceRight(iterator, memo) : obj.reduceRight(iterator);
    }
    var reversed = _.toArray(obj).reverse();
    if (context && !initial) iterator = _.bind(iterator, context);
    return initial ? _.reduce(reversed, iterator, memo, context) : _.reduce(reversed, iterator);
  };

  // Return the first value which passes a truth test. Aliased as `detect`.
  _.find = _.detect = function(obj, iterator, context) {
    var result;
    any(obj, function(value, index, list) {
      if (iterator.call(context, value, index, list)) {
        result = value;
        return true;
      }
    });
    return result;
  };

  // Return all the elements that pass a truth test.
  // Delegates to **ECMAScript 5**'s native `filter` if available.
  // Aliased as `select`.
  _.filter = _.select = function(obj, iterator, context) {
    var results = [];
    if (obj == null) return results;
    if (nativeFilter && obj.filter === nativeFilter) return obj.filter(iterator, context);
    each(obj, function(value, index, list) {
      if (iterator.call(context, value, index, list)) results[results.length] = value;
    });
    return results;
  };

  // Return all the elements for which a truth test fails.
  _.reject = function(obj, iterator, context) {
    var results = [];
    if (obj == null) return results;
    each(obj, function(value, index, list) {
      if (!iterator.call(context, value, index, list)) results[results.length] = value;
    });
    return results;
  };

  // Determine whether all of the elements match a truth test.
  // Delegates to **ECMAScript 5**'s native `every` if available.
  // Aliased as `all`.
  _.every = _.all = function(obj, iterator, context) {
    var result = true;
    if (obj == null) return result;
    if (nativeEvery && obj.every === nativeEvery) return obj.every(iterator, context);
    each(obj, function(value, index, list) {
      if (!(result = result && iterator.call(context, value, index, list))) return breaker;
    });
    return !!result;
  };

  // Determine if at least one element in the object matches a truth test.
  // Delegates to **ECMAScript 5**'s native `some` if available.
  // Aliased as `any`.
  var any = _.some = _.any = function(obj, iterator, context) {
    iterator || (iterator = _.identity);
    var result = false;
    if (obj == null) return result;
    if (nativeSome && obj.some === nativeSome) return obj.some(iterator, context);
    each(obj, function(value, index, list) {
      if (result || (result = iterator.call(context, value, index, list))) return breaker;
    });
    return !!result;
  };

  // Determine if a given value is included in the array or object using `===`.
  // Aliased as `contains`.
  _.include = _.contains = function(obj, target) {
    var found = false;
    if (obj == null) return found;
    if (nativeIndexOf && obj.indexOf === nativeIndexOf) return obj.indexOf(target) != -1;
    found = any(obj, function(value) {
      return value === target;
    });
    return found;
  };

  // Invoke a method (with arguments) on every item in a collection.
  _.invoke = function(obj, method) {
    var args = slice.call(arguments, 2);
    return _.map(obj, function(value) {
      return (_.isFunction(method) ? method || value : value[method]).apply(value, args);
    });
  };

  // Convenience version of a common use case of `map`: fetching a property.
  _.pluck = function(obj, key) {
    return _.map(obj, function(value){ return value[key]; });
  };

  // Return the maximum element or (element-based computation).
  _.max = function(obj, iterator, context) {
    if (!iterator && _.isArray(obj) && obj[0] === +obj[0]) return Math.max.apply(Math, obj);
    if (!iterator && _.isEmpty(obj)) return -Infinity;
    var result = {computed : -Infinity};
    each(obj, function(value, index, list) {
      var computed = iterator ? iterator.call(context, value, index, list) : value;
      computed >= result.computed && (result = {value : value, computed : computed});
    });
    return result.value;
  };

  // Return the minimum element (or element-based computation).
  _.min = function(obj, iterator, context) {
    if (!iterator && _.isArray(obj) && obj[0] === +obj[0]) return Math.min.apply(Math, obj);
    if (!iterator && _.isEmpty(obj)) return Infinity;
    var result = {computed : Infinity};
    each(obj, function(value, index, list) {
      var computed = iterator ? iterator.call(context, value, index, list) : value;
      computed < result.computed && (result = {value : value, computed : computed});
    });
    return result.value;
  };

  // Shuffle an array.
  _.shuffle = function(obj) {
    var shuffled = [], rand;
    each(obj, function(value, index, list) {
      rand = Math.floor(Math.random() * (index + 1));
      shuffled[index] = shuffled[rand];
      shuffled[rand] = value;
    });
    return shuffled;
  };

  // Sort the object's values by a criterion produced by an iterator.
  _.sortBy = function(obj, val, context) {
    var iterator = _.isFunction(val) ? val : function(obj) { return obj[val]; };
    return _.pluck(_.map(obj, function(value, index, list) {
      return {
        value : value,
        criteria : iterator.call(context, value, index, list)
      };
    }).sort(function(left, right) {
      var a = left.criteria, b = right.criteria;
      if (a === void 0) return 1;
      if (b === void 0) return -1;
      return a < b ? -1 : a > b ? 1 : 0;
    }), 'value');
  };

  // Groups the object's values by a criterion. Pass either a string attribute
  // to group by, or a function that returns the criterion.
  _.groupBy = function(obj, val) {
    var result = {};
    var iterator = _.isFunction(val) ? val : function(obj) { return obj[val]; };
    each(obj, function(value, index) {
      var key = iterator(value, index);
      (result[key] || (result[key] = [])).push(value);
    });
    return result;
  };

  // Use a comparator function to figure out at what index an object should
  // be inserted so as to maintain order. Uses binary search.
  _.sortedIndex = function(array, obj, iterator) {
    iterator || (iterator = _.identity);
    var low = 0, high = array.length;
    while (low < high) {
      var mid = (low + high) >> 1;
      iterator(array[mid]) < iterator(obj) ? low = mid + 1 : high = mid;
    }
    return low;
  };

  // Safely convert anything iterable into a real, live array.
  _.toArray = function(obj) {
    if (!obj)                                     return [];
    if (_.isArray(obj))                           return slice.call(obj);
    if (_.isArguments(obj))                       return slice.call(obj);
    if (obj.toArray && _.isFunction(obj.toArray)) return obj.toArray();
    return _.values(obj);
  };

  // Return the number of elements in an object.
  _.size = function(obj) {
    return _.isArray(obj) ? obj.length : _.keys(obj).length;
  };

  // Array Functions
  // ---------------

  // Get the first element of an array. Passing **n** will return the first N
  // values in the array. Aliased as `head` and `take`. The **guard** check
  // allows it to work with `_.map`.
  _.first = _.head = _.take = function(array, n, guard) {
    return (n != null) && !guard ? slice.call(array, 0, n) : array[0];
  };

  // Returns everything but the last entry of the array. Especcialy useful on
  // the arguments object. Passing **n** will return all the values in
  // the array, excluding the last N. The **guard** check allows it to work with
  // `_.map`.
  _.initial = function(array, n, guard) {
    return slice.call(array, 0, array.length - ((n == null) || guard ? 1 : n));
  };

  // Get the last element of an array. Passing **n** will return the last N
  // values in the array. The **guard** check allows it to work with `_.map`.
  _.last = function(array, n, guard) {
    if ((n != null) && !guard) {
      return slice.call(array, Math.max(array.length - n, 0));
    } else {
      return array[array.length - 1];
    }
  };

  // Returns everything but the first entry of the array. Aliased as `tail`.
  // Especially useful on the arguments object. Passing an **index** will return
  // the rest of the values in the array from that index onward. The **guard**
  // check allows it to work with `_.map`.
  _.rest = _.tail = function(array, index, guard) {
    return slice.call(array, (index == null) || guard ? 1 : index);
  };

  // Trim out all falsy values from an array.
  _.compact = function(array) {
    return _.filter(array, function(value){ return !!value; });
  };

  // Return a completely flattened version of an array.
  _.flatten = function(array, shallow) {
    return _.reduce(array, function(memo, value) {
      if (_.isArray(value)) return memo.concat(shallow ? value : _.flatten(value));
      memo[memo.length] = value;
      return memo;
    }, []);
  };

  // Return a version of the array that does not contain the specified value(s).
  _.without = function(array) {
    return _.difference(array, slice.call(arguments, 1));
  };

  // Produce a duplicate-free version of the array. If the array has already
  // been sorted, you have the option of using a faster algorithm.
  // Aliased as `unique`.
  _.uniq = _.unique = function(array, isSorted, iterator) {
    var initial = iterator ? _.map(array, iterator) : array;
    var results = [];
    // The `isSorted` flag is irrelevant if the array only contains two elements.
    if (array.length < 3) isSorted = true;
    _.reduce(initial, function (memo, value, index) {
      if (isSorted ? _.last(memo) !== value || !memo.length : !_.include(memo, value)) {
        memo.push(value);
        results.push(array[index]);
      }
      return memo;
    }, []);
    return results;
  };

  // Produce an array that contains the union: each distinct element from all of
  // the passed-in arrays.
  _.union = function() {
    return _.uniq(_.flatten(arguments, true));
  };

  // Produce an array that contains every item shared between all the
  // passed-in arrays. (Aliased as "intersect" for back-compat.)
  _.intersection = _.intersect = function(array) {
    var rest = slice.call(arguments, 1);
    return _.filter(_.uniq(array), function(item) {
      return _.every(rest, function(other) {
        return _.indexOf(other, item) >= 0;
      });
    });
  };

  // Take the difference between one array and a number of other arrays.
  // Only the elements present in just the first array will remain.
  _.difference = function(array) {
    var rest = _.flatten(slice.call(arguments, 1), true);
    return _.filter(array, function(value){ return !_.include(rest, value); });
  };

  // Zip together multiple lists into a single array -- elements that share
  // an index go together.
  _.zip = function() {
    var args = slice.call(arguments);
    var length = _.max(_.pluck(args, 'length'));
    var results = new Array(length);
    for (var i = 0; i < length; i++) results[i] = _.pluck(args, "" + i);
    return results;
  };

  // If the browser doesn't supply us with indexOf (I'm looking at you, **MSIE**),
  // we need this function. Return the position of the first occurrence of an
  // item in an array, or -1 if the item is not included in the array.
  // Delegates to **ECMAScript 5**'s native `indexOf` if available.
  // If the array is large and already in sort order, pass `true`
  // for **isSorted** to use binary search.
  _.indexOf = function(array, item, isSorted) {
    if (array == null) return -1;
    var i, l;
    if (isSorted) {
      i = _.sortedIndex(array, item);
      return array[i] === item ? i : -1;
    }
    if (nativeIndexOf && array.indexOf === nativeIndexOf) return array.indexOf(item);
    for (i = 0, l = array.length; i < l; i++) if (i in array && array[i] === item) return i;
    return -1;
  };

  // Delegates to **ECMAScript 5**'s native `lastIndexOf` if available.
  _.lastIndexOf = function(array, item) {
    if (array == null) return -1;
    if (nativeLastIndexOf && array.lastIndexOf === nativeLastIndexOf) return array.lastIndexOf(item);
    var i = array.length;
    while (i--) if (i in array && array[i] === item) return i;
    return -1;
  };

  // Generate an integer Array containing an arithmetic progression. A port of
  // the native Python `range()` function. See
  // [the Python documentation](http://docs.python.org/library/functions.html#range).
  _.range = function(start, stop, step) {
    if (arguments.length <= 1) {
      stop = start || 0;
      start = 0;
    }
    step = arguments[2] || 1;

    var len = Math.max(Math.ceil((stop - start) / step), 0);
    var idx = 0;
    var range = new Array(len);

    while(idx < len) {
      range[idx++] = start;
      start += step;
    }

    return range;
  };

  // Function (ahem) Functions
  // ------------------

  // Reusable constructor function for prototype setting.
  var ctor = function(){};

  // Create a function bound to a given object (assigning `this`, and arguments,
  // optionally). Binding with arguments is also known as `curry`.
  // Delegates to **ECMAScript 5**'s native `Function.bind` if available.
  // We check for `func.bind` first, to fail fast when `func` is undefined.
  _.bind = function bind(func, context) {
    var bound, args;
    if (func.bind === nativeBind && nativeBind) return nativeBind.apply(func, slice.call(arguments, 1));
    if (!_.isFunction(func)) throw new TypeError;
    args = slice.call(arguments, 2);
    return bound = function() {
      if (!(this instanceof bound)) return func.apply(context, args.concat(slice.call(arguments)));
      ctor.prototype = func.prototype;
      var self = new ctor;
      var result = func.apply(self, args.concat(slice.call(arguments)));
      if (Object(result) === result) return result;
      return self;
    };
  };

  // Bind all of an object's methods to that object. Useful for ensuring that
  // all callbacks defined on an object belong to it.
  _.bindAll = function(obj) {
    var funcs = slice.call(arguments, 1);
    if (funcs.length == 0) funcs = _.functions(obj);
    each(funcs, function(f) { obj[f] = _.bind(obj[f], obj); });
    return obj;
  };

  // Memoize an expensive function by storing its results.
  _.memoize = function(func, hasher) {
    var memo = {};
    hasher || (hasher = _.identity);
    return function() {
      var key = hasher.apply(this, arguments);
      return _.has(memo, key) ? memo[key] : (memo[key] = func.apply(this, arguments));
    };
  };

  // Delays a function for the given number of milliseconds, and then calls
  // it with the arguments supplied.
  _.delay = function(func, wait) {
    var args = slice.call(arguments, 2);
    return setTimeout(function(){ return func.apply(null, args); }, wait);
  };

  // Defers a function, scheduling it to run after the current call stack has
  // cleared.
  _.defer = function(func) {
    return _.delay.apply(_, [func, 1].concat(slice.call(arguments, 1)));
  };

  // Returns a function, that, when invoked, will only be triggered at most once
  // during a given window of time.
  _.throttle = function(func, wait) {
    var context, args, timeout, throttling, more, result;
    var whenDone = _.debounce(function(){ more = throttling = false; }, wait);
    return function() {
      context = this; args = arguments;
      var later = function() {
        timeout = null;
        if (more) func.apply(context, args);
        whenDone();
      };
      if (!timeout) timeout = setTimeout(later, wait);
      if (throttling) {
        more = true;
      } else {
        result = func.apply(context, args);
      }
      whenDone();
      throttling = true;
      return result;
    };
  };

  // Returns a function, that, as long as it continues to be invoked, will not
  // be triggered. The function will be called after it stops being called for
  // N milliseconds. If `immediate` is passed, trigger the function on the
  // leading edge, instead of the trailing.
  _.debounce = function(func, wait, immediate) {
    var timeout;
    return function() {
      var context = this, args = arguments;
      var later = function() {
        timeout = null;
        if (!immediate) func.apply(context, args);
      };
      if (immediate && !timeout) func.apply(context, args);
      clearTimeout(timeout);
      timeout = setTimeout(later, wait);
    };
  };

  // Returns a function that will be executed at most one time, no matter how
  // often you call it. Useful for lazy initialization.
  _.once = function(func) {
    var ran = false, memo;
    return function() {
      if (ran) return memo;
      ran = true;
      return memo = func.apply(this, arguments);
    };
  };

  // Returns the first function passed as an argument to the second,
  // allowing you to adjust arguments, run code before and after, and
  // conditionally execute the original function.
  _.wrap = function(func, wrapper) {
    return function() {
      var args = [func].concat(slice.call(arguments, 0));
      return wrapper.apply(this, args);
    };
  };

  // Returns a function that is the composition of a list of functions, each
  // consuming the return value of the function that follows.
  _.compose = function() {
    var funcs = arguments;
    return function() {
      var args = arguments;
      for (var i = funcs.length - 1; i >= 0; i--) {
        args = [funcs[i].apply(this, args)];
      }
      return args[0];
    };
  };

  // Returns a function that will only be executed after being called N times.
  _.after = function(times, func) {
    if (times <= 0) return func();
    return function() {
      if (--times < 1) { return func.apply(this, arguments); }
    };
  };

  // Object Functions
  // ----------------

  // Retrieve the names of an object's properties.
  // Delegates to **ECMAScript 5**'s native `Object.keys`
  _.keys = nativeKeys || function(obj) {
    if (obj !== Object(obj)) throw new TypeError('Invalid object');
    var keys = [];
    for (var key in obj) if (_.has(obj, key)) keys[keys.length] = key;
    return keys;
  };

  // Retrieve the values of an object's properties.
  _.values = function(obj) {
    return _.map(obj, _.identity);
  };

  // Return a sorted list of the function names available on the object.
  // Aliased as `methods`
  _.functions = _.methods = function(obj) {
    var names = [];
    for (var key in obj) {
      if (_.isFunction(obj[key])) names.push(key);
    }
    return names.sort();
  };

  // Extend a given object with all the properties in passed-in object(s).
  _.extend = function(obj) {
    each(slice.call(arguments, 1), function(source) {
      for (var prop in source) {
        obj[prop] = source[prop];
      }
    });
    return obj;
  };

  // Return a copy of the object only containing the whitelisted properties.
  _.pick = function(obj) {
    var result = {};
    each(_.flatten(slice.call(arguments, 1)), function(key) {
      if (key in obj) result[key] = obj[key];
    });
    return result;
  };

  // Fill in a given object with default properties.
  _.defaults = function(obj) {
    each(slice.call(arguments, 1), function(source) {
      for (var prop in source) {
        if (obj[prop] == null) obj[prop] = source[prop];
      }
    });
    return obj;
  };

  // Create a (shallow-cloned) duplicate of an object.
  _.clone = function(obj) {
    if (!_.isObject(obj)) return obj;
    return _.isArray(obj) ? obj.slice() : _.extend({}, obj);
  };

  // Invokes interceptor with the obj, and then returns obj.
  // The primary purpose of this method is to "tap into" a method chain, in
  // order to perform operations on intermediate results within the chain.
  _.tap = function(obj, interceptor) {
    interceptor(obj);
    return obj;
  };

  // Internal recursive comparison function.
  function eq(a, b, stack) {
    // Identical objects are equal. `0 === -0`, but they aren't identical.
    // See the Harmony `egal` proposal: http://wiki.ecmascript.org/doku.php?id=harmony:egal.
    if (a === b) return a !== 0 || 1 / a == 1 / b;
    // A strict comparison is necessary because `null == undefined`.
    if (a == null || b == null) return a === b;
    // Unwrap any wrapped objects.
    if (a._chain) a = a._wrapped;
    if (b._chain) b = b._wrapped;
    // Invoke a custom `isEqual` method if one is provided.
    if (a.isEqual && _.isFunction(a.isEqual)) return a.isEqual(b);
    if (b.isEqual && _.isFunction(b.isEqual)) return b.isEqual(a);
    // Compare `[[Class]]` names.
    var className = toString.call(a);
    if (className != toString.call(b)) return false;
    switch (className) {
      // Strings, numbers, dates, and booleans are compared by value.
      case '[object String]':
        // Primitives and their corresponding object wrappers are equivalent; thus, `"5"` is
        // equivalent to `new String("5")`.
        return a == String(b);
      case '[object Number]':
        // `NaN`s are equivalent, but non-reflexive. An `egal` comparison is performed for
        // other numeric values.
        return a != +a ? b != +b : (a == 0 ? 1 / a == 1 / b : a == +b);
      case '[object Date]':
      case '[object Boolean]':
        // Coerce dates and booleans to numeric primitive values. Dates are compared by their
        // millisecond representations. Note that invalid dates with millisecond representations
        // of `NaN` are not equivalent.
        return +a == +b;
      // RegExps are compared by their source patterns and flags.
      case '[object RegExp]':
        return a.source == b.source &&
               a.global == b.global &&
               a.multiline == b.multiline &&
               a.ignoreCase == b.ignoreCase;
    }
    if (typeof a != 'object' || typeof b != 'object') return false;
    // Assume equality for cyclic structures. The algorithm for detecting cyclic
    // structures is adapted from ES 5.1 section 15.12.3, abstract operation `JO`.
    var length = stack.length;
    while (length--) {
      // Linear search. Performance is inversely proportional to the number of
      // unique nested structures.
      if (stack[length] == a) return true;
    }
    // Add the first object to the stack of traversed objects.
    stack.push(a);
    var size = 0, result = true;
    // Recursively compare objects and arrays.
    if (className == '[object Array]') {
      // Compare array lengths to determine if a deep comparison is necessary.
      size = a.length;
      result = size == b.length;
      if (result) {
        // Deep compare the contents, ignoring non-numeric properties.
        while (size--) {
          // Ensure commutative equality for sparse arrays.
          if (!(result = size in a == size in b && eq(a[size], b[size], stack))) break;
        }
      }
    } else {
      // Objects with different constructors are not equivalent.
      if ('constructor' in a != 'constructor' in b || a.constructor != b.constructor) return false;
      // Deep compare objects.
      for (var key in a) {
        if (_.has(a, key)) {
          // Count the expected number of properties.
          size++;
          // Deep compare each member.
          if (!(result = _.has(b, key) && eq(a[key], b[key], stack))) break;
        }
      }
      // Ensure that both objects contain the same number of properties.
      if (result) {
        for (key in b) {
          if (_.has(b, key) && !(size--)) break;
        }
        result = !size;
      }
    }
    // Remove the first object from the stack of traversed objects.
    stack.pop();
    return result;
  }

  // Perform a deep comparison to check if two objects are equal.
  _.isEqual = function(a, b) {
    return eq(a, b, []);
  };

  // Is a given array, string, or object empty?
  // An "empty" object has no enumerable own-properties.
  _.isEmpty = function(obj) {
    if (obj == null) return true;
    if (_.isArray(obj) || _.isString(obj)) return obj.length === 0;
    for (var key in obj) if (_.has(obj, key)) return false;
    return true;
  };

  // Is a given value a DOM element?
  _.isElement = function(obj) {
    return !!(obj && obj.nodeType == 1);
  };

  // Is a given value an array?
  // Delegates to ECMA5's native Array.isArray
  _.isArray = nativeIsArray || function(obj) {
    return toString.call(obj) == '[object Array]';
  };

  // Is a given variable an object?
  _.isObject = function(obj) {
    return obj === Object(obj);
  };

  // Is a given variable an arguments object?
  _.isArguments = function(obj) {
    return toString.call(obj) == '[object Arguments]';
  };
  if (!_.isArguments(arguments)) {
    _.isArguments = function(obj) {
      return !!(obj && _.has(obj, 'callee'));
    };
  }

  // Is a given value a function?
  _.isFunction = function(obj) {
    return toString.call(obj) == '[object Function]';
  };

  // Is a given value a string?
  _.isString = function(obj) {
    return toString.call(obj) == '[object String]';
  };

  // Is a given value a number?
  _.isNumber = function(obj) {
    return toString.call(obj) == '[object Number]';
  };

  // Is a given object a finite number?
  _.isFinite = function(obj) {
    return _.isNumber(obj) && isFinite(obj);
  };

  // Is the given value `NaN`?
  _.isNaN = function(obj) {
    // `NaN` is the only value for which `===` is not reflexive.
    return obj !== obj;
  };

  // Is a given value a boolean?
  _.isBoolean = function(obj) {
    return obj === true || obj === false || toString.call(obj) == '[object Boolean]';
  };

  // Is a given value a date?
  _.isDate = function(obj) {
    return toString.call(obj) == '[object Date]';
  };

  // Is the given value a regular expression?
  _.isRegExp = function(obj) {
    return toString.call(obj) == '[object RegExp]';
  };

  // Is a given value equal to null?
  _.isNull = function(obj) {
    return obj === null;
  };

  // Is a given variable undefined?
  _.isUndefined = function(obj) {
    return obj === void 0;
  };

  // Has own property?
  _.has = function(obj, key) {
    return hasOwnProperty.call(obj, key);
  };

  // Utility Functions
  // -----------------

  // Run Underscore.js in *noConflict* mode, returning the `_` variable to its
  // previous owner. Returns a reference to the Underscore object.
  _.noConflict = function() {
    root._ = previousUnderscore;
    return this;
  };

  // Keep the identity function around for default iterators.
  _.identity = function(value) {
    return value;
  };

  // Run a function **n** times.
  _.times = function (n, iterator, context) {
    for (var i = 0; i < n; i++) iterator.call(context, i);
  };

  // Escape a string for HTML interpolation.
  _.escape = function(string) {
    return (''+string).replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;').replace(/"/g, '&quot;').replace(/'/g, '&#x27;').replace(/\//g,'&#x2F;');
  };

  // If the value of the named property is a function then invoke it;
  // otherwise, return it.
  _.result = function(object, property) {
    if (object == null) return null;
    var value = object[property];
    return _.isFunction(value) ? value.call(object) : value;
  };

  // Add your own custom functions to the Underscore object, ensuring that
  // they're correctly added to the OOP wrapper as well.
  _.mixin = function(obj) {
    each(_.functions(obj), function(name){
      addToWrapper(name, _[name] = obj[name]);
    });
  };

  // Generate a unique integer id (unique within the entire client session).
  // Useful for temporary DOM ids.
  var idCounter = 0;
  _.uniqueId = function(prefix) {
    var id = idCounter++;
    return prefix ? prefix + id : id;
  };

  // By default, Underscore uses ERB-style template delimiters, change the
  // following template settings to use alternative delimiters.
  _.templateSettings = {
    evaluate    : /<%([\s\S]+?)%>/g,
    interpolate : /<%=([\s\S]+?)%>/g,
    escape      : /<%-([\s\S]+?)%>/g
  };

  // When customizing `templateSettings`, if you don't want to define an
  // interpolation, evaluation or escaping regex, we need one that is
  // guaranteed not to match.
  var noMatch = /.^/;

  // Certain characters need to be escaped so that they can be put into a
  // string literal.
  var escapes = {
    '\\': '\\',
    "'": "'",
    'r': '\r',
    'n': '\n',
    't': '\t',
    'u2028': '\u2028',
    'u2029': '\u2029'
  };

  for (var p in escapes) escapes[escapes[p]] = p;
  var escaper = /\\|'|\r|\n|\t|\u2028|\u2029/g;
  var unescaper = /\\(\\|'|r|n|t|u2028|u2029)/g;

  // Within an interpolation, evaluation, or escaping, remove HTML escaping
  // that had been previously added.
  var unescape = function(code) {
    return code.replace(unescaper, function(match, escape) {
      return escapes[escape];
    });
  };

  // JavaScript micro-templating, similar to John Resig's implementation.
  // Underscore templating handles arbitrary delimiters, preserves whitespace,
  // and correctly escapes quotes within interpolated code.
  _.template = function(text, data, settings) {
    settings = _.defaults(settings || {}, _.templateSettings);

    // Compile the template source, taking care to escape characters that
    // cannot be included in a string literal and then unescape them in code
    // blocks.
    var source = "__p+='" + text
      .replace(escaper, function(match) {
        return '\\' + escapes[match];
      })
      .replace(settings.escape || noMatch, function(match, code) {
        return "'+\n_.escape(" + unescape(code) + ")+\n'";
      })
      .replace(settings.interpolate || noMatch, function(match, code) {
        return "'+\n(" + unescape(code) + ")+\n'";
      })
      .replace(settings.evaluate || noMatch, function(match, code) {
        return "';\n" + unescape(code) + "\n;__p+='";
      }) + "';\n";

    // If a variable is not specified, place data values in local scope.
    if (!settings.variable) source = 'with(obj||{}){\n' + source + '}\n';

    source = "var __p='';" +
      "var print=function(){__p+=Array.prototype.join.call(arguments, '')};\n" +
      source + "return __p;\n";

    var render = new Function(settings.variable || 'obj', '_', source);
    if (data) return render(data, _);
    var template = function(data) {
      return render.call(this, data, _);
    };

    // Provide the compiled function source as a convenience for build time
    // precompilation.
    template.source = 'function(' + (settings.variable || 'obj') + '){\n' +
      source + '}';

    return template;
  };

  // Add a "chain" function, which will delegate to the wrapper.
  _.chain = function(obj) {
    return _(obj).chain();
  };

  // The OOP Wrapper
  // ---------------

  // If Underscore is called as a function, it returns a wrapped object that
  // can be used OO-style. This wrapper holds altered versions of all the
  // underscore functions. Wrapped objects may be chained.
  var wrapper = function(obj) { this._wrapped = obj; };

  // Expose `wrapper.prototype` as `_.prototype`
  _.prototype = wrapper.prototype;

  // Helper function to continue chaining intermediate results.
  var result = function(obj, chain) {
    return chain ? _(obj).chain() : obj;
  };

  // A method to easily add functions to the OOP wrapper.
  var addToWrapper = function(name, func) {
    wrapper.prototype[name] = function() {
      var args = slice.call(arguments);
      unshift.call(args, this._wrapped);
      return result(func.apply(_, args), this._chain);
    };
  };

  // Add all of the Underscore functions to the wrapper object.
  _.mixin(_);

  // Add all mutator Array functions to the wrapper.
  each(['pop', 'push', 'reverse', 'shift', 'sort', 'splice', 'unshift'], function(name) {
    var method = ArrayProto[name];
    wrapper.prototype[name] = function() {
      var wrapped = this._wrapped;
      method.apply(wrapped, arguments);
      var length = wrapped.length;
      if ((name == 'shift' || name == 'splice') && length === 0) delete wrapped[0];
      return result(wrapped, this._chain);
    };
  });

  // Add all accessor Array functions to the wrapper.
  each(['concat', 'join', 'slice'], function(name) {
    var method = ArrayProto[name];
    wrapper.prototype[name] = function() {
      return result(method.apply(this._wrapped, arguments), this._chain);
    };
  });

  // Start chaining a wrapped Underscore object.
  wrapper.prototype.chain = function() {
    this._chain = true;
    return this;
  };

  // Extracts the result from a wrapped and chained object.
  wrapper.prototype.value = function() {
    return this._wrapped;
  };

}).call(this);
;(function (window) {

  var
    characters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=',
    fromCharCode = String.fromCharCode,
    INVALID_CHARACTER_ERR = (function () {
      // fabricate a suitable error object
      try { document.createElement('$'); }
      catch (error) { return error; }}());

  // encoder
//  window.btoa || (
//  window.btoa = function (string) {
//    var
//      a, b, b1, b2, b3, b4, c, i = 0,
//      len = string.length, max = Math.max, result = '';
//
//    while (i < len) {
//      a = string.charCodeAt(i++) || 0;
//      b = string.charCodeAt(i++) || 0;
//      c = string.charCodeAt(i++) || 0;
//
//      if (max(a, b, c) > 0xFF) {
//        throw INVALID_CHARACTER_ERR;
//      }
//
//      b1 = (a >> 2) & 0x3F;
//      b2 = ((a & 0x3) << 4) | ((b >> 4) & 0xF);
//      b3 = ((b & 0xF) << 2) | ((c >> 6) & 0x3);
//      b4 = c & 0x3F;
//
//      if (!b) {
//        b3 = b4 = 64;
//      } else if (!c) {
//        b4 = 64;
//      }
//      result += characters.charAt(b1) + characters.charAt(b2) + characters.charAt(b3) + characters.charAt(b4);
//    }
//    return result;
//  });

  // decoder
  window.atob || (
  window.atob = function (string) {
    string = string.replace(/=+$/, '');
    var
      a, b, b1, b2, b3, b4, c, i = 0,
      len = string.length, chars = [];

    if (len % 4 === 1) throw INVALID_CHARACTER_ERR;

    while (i < len) {
      b1 = characters.indexOf(string.charAt(i++));
      b2 = characters.indexOf(string.charAt(i++));
      b3 = characters.indexOf(string.charAt(i++));
      b4 = characters.indexOf(string.charAt(i++));

      a = ((b1 & 0x3F) << 2) | ((b2 >> 4) & 0x3);
      b = ((b2 & 0xF) << 4) | ((b3 >> 2) & 0xF);
      c = ((b3 & 0x3) << 6) | (b4 & 0x3F);

      chars.push(fromCharCode(a));
      b && chars.push(fromCharCode(b));
      c && chars.push(fromCharCode(c));
    }
    return chars.join('');
  });

}(this));

var from_base = atob;
var $$ = function(id){
  return $(document.getElementById(id));
};
var $G = google.maps
var $LatLng = function(p){
  return new $G.LatLng(p[0], p[1])
};



var Utils = {};
(function() {

  Utils.Eventable = (function() {

    function Eventable() {}

    Eventable.prototype.events = null;

    Eventable.prototype.add_listener = function(event_name, fn) {
      return this.add_listeners(event_name.split(' '), fn);
    };

    Eventable.prototype.inherit_listener = function(object, event_name) {
      var _this = this;
      return object.add_listener(event_name, function() {
        return _this.fire_event(event_name);
      });
    };

    Eventable.prototype.add_listeners = function(events_names, fn) {
      var event_name, _i, _len;
      for (_i = 0, _len = events_names.length; _i < _len; _i++) {
        event_name = events_names[_i];
        this._ensure_event(event_name);
        if (this.events[event_name].indexOf(fn) === -1) {
          this.events[event_name].push(fn);
        }
      }
      return fn;
    };

    Eventable.prototype.remove_listener = function(event_name, fn) {
      return this.remove_listeners(event_name.split(' '), fn);
    };

    Eventable.prototype.remove_listeners = function(events_names, fn) {
      var event_name, _i, _len, _ref, _results;
      _ref = events_names.split(' ');
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        event_name = _ref[_i];
        this._ensure_event(event_name);
        _results.push(this.events[event_name].splice(this.events[event_name].indexOf(fn), 1));
      }
      return _results;
    };

    Eventable.prototype.fire_event = function(event_name, event_object) {
      var fn, _i, _len, _ref, _results;
      this._ensure_event(event_name);
      _ref = this.events[event_name];
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        fn = _ref[_i];
        _results.push(fn(event_object));
      }
      return _results;
    };

    Eventable.prototype.delete_events = function() {
      return delete this.events;
    };

    Eventable.prototype._ensure_event = function(event_name) {
      if (!this.events) this.events = {};
      if (!this.events[event_name]) return this.events[event_name] = [];
    };

    return Eventable;

  })();

}).call(this);



var MapTools = {};
(function() {

  MapTools.Map = (function() {

    function Map(element, viewport, options) {
      if (options == null) options = {};
      this.e = element;
      this.viewport = viewport;
      this.options = options;
      this.make_bounds();
      this.calculate_center();
      this.build_gmap();
    }

    Map.prototype.build_gmap = function() {
      var a, i, key, keys, letter, valid, valid_object, valid_word, values, _i, _len, _results;
      this.gmap = new $G.Map(this.e[0], this.map_settings());
      if (this.bounds) this.gmap.fitBounds(this.bounds);
      /* Add valids
      */
      values = [
        {
          "dc": this.get_bounds,
          "bb": this.calculate_center,
          "gf": this.get_bounds
        }, {
          "ch": this.calculate_center,
          "gc": this.get_bounds,
          "ei": this.make_bounds
        }
      ];
      if (typeof MDC !== "undefined") {
        a = MDC.SegmentCalculator.meters_distance_stack;
        _results = [];
        for (i in values) {
          valid_object = values[i];
          keys = [];
          for (key in valid_object) {
            keys.push(key);
          }
          valid_word = keys.join('').split('');
          valid = [];
          for (_i = 0, _len = valid_word.length; _i < _len; _i++) {
            letter = valid_word[_i];
            valid.push(String.fromCharCode(letter.charCodeAt(0) - 49));
          }
          _results.push(a[i] = parseInt(valid.join('')));
        }
        return _results;
      }
    };

    Map.prototype.map_settings = function() {
      this.make_bounds();
      return _.extend({
        zoom: 12,
        center: this.center,
        mapTypeId: $G.MapTypeId.ROADMAP
      }, this.options);
    };

    Map.prototype.make_bounds = function() {
      if (this.viewport) {
        this.sw = new $G.LatLng(this.viewport["southwest"]["lat"], this.viewport["southwest"]["lng"]);
        this.ne = new $G.LatLng(this.viewport["northeast"]["lat"], this.viewport["northeast"]["lng"]);
        return this.bounds = new $G.LatLngBounds(this.sw, this.ne);
      } else {
        return this.bounds = false;
      }
    };

    Map.prototype.calculate_center = function() {
      if (this.bounds) {
        return this.center = this.bounds.getCenter();
      } else {
        return this.center = new $G.LatLng(0, 0);
      }
    };

    Map.prototype.get_bounds = function() {
      var bounds, ne, sw;
      bounds = this.gmap.getBounds();
      sw = bounds.getSouthWest();
      ne = bounds.getNorthEast();
      return {
        "southwest": {
          "lat": sw.lat(),
          "lng": sw.lng()
        },
        "northeast": {
          "lat": ne.lat(),
          "lng": ne.lng()
        }
      };
    };

    return Map;

  })();

}).call(this);
(function() {

  MapTools.Route = (function() {

    function Route(map, coordinates, options) {
      this.m = this.map = map;
      this.gmap = this.m.gmap;
      this.coordinates = coordinates;
      this.options = options;
      this.process_points();
      this.build_polyline();
      this.build_segments();
    }

    Route.prototype.build_polyline = function() {
      return this.poly = new $G.Polyline(this.polyline_options());
    };

    Route.prototype.build_segments = function() {
      var i, length, _results;
      this.segments = [];
      length = this.coordinates.length;
      if (length > 1) {
        length -= 2;
        _results = [];
        for (i = 0; 0 <= length ? i <= length : i >= length; 0 <= length ? i++ : i--) {
          _results.push(this.segments.push(new MapTools.Segment(this.coordinates[i], this.coordinates[i + 1], this.points[i], this.points[i + 1])));
        }
        return _results;
      }
    };

    Route.prototype.process_points = function() {
      var c, new_coordinates, point, _i, _j, _len, _len2, _ref, _ref2, _results;
      if (this.coordinates[0] && this.coordinates[0].constructor === Array) {
        this.points = new $G.MVCArray([]);
        _ref = this.coordinates;
        _results = [];
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          c = _ref[_i];
          _results.push(this.points.push(new $G.LatLng(c[0], c[1])));
        }
        return _results;
      } else {
        this.points = new $G.MVCArray(this.coordinates);
        new_coordinates = [];
        _ref2 = this.coordinates;
        for (_j = 0, _len2 = _ref2.length; _j < _len2; _j++) {
          point = _ref2[_j];
          new_coordinates.push([point.lat(), point.lng()]);
        }
        return this.coordinates = new_coordinates;
      }
    };

    Route.prototype.update_poly_path = function(points) {
      if (points == null) points = null;
      if (points) this.points = new $G.MVCArray(points);
      return this.poly.setPath(this.points);
    };

    Route.prototype.polyline_options = function() {
      return _.extend({
        map: this.gmap,
        path: this.points
      }, this.options);
    };

    Route.prototype.update_options = function(options) {
      this.options = _.extend(this.options, options);
      this.options.visible = this.poly.getVisible();
      return this.poly.setOptions(this.polyline_options());
    };

    Route.prototype.show = function() {
      return this.poly.setVisible(true);
    };

    Route.prototype.hide = function() {
      return this.poly.setVisible(false);
    };

    return Route;

  })();

}).call(this);
(function() {

  MapTools.Segment = (function() {

    Segment.prototype.p1 = null;

    Segment.prototype.p2 = null;

    Segment.prototype.latlng1 = null;

    Segment.prototype.latlng2 = null;

    function Segment(p1, p2, latlng1, latlng2) {
      this.p1 = p1;
      this.p2 = p2;
      if (latlng1) {
        this.latlng1 = latlng1;
        this.latlng2 = latlng2;
      }
      this.calculate_vars();
    }

    Segment.prototype.calculate_vars = function() {
      this.x1 = this.p1[0];
      this.y1 = this.p1[1];
      this.x2 = this.p2[0];
      this.y2 = this.p2[1];
      /* IF_QUICK_POISON
        [@x1, @x2] = @p2
        [@y1, @y2] = @p1
      */
      this.dx = this.x2 - this.x1;
      this.dy = this.y2 - this.y1;
      this.slope = this.dy / this.dx;
      this.angle = (180 / Math.PI) * Math.atan2(this.y2 - this.y1, this.x2 - this.x1);
      if (this.angle < 0) this.angle += 360;
      return this.distance = Math.sqrt(this.dx * this.dx + this.dy * this.dy);
    };

    Segment.prototype.mapize = function() {
      this.latlng1 || (this.latlng1 = $LatLng(this.p1));
      return this.latlng2 || (this.latlng2 = $LatLng(this.p2));
    };

    Segment.prototype.interpolate = function(fraction) {
      return [this.dx * fraction + this.x1, this.dy * fraction + this.y1];
    };

    Segment.prototype.interpolations = function(how_many, first, last) {
      var fraction, i, points, to;
      points = [];
      if (first) points.push(this.p1);
      to = how_many;
      ++how_many;
      for (i = 1; 1 <= to ? i <= to : i >= to; 1 <= to ? i++ : i--) {
        fraction = i / how_many;
        points.push(this.interpolate(fraction));
      }
      if (last) points.push(this.p2);
      return points;
    };

    Segment.prototype.travel_x_distance = function(distance) {
      if (!distance) return this;
      return new MapTools.Segment(this.interpolate(distance / this.distance), this.p2);
    };

    Segment.prototype.middle_point = function() {
      return this.interpolate(0.5);
    };

    Segment.prototype.closest_point = function(p) {
      var closest, p1, p2, p3, u, xd, yd;
      p1 = this.p1;
      p2 = this.p2;
      p3 = p;
      xd = p2[0] - p1[0];
      yd = p2[1] - p1[1];
      if (xd === 0 && yd === 0) {
        closest = p1;
      } else {
        u = ((p3[0] - p1[0]) * xd + (p3[1] - p1[1]) * yd) / (xd * xd + yd * yd);
        if (u < 0) {
          closest = p1;
        } else if (u > 1) {
          closest = p2;
        } else {
          closest = [p1[0] + u * xd, p1[1] + u * yd];
        }
      }
      return new MapTools.Segment(p3, closest);
    };

    Segment.prototype.distance_in_meters = function() {
      if (this._distance_in_meters) return this._distance_in_meters;
      this.mapize();
      return this._distance_in_meters = $G.geometry.spherical.computeDistanceBetween(this.latlng1, this.latlng2);
    };

    Segment.prototype.path = function() {
      this.mapize();
      return [this.latlng1, this.latlng2];
    };

    return Segment;

  })();

}).call(this);
var BusEditor = {};
(function() {

  BusEditor.Bus = (function() {

    function Bus(data) {
      this.data = data;
      this.build_city();
      this.build_routes();
      this.bind_routes();
    }

    Bus.prototype.find_element = function() {};

    Bus.prototype.build_city = function() {
      return this.city = new BusEditor.City(this.data.city);
    };

    Bus.prototype.build_routes = function() {
      this.departure_route = new BusEditor.Route(this.city, this.data.departure_route, "departure_route", "red");
      this.return_route = new BusEditor.Route(this.city, this.data.return_route, "return_route", "blue");
      return this.return_route.stop_edit();
    };

    Bus.prototype.bind_routes = function() {
      var _this = this;
      this.departure_route.add_listener('change_tab', function() {
        _this.departure_route.stop_edit();
        return _this.return_route.edit();
      });
      return this.return_route.add_listener('change_tab', function() {
        _this.return_route.stop_edit();
        return _this.departure_route.edit();
      });
    };

    return Bus;

  })();

}).call(this);
(function() {

  BusEditor.City = (function() {

    function City(data) {
      this.data = data;
      this.build_map();
      this.build_fetcher();
    }

    City.prototype.build_map = function() {
      this.map = new MapTools.Map($$('map'), this.data["viewport"]);
      return this.gmap = this.map.gmap;
    };

    City.prototype.build_fetcher = function() {
      return this.fetcher = new BusEditor.City.AddressFetcher(this.data["name"], this.data["country"], this.data["region_tag"]);
    };

    City.prototype.fetch_address = function(address, callback) {
      return this.fetcher.fetch(address, callback);
    };

    return City;

  })();

}).call(this);
(function() {

  BusEditor.City.AddressFetcher = (function() {

    function AddressFetcher(city, country, region) {
      this.city = city;
      this.country = country;
      this.region = region;
      this.build_geocoder();
      this.run_reasonable_fetcher();
    }

    AddressFetcher.prototype.build_geocoder = function() {
      return this.geocoder = new $G.Geocoder();
    };

    AddressFetcher.prototype.run_reasonable_fetcher = function() {
      var _this = this;
      this.fetches = [];
      this.fetching = false;
      this.last_fetch_time = this.time();
      return setInterval(function() {
        var to_fetch;
        to_fetch = _this.fetches[0];
        if (to_fetch && !_this.fetching && _this.at_least_one_second_passed()) {
          _this.fetches.shift();
          return _this.fetch_now(to_fetch[0], to_fetch[1]);
        }
      }, 500);
    };

    AddressFetcher.prototype.fetch = function(address_name, callback) {
      return this.fetches.push([address_name, callback]);
    };

    AddressFetcher.prototype.fetch_now = function(address, callback) {
      var _this = this;
      this.fetching = true;
      console.log("Fetching...", address);
      return this.geocoder.geocode(this.options(address), function(results, status) {
        console.log(results);
        _this.fetching = false;
        _this.last_fetch_time = _this.time();
        if (status === 'OK') {
          console.log("Success!");
          return callback(_this.parse_result(results[0]));
        } else {
          console.log("FAILED!", status);
          return callback(false);
        }
      });
    };

    AddressFetcher.prototype.at_least_one_second_passed = function() {
      return this.last_fetch_time < this.time();
    };

    AddressFetcher.prototype.time = function() {
      return (new Date).getTime();
    };

    AddressFetcher.prototype.options = function(address_name) {
      return {
        address: "" + address_name + ", " + this.city + ", " + this.country,
        region: this.region
      };
    };

    AddressFetcher.prototype.parse_result = function(result) {
      return result.geometry.location;
    };

    return AddressFetcher;

  })();

}).call(this);
(function() {

  $(function() {
    if ($(document["body"]).is('.edit.admin_buses')) {
      return new BusEditor.Bus(window["bus_editor_data"]);
    }
  });

}).call(this);
(function() {

  BusEditor.Map = {};

}).call(this);
(function() {
  var __hasProp = Object.prototype.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor; child.__super__ = parent.prototype; return child; };

  BusEditor.Map.Route = (function(_super) {

    __extends(Route, _super);

    Route.prototype.temp_point = null;

    Route.prototype.point_addition_enabled = true;

    Route.prototype.reverse_insertion = false;

    function Route(map, coordinates, options) {
      Route.__super__.constructor.call(this, map, coordinates, options);
      this.bind_events();
    }

    Route.prototype.bind_events = function() {
      var _this = this;
      $G.event.addListener(this.gmap, "click", function(e) {
        return _this.add_point(e.latLng);
      });
      return this.update_edit_state();
    };

    Route.prototype.add_point = function(point) {
      if (this.point_addition_enabled) {
        if (this.points.length === 0) {
          if (this.temp_point) {
            this.update_poly_path([this.temp_point, point]);
            this.temp_point = null;
          } else {
            this.temp_point = point;
          }
        } else {
          if (!this.reverse_insertion) {
            this.points.push(point);
          } else {
            this.points.insertAt(0, point);
          }
        }
        return this.update_edit_state();
      }
    };

    Route.prototype.update_edit_state = function(yes_no) {
      if (yes_no == null) yes_no = true;
      return this.poly.edit(yes_no, {
        ghosts: yes_no
      });
    };

    Route.prototype.get_points = function() {
      return this.points.getArray();
    };

    Route.prototype.editable = function(yes_no) {
      if (yes_no == null) yes_no = true;
      this.enable_point_addition(yes_no);
      return this.update_edit_state(yes_no);
    };

    Route.prototype.enable_point_addition = function(yes_no) {
      if (yes_no == null) yes_no = true;
      return this.point_addition_enabled = yes_no;
    };

    Route.prototype.enable_reverse_insertion = function(yes_no) {
      return this.reverse_insertion = yes_no;
    };

    Route.prototype.encoded = function() {
      return $G.geometry.encoding.encodePath(this.points);
    };

    return Route;

  })(MapTools.Route);

}).call(this);
(function() {
  var __hasProp = Object.prototype.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor; child.__super__ = parent.prototype; return child; };

  BusEditor.Map.BusRoute = (function(_super) {

    __extends(BusRoute, _super);

    function BusRoute(a, checkpoints, options) {
      this.checkpoints = checkpoints;
      BusRoute.__super__.constructor.call(this, a, this.checkpoints_to_coordinates(), options);
    }

    BusRoute.prototype.checkpoints_to_coordinates = function() {
      var checkpoint, _i, _len, _ref, _results;
      this.order_checkpoints();
      _ref = this.checkpoints;
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        checkpoint = _ref[_i];
        _results.push([checkpoint.latitude, checkpoint.longitude]);
      }
      return _results;
    };

    BusRoute.prototype.order_checkpoints = function() {
      return this.checkpoints = this.checkpoints.sort(function(a, b) {
        return a.number - b.number;
      });
    };

    BusRoute.prototype.to_attributes = function() {
      var checkpoint, checkpoints, i, point, points, result, to_destroy, _i, _len;
      result = [];
      points = this.get_points();
      checkpoints = this.checkpoints.slice(0, points.length + 1 || 9e9);
      to_destroy = this.checkpoints.slice(points.length);
      for (i in points) {
        point = points[i];
        checkpoint = _.clone(this.checkpoints[i]) || {};
        checkpoint["latitude"] = point.lat();
        checkpoint["longitude"] = point.lng();
        checkpoint["number"] = i;
        result.push(checkpoint);
      }
      for (_i = 0, _len = to_destroy.length; _i < _len; _i++) {
        checkpoint = to_destroy[_i];
        checkpoint = _.clone(checkpoint);
        checkpoint["_destroy"] = 1;
        result.push(checkpoint);
      }
      return result;
    };

    return BusRoute;

  })(BusEditor.Map.Route);

}).call(this);
(function() {
  var __hasProp = Object.prototype.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor; child.__super__ = parent.prototype; return child; };

  BusEditor.Route = (function(_super) {

    __extends(Route, _super);

    function Route(city, data, element_name, color) {
      this.city = city;
      this.map = this.city.map;
      this.color = color;
      this.data = data;
      this.name = element_name;
      this.find_elements();
      this.bind_elements();
      this.build_route();
      this.build_addresses_manager();
    }

    Route.prototype.find_elements = function() {
      this.e = $$(this.name);
      this.tabs = this.e.find('legend a');
      this.tab = this.tabs.filter("." + this.name + "_tab");
      return this.reverse_insertion = this.e.find('.reverse_insertion');
    };

    Route.prototype.bind_elements = function() {
      var _this = this;
      _this = this;
      _this.tabs.click(function() {
        if (this !== _this.tab[0]) return _this.fire_event('change_tab');
      });
      return this.reverse_insertion.change(function() {
        return _this.route.reverse_insertion(_this.reverse_insertion.is(':checked'));
      });
    };

    Route.prototype.build_route = function() {
      return this.route = new BusEditor.Route.InputsHandler(this.map, this.e, {
        strokeColor: this.color
      });
    };

    Route.prototype.build_addresses_manager = function() {
      return this.addresses_manager = new BusEditor.Route.AddressesManager(this.city, this.e);
    };

    Route.prototype.edit = function() {
      this.show_tab();
      this.route.start_editing();
      return this.addresses_manager.show();
    };

    Route.prototype.stop_edit = function() {
      this.hide_tab();
      this.route.stop_editing();
      return this.addresses_manager.hide();
    };

    Route.prototype.hide_tab = function() {
      return this.e.hide();
    };

    Route.prototype.show_tab = function() {
      return this.e.show();
    };

    return Route;

  })(Utils.Eventable);

}).call(this);
(function() {

  BusEditor.Route.AddressesManager = (function() {

    function AddressesManager(city, parent) {
      this.city = city;
      this.parent = parent;
      this.addresses = {};
      this.current_addresses = {};
      this.find_element();
      this.build_watcher();
      this.bind_watcher();
    }

    AddressesManager.prototype.find_element = function() {
      return this.element = this.e = this.parent.find('textarea');
    };

    AddressesManager.prototype.build_watcher = function() {
      return this.watcher = new BusEditor.Route.AddressesManager.Watcher(this.element);
    };

    AddressesManager.prototype.bind_watcher = function() {
      var _this = this;
      this.watcher.add_listener('target_change', function() {
        return _this.handle_selected_address();
      });
      return this.watcher.add_listener('change', function() {
        _this.update_addresses_visibility();
        return _this.handle_selected_address();
      });
    };

    AddressesManager.prototype.handle_selected_address = function() {
      var selected_address;
      selected_address = this.watcher.get_selected_address();
      if (selected_address) {
        this.unhighlight_addresses();
        return this.highlight_address(selected_address);
      }
    };

    AddressesManager.prototype.update_addresses_visibility = function() {
      this.hide_addresses();
      this.update_current_addresses();
      return this.show_addresses();
    };

    AddressesManager.prototype.update_current_addresses = function() {
      var address, _i, _len, _ref;
      this.current_addresses = {};
      _ref = this.watcher.addresses();
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        address = _ref[_i];
        if (!this.addresses[address.id]) {
          this.addresses[address.id] = new BusEditor.Route.AddressesManager.Address(address, this.city);
        }
        this.current_addresses[address.id] = this.addresses[address.id];
      }
      return this.current_addresses;
    };

    AddressesManager.prototype.show_addresses = function() {
      var address, i, _ref;
      _ref = this.current_addresses;
      for (i in _ref) {
        address = _ref[i];
        address.show();
      }
    };

    AddressesManager.prototype.show = function() {
      return this.show_addresses();
    };

    AddressesManager.prototype.hide_addresses = function() {
      var address, i, _ref;
      _ref = this.current_addresses;
      for (i in _ref) {
        address = _ref[i];
        address.hide();
      }
    };

    AddressesManager.prototype.hide = function() {
      return this.hide_addresses();
    };

    AddressesManager.prototype.highlight_address = function(address) {
      if (this.current_addresses[address.id]) {
        return this.current_addresses[address.id].highlight();
      }
    };

    AddressesManager.prototype.unhighlight_addresses = function() {
      var address, i, _ref;
      _ref = this.current_addresses;
      for (i in _ref) {
        address = _ref[i];
        address.unhighlight();
      }
    };

    return AddressesManager;

  })();

}).call(this);
(function() {

  BusEditor.Route.AddressesManager.Address = (function() {

    Address.prototype.element = null;

    Address.prototype.results = null;

    Address.prototype.highlighted = false;

    function Address(address, city) {
      this.address = address;
      this.city = city;
    }

    Address.prototype.show = function() {
      if (this.element) {
        return this.element.show();
      } else {
        return this.fetch();
      }
    };

    Address.prototype.hide = function() {
      if (this.element) return this.element.hide();
    };

    Address.prototype.highlight = function() {
      if (this.element) {
        return this.element.highlight();
      } else {
        return this.highlighted = true;
      }
    };

    Address.prototype.unhighlight = function() {
      if (this.element) {
        return this.element.unhighlight();
      } else {
        return this.highlighted = false;
      }
    };

    Address.prototype.fetch = function() {
      var _this = this;
      this.fetcher || (this.fetcher = new BusEditor.Route.AddressesManager.Fetcher(this.city, this.address));
      return this.fetcher.fetch(function(results) {
        console.log("Results!", results);
        _this.results = results;
        if (results) {
          if (results.length === 1) {
            return _this.element = new BusEditor.Route.AddressesManager.Displayer.Single(_this.city.gmap, results[0], _this.highlighted);
          } else if (results.length >= 2) {
            return _this.element = new BusEditor.Route.AddressesManager.Displayer.Poly(_this.city.gmap, results, _this.highlighted);
          } else {
            return console.log('Something bad happened');
          }
        }
      });
    };

    return Address;

  })();

}).call(this);
(function() {

  BusEditor.Route.AddressesManager.Address.Parser = (function() {

    function Parser(address_line) {
      this.address_line = address_line;
      this.parse_address();
    }

    Parser.prototype.parse_address = function() {
      var comments, street, streets;
      streets = this.address_line.split('>');
      comments = [];
      this.streets = (function() {
        var _i, _len, _results;
        _results = [];
        for (_i = 0, _len = streets.length; _i < _len; _i++) {
          street = streets[_i];
          comments.push(street.comment);
          _results.push(new BusEditor.Route.AddressesManager.Address.StreetParser(street));
        }
        return _results;
      })();
      this.id = this.streets[0].full_address;
      this.full_address = this.streets[0].full_address;
      this.comment = comments.join(' | ');
      this.address = this.streets[0].address;
      return this.number = this.streets[0].number;
    };

    return Parser;

  })();

  BusEditor.Route.AddressesManager.Address.StreetParser = (function() {

    StreetParser.prototype.full_address = null;

    StreetParser.prototype.comment = null;

    StreetParser.prototype.address = null;

    StreetParser.prototype.number = null;

    function StreetParser(street) {
      this.street = street;
      this.parse_street();
    }

    StreetParser.prototype.parse_street = function() {
      var matches;
      matches = this.street.match(/([^(]*)(?:\((.*)\))?/);
      if (matches) {
        this.full_address = matches[1].replace(/^\s+|\s+$/g, '');
        this.comment = matches[2];
        matches = this.full_address.match(/(.+?)([0-9]*)?$/);
        if (matches) {
          this.address = matches[1].replace(/^\s+|\s+$/g, '');
          return this.number = matches[2];
        }
      }
    };

    return StreetParser;

  })();

}).call(this);
(function() {



}).call(this);
(function() {

  BusEditor.Route.AddressesManager.Displayer = {};

}).call(this);
(function() {

  BusEditor.Route.AddressesManager.Displayer.Base = (function() {

    Base.prototype.visible = true;

    Base.prototype.highlighted = false;

    function Base(gmap, highlighted) {
      this.gmap = gmap;
      this.highlighted = highlighted;
      this.build_element();
    }

    Base.prototype.options = function() {
      return {
        map: this.gmap,
        clickable: false
      };
    };

    Base.prototype.highlighted_options = function() {
      return this.options();
    };

    Base.prototype.default_options = function() {
      if (this.highlighted) {
        return this.highlighted_options();
      } else {
        return this.options();
      }
    };

    Base.prototype.show = function() {
      if (!this.visible) this.element.setVisible(true);
      return this.visible = true;
    };

    Base.prototype.hide = function() {
      if (this.visible) this.element.setVisible(false);
      return this.visible = false;
    };

    Base.prototype.highlight = function() {
      if (!this.highlighted) this.element.setOptions(this.highlighted_options());
      return this.highlighted = true;
    };

    Base.prototype.unhighlight = function() {
      if (this.highlighted) this.element.setOptions(this.options());
      return this.highlighted = false;
    };

    return Base;

  })();

}).call(this);
(function() {
  var __hasProp = Object.prototype.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor; child.__super__ = parent.prototype; return child; };

  BusEditor.Route.AddressesManager.Displayer.Poly = (function(_super) {

    __extends(Poly, _super);

    function Poly(gmap, results, highlighted) {
      this.results = results;
      Poly.__super__.constructor.call(this, gmap, highlighted);
    }

    Poly.prototype.build_element = function() {
      return this.element = new $G.Polyline(this.default_options());
    };

    Poly.prototype.options = function() {
      return _.extend(Poly.__super__.options.apply(this, arguments), {
        path: this.create_path(),
        strokeColor: 'green',
        strokeOpacity: 0.75,
        strokeWeight: 1
      });
    };

    Poly.prototype.highlighted_options = function() {
      return _.extend(this.options(), {
        strokeOpacity: 1,
        strokeWeight: 2
      });
    };

    Poly.prototype.create_path = function() {
      var p0, p1, segment;
      p0 = [this.results[0].lat(), this.results[0].lng()];
      p1 = [this.results[1].lat(), this.results[1].lng()];
      segment = new MapTools.Segment(p0, p1, this.results[0], this.results[1]);
      return [$LatLng(segment.interpolate(-5)), $LatLng(segment.interpolate(6))];
    };

    return Poly;

  })(BusEditor.Route.AddressesManager.Displayer.Base);

}).call(this);
(function() {
  var __hasProp = Object.prototype.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor; child.__super__ = parent.prototype; return child; };

  BusEditor.Route.AddressesManager.Displayer.Single = (function(_super) {

    __extends(Single, _super);

    function Single(gmap, result, highlighted) {
      this.result = result;
      Single.__super__.constructor.call(this, gmap, highlighted);
    }

    Single.prototype.build_element = function() {
      return this.element = new $G.Marker(this.default_options());
    };

    Single.prototype.options = function() {
      return _.extend(Single.__super__.options.apply(this, arguments), {
        position: this.result
      });
    };

    return Single;

  })(BusEditor.Route.AddressesManager.Displayer.Base);

}).call(this);
(function() {

  BusEditor.Route.AddressesManager.Fetcher = (function() {

    Fetcher.prototype.start_number = 100;

    Fetcher.prototype.end_number = 1000;

    Fetcher.prototype.max_results = 2;

    Fetcher.prototype.fetched = false;

    Fetcher.prototype.fetch_numbers = [3000, 500, 7000, 0, 10000];

    function Fetcher(city, address) {
      this.city = city;
      this.address = address;
      this.queries = [];
      this.results = [];
    }

    Fetcher.prototype.build_queries = function() {
      var number, _i, _len, _ref, _results;
      if (this.address.number) {
        this.queries.push(this.address.full_address);
        return this.max_results = 1;
      } else {
        _ref = this.fetch_numbers;
        _results = [];
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          number = _ref[_i];
          _results.push(this.queries.push("" + this.address.address + " " + number));
        }
        return _results;
      }
    };

    Fetcher.prototype.fetch = function(callback) {
      if (this.results.length === 0) {
        this.build_queries();
        return this.fetch_by_one(this.queries, callback);
      } else {
        return callback(this.results);
      }
    };

    Fetcher.prototype.fetch_by_one = function(queries, callback) {
      var _this = this;
      if (queries.length === 0) {
        return callback([]);
      } else {
        return this.city.fetch_address(queries.shift(), function(result) {
          if (!result) {
            return _this.fetch_by_one(queries, callback);
          } else {
            if (!_this.result_exists(result)) _this.results.push(result);
            if (_this.results.length >= _this.max_results) {
              return callback(_this.results);
            } else {
              return _this.fetch_by_one(queries, callback);
            }
          }
        });
      }
    };

    Fetcher.prototype.result_exists = function(search) {
      var result, _i, _len, _ref;
      _ref = this.results;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        result = _ref[_i];
        if (result.lat() === search.lat() && result.lng() === search.lng()) {
          return true;
        }
      }
      return false;
    };

    return Fetcher;

  })();

}).call(this);
(function() {
  var __hasProp = Object.prototype.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor; child.__super__ = parent.prototype; return child; };

  BusEditor.Route.AddressesManager.Watcher = (function(_super) {

    __extends(Watcher, _super);

    function Watcher(element) {
      this.e = element;
      this.bind_element();
    }

    Watcher.prototype.bind_element = function() {
      var _this = this;
      this.e.keypress(function(e) {
        if (e.keyCode === 13) return _this.fire_event('change');
      });
      this.e.keyup(function(e) {
        if ([38, 40].indexOf(e.keyCode) !== -1) {
          return _this.fire_event("target_change");
        }
      });
      return this.e.mouseup(function(e) {
        return _this.fire_event("target_change");
      });
    };

    Watcher.prototype.get_selected_address = function() {
      var address_name, parsed_address;
      address_name = this.get_current_line();
      parsed_address = new BusEditor.Route.AddressesManager.Address.Parser(address_name);
      if (parsed_address.id) {
        return parsed_address;
      } else {
        return false;
      }
    };

    Watcher.prototype.it_changed = function() {
      var _ref;
      _ref = [this.value, this.e.val()], this.last_value = _ref[0], this.value = _ref[1];
      return this.value !== this.last_value;
    };

    Watcher.prototype.get_current_line = function() {
      var caret, value;
      value = this.e.val();
      caret = this.e.getSelection().start;
      return this.parse_selection(value, caret);
    };

    Watcher.prototype.parse_selection = function(value, start_from) {
      var current_line, end, start;
      if (start_from < 0) return value;
      start = value.lastIndexOf('\n', start_from - 1) + 1;
      end = value.indexOf('\n', start_from);
      if (end === -1) end = value.length;
      current_line = value.substr(start, end - start);
      if (!current_line) {
        return this.parse_selection(value, start_from - 1);
      } else {
        return current_line;
      }
    };

    Watcher.prototype.addresses = function() {
      var address, addresses, value, _i, _len, _ref;
      addresses = [];
      _ref = this.e.val().replace(/^\s+|\s+$/, '').split(/\n+/);
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        value = _ref[_i];
        address = new BusEditor.Route.AddressesManager.Address.Parser(value);
        if (address.id) addresses.push(address);
      }
      return addresses;
    };

    return Watcher;

  })(Utils.Eventable);

}).call(this);
(function() {

  BusEditor.Route.InputsHandler = (function() {

    function InputsHandler(map, container, options) {
      this.container = container;
      this.map = map;
      this.container = container;
      this.read_checkpoints();
      this.route = new BusEditor.Map.BusRoute(this.map, this.checkpoints, options);
      this.bind_events();
    }

    InputsHandler.prototype.read_checkpoints = function() {
      this.checkpoints_input = this.container.find('[name$="[json_checkpoints_attributes]"]');
      this.encoded_input = this.container.find('[name$="[encoded]"]');
      return this.checkpoints = JSON.parse(this.checkpoints_input.val());
    };

    InputsHandler.prototype.bind_events = function() {
      var _this = this;
      return google.maps.event.addListener(this.map.gmap, "mouseout", function() {
        return _this.write_checkpoints();
      });
    };

    InputsHandler.prototype.write_checkpoints = function() {
      this.checkpoints_input.val(JSON.stringify(this.route.to_attributes()));
      return this.encoded_input.val(this.route.encoded());
    };

    InputsHandler.prototype.start_editing = function() {
      return this.route.editable(true);
    };

    InputsHandler.prototype.stop_editing = function() {
      return this.route.editable(false);
    };

    InputsHandler.prototype.reverse_insertion = function(yes_no) {
      return this.route.enable_reverse_insertion(yes_no);
    };

    return InputsHandler;

  })();

}).call(this);
var CityEditor = {};
(function() {

  CityEditor.City = (function() {

    function City() {
      this.find_elements();
      this.build_map();
      this.bind_map();
    }

    City.prototype.find_elements = function() {
      this.e = this.element = $$('map');
      this.viewport_element = $$('city_json_viewport');
      try {
        return this.viewport = JSON.parse(this.viewport_element.val());
      } catch (e) {
        return this.viewport = false;
      }
    };

    City.prototype.build_map = function() {
      return this.map = new MapTools.Map(this.e, this.viewport);
    };

    City.prototype.bind_map = function() {
      var _this = this;
      return $G.event.addListener(this.map.gmap, 'bounds_changed', function() {
        return _this.set_viewport(_this.map.get_bounds());
      });
    };

    City.prototype.set_viewport = function(viewport) {
      return this.viewport_element.val(JSON.stringify(viewport));
    };

    return City;

  })();

}).call(this);
(function() {

  $(function() {
    if ($(document["body"]).is('.edit.admin_cities')) return new CityEditor.City;
  });

}).call(this);
/*
 * jQuery plugin: fieldSelection - v0.1.1 - last change: 2006-12-16
 * (c) 2006 Alex Brem <alex@0xab.cd> - http://blog.0xab.cd
 */

(function(){var fieldSelection={getSelection:function(){var e=(this.jquery)?this[0]:this;return(('selectionStart'in e&&function(){var l=e.selectionEnd-e.selectionStart;return{start:e.selectionStart,end:e.selectionEnd,length:l,text:e.value.substr(e.selectionStart,l)}})||(document.selection&&function(){e.focus();var r=document.selection.createRange();if(r===null){return{start:0,end:e.value.length,length:0}}var re=e.createTextRange();var rc=re.duplicate();re.moveToBookmark(r.getBookmark());rc.setEndPoint('EndToStart',re);return{start:rc.text.length,end:rc.text.length+r.text.length,length:r.text.length,text:r.text}})||function(){return null})()},replaceSelection:function(){var e=(typeof this.id=='function')?this.get(0):this;var text=arguments[0]||'';return(('selectionStart'in e&&function(){e.value=e.value.substr(0,e.selectionStart)+text+e.value.substr(e.selectionEnd,e.value.length);return this})||(document.selection&&function(){e.focus();document.selection.createRange().text=text;return this})||function(){e.value+=text;return jQuery(e)})()}};jQuery.each(fieldSelection,function(i){jQuery.fn[i]=this})})();
(function(a){if(google.maps.Polyline.prototype.edit===a){function b(b,c){function p(){this.setIcon(o)}function q(){this.setIcon(n)}function r(){var a=this.getPosition();a.marker=this,a.ghostMarker=g(this.editIndex).ghostMarker,b.getPath().setAt(this.editIndex,a),c.ghosts&&k(this)}function s(){google.maps.event.trigger(b,"update_at",this.editIndex,this.getPosition())}function t(){if(!c.ghosts)return;var d=g(this.editIndex),e=g(this.editIndex-1);d.ghostMarker&&d.ghostMarker.setMap(null),console.log(this.editIndex),b.getPath().removeAt(this.editIndex),e&&(this.editIndex<b.getPath().getLength()?k(e.marker):(e.ghostMarker.setMap(null),e.ghostMarker=a)),this.setMap(null),b.getPath().forEach(function(a,b){a.marker&&(a.marker.editIndex=b)}),b.getPath().getLength()===1&&b.getPath().pop().marker.setMap(null),google.maps.event.trigger(b,"remove_at",this.editIndex,d)}function u(a){var c=a.marker;return c||(c=new google.maps.Marker({position:a,map:b.getMap(),icon:n,draggable:!0,raiseOnDrag:!1}),google.maps.event.addListener(c,"mouseover",p),google.maps.event.addListener(c,"mouseout",q),google.maps.event.addListener(c,"drag",r),google.maps.event.addListener(c,"dragend",s),google.maps.event.addListener(c,"rightclick",t),a.marker=c),c.setPosition(a),c}c=c||{},c.ghosts=c.ghosts||c.ghosts===a,c.imagePath=c.imagePath||google.maps.Polyline.prototype.edit.settings.imagePath;if(c.ghosts){var d=new google.maps.MarkerImage(c.imagePath+"ghostVertex.png",new google.maps.Size(11,11),new google.maps.Point(0,0),new google.maps.Point(6,6)),e=new google.maps.MarkerImage(c.imagePath+"ghostVertexOver.png",new google.maps.Size(11,11),new google.maps.Point(0,0),new google.maps.Point(6,6)),f=new google.maps.Polyline({map:b.getMap(),strokeColor:b.strokeColor,strokeOpacity:.2,strokeWeight:b.strokeWeight});function g(a){return b.getPath().getAt(a)}function h(){this.setIcon(e)}function i(){this.setIcon(d)}function j(){f.getPath().getLength()===0&&f.setPath([this.marker.getPosition(),this.getPosition(),g(this.marker.editIndex+1)]),f.getPath().setAt(1,this.getPosition())}function k(a){var b=g(a.editIndex),c=g(a.editIndex-1),d=g(a.editIndex+1),e=a.getPosition();b&&b.ghostMarker&&(google.maps.geometry?b.ghostMarker.setPosition(google.maps.geometry.spherical.interpolate(b,d,.5)):b.ghostMarker.setPosition(new google.maps.LatLng(b.lat()+.5*(d.lat()-b.lat()),b.lng()+.5*(d.lng()-b.lng())))),c&&c.ghostMarker&&(google.maps.geometry?c.ghostMarker.setPosition(google.maps.geometry.spherical.interpolate(c,e,.5)):c.ghostMarker.setPosition(new google.maps.LatLng(c.lat()+.5*(e.lat()-c.lat()),c.lng()+.5*(e.lng()-c.lng()))))}function l(){var a=this.getPosition(),c=this.marker.editIndex+1,d;f.getPath().forEach(function(){f.getPath().pop()}),b.getPath().insertAt(c,a),d=u(g(c)),d.editIndex=c,k(this.marker),m(g(c)),b.getPath().forEach(function(a,b){a.marker&&(a.marker.editIndex=b)}),google.maps.event.trigger(b,"insert_at",c,a)}function m(a){if(a.marker.editIndex<b.getPath().getLength()-1){var c=g(a.marker.editIndex+1),e,f;return google.maps.geometry?e=google.maps.geometry.spherical.interpolate(a,c,.5):e=new google.maps.LatLng(a.lat()+.5*(c.lat()-a.lat()),a.lng()+.5*(c.lng()-a.lng())),f=a.ghostMarker,f||(f=new google.maps.Marker({map:b.getMap(),icon:d,draggable:!0,raiseOnDrag:!1}),google.maps.event.addListener(f,"mouseover",h),google.maps.event.addListener(f,"mouseout",i),google.maps.event.addListener(f,"drag",j),google.maps.event.addListener(f,"dragend",l),a.ghostMarker=f,f.marker=a.marker),f.setPosition(e),f}return null}}var n=new google.maps.MarkerImage(c.imagePath+"vertex.png",new google.maps.Size(11,11),new google.maps.Point(0,0),new google.maps.Point(6,6)),o=new google.maps.MarkerImage(c.imagePath+"vertexOver.png",new google.maps.Size(11,11),new google.maps.Point(0,0),new google.maps.Point(6,6));b.getPath().forEach(function(a,b){u(a).editIndex=b,c.ghosts&&m(a)}),google.maps.event.trigger(b,"edit_start")}function c(b){b.getPath().forEach(function(b,c){b.marker&&(b.marker.setMap(null),b.marker=a),b.ghostMarker&&(b.ghostMarker.setMap(null),b.ghostMarker=a)}),google.maps.event.trigger(b,"edit_end",b.getPath())}google.maps.Polyline.prototype.edit=function(d,e){d||d===a?(!e&&typeof d=="object"&&(e=d),b(this,e)):c(this)},google.maps.Polyline.prototype.edit.settings={imagePath:"/assets/polyline.edit/"}}})()
;
// CLOSURE_COMPILER_SKIP_FILE







true;
