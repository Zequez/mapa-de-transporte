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
/*!
 * jQuery Templates Plugin 1.0.0pre
 * http://github.com/jquery/jquery-tmpl
 * Requires jQuery 1.4.2
 *
 * Copyright 2011, Software Freedom Conservancy, Inc.
 * Dual licensed under the MIT or GPL Version 2 licenses.
 * http://jquery.org/license
 */

(function( jQuery, undefined ){
	var oldManip = jQuery.fn.domManip, tmplItmAtt = "_tmplitem", htmlExpr = /^[^<]*(<[\w\W]+>)[^>]*$|\{\{\! /,
		newTmplItems = {}, wrappedItems = {}, appendToTmplItems, topTmplItem = { key: 0, data: {} }, itemKey = 0, cloneIndex = 0, stack = [];

	function newTmplItem( options, parentItem, fn, data ) {
		// Returns a template item data structure for a new rendered instance of a template (a 'template item').
		// The content field is a hierarchical array of strings and nested items (to be
		// removed and replaced by nodes field of dom elements, once inserted in DOM).
		var newItem = {
			data: data || (data === 0 || data === false) ? data : (parentItem ? parentItem.data : {}),
			_wrap: parentItem ? parentItem._wrap : null,
			tmpl: null,
			parent: parentItem || null,
			nodes: [],
			calls: tiCalls,
			nest: tiNest,
			wrap: tiWrap,
			html: tiHtml,
			update: tiUpdate
		};
		if ( options ) {
			jQuery.extend( newItem, options, { nodes: [], parent: parentItem });
		}
		if ( fn ) {
			// Build the hierarchical content to be used during insertion into DOM
			newItem.tmpl = fn;
			newItem._ctnt = newItem._ctnt || newItem.tmpl( jQuery, newItem );
			newItem.key = ++itemKey;
			// Keep track of new template item, until it is stored as jQuery Data on DOM element
			(stack.length ? wrappedItems : newTmplItems)[itemKey] = newItem;
		}
		return newItem;
	}

	// Override appendTo etc., in order to provide support for targeting multiple elements. (This code would disappear if integrated in jquery core).
	jQuery.each({
		appendTo: "append",
		prependTo: "prepend",
		insertBefore: "before",
		insertAfter: "after",
		replaceAll: "replaceWith"
	}, function( name, original ) {
		jQuery.fn[ name ] = function( selector ) {
			var ret = [], insert = jQuery( selector ), elems, i, l, tmplItems,
				parent = this.length === 1 && this[0].parentNode;

			appendToTmplItems = newTmplItems || {};
			if ( parent && parent.nodeType === 11 && parent.childNodes.length === 1 && insert.length === 1 ) {
				insert[ original ]( this[0] );
				ret = this;
			} else {
				for ( i = 0, l = insert.length; i < l; i++ ) {
					cloneIndex = i;
					elems = (i > 0 ? this.clone(true) : this).get();
					jQuery( insert[i] )[ original ]( elems );
					ret = ret.concat( elems );
				}
				cloneIndex = 0;
				ret = this.pushStack( ret, name, insert.selector );
			}
			tmplItems = appendToTmplItems;
			appendToTmplItems = null;
			jQuery.tmpl.complete( tmplItems );
			return ret;
		};
	});

	jQuery.fn.extend({
		// Use first wrapped element as template markup.
		// Return wrapped set of template items, obtained by rendering template against data.
		tmpl: function( data, options, parentItem ) {
			return jQuery.tmpl( this[0], data, options, parentItem );
		},

		// Find which rendered template item the first wrapped DOM element belongs to
		tmplItem: function() {
			return jQuery.tmplItem( this[0] );
		},

		// Consider the first wrapped element as a template declaration, and get the compiled template or store it as a named template.
		template: function( name ) {
			return jQuery.template( name, this[0] );
		},

		domManip: function( args, table, callback, options ) {
			if ( args[0] && jQuery.isArray( args[0] )) {
				var dmArgs = jQuery.makeArray( arguments ), elems = args[0], elemsLength = elems.length, i = 0, tmplItem;
				while ( i < elemsLength && !(tmplItem = jQuery.data( elems[i++], "tmplItem" ))) {}
				if ( tmplItem && cloneIndex ) {
					dmArgs[2] = function( fragClone ) {
						// Handler called by oldManip when rendered template has been inserted into DOM.
						jQuery.tmpl.afterManip( this, fragClone, callback );
					};
				}
				oldManip.apply( this, dmArgs );
			} else {
				oldManip.apply( this, arguments );
			}
			cloneIndex = 0;
			if ( !appendToTmplItems ) {
				jQuery.tmpl.complete( newTmplItems );
			}
			return this;
		}
	});

	jQuery.extend({
		// Return wrapped set of template items, obtained by rendering template against data.
		tmpl: function( tmpl, data, options, parentItem ) {
			var ret, topLevel = !parentItem;
			if ( topLevel ) {
				// This is a top-level tmpl call (not from a nested template using {{tmpl}})
				parentItem = topTmplItem;
				tmpl = jQuery.template[tmpl] || jQuery.template( null, tmpl );
				wrappedItems = {}; // Any wrapped items will be rebuilt, since this is top level
			} else if ( !tmpl ) {
				// The template item is already associated with DOM - this is a refresh.
				// Re-evaluate rendered template for the parentItem
				tmpl = parentItem.tmpl;
				newTmplItems[parentItem.key] = parentItem;
				parentItem.nodes = [];
				if ( parentItem.wrapped ) {
					updateWrapped( parentItem, parentItem.wrapped );
				}
				// Rebuild, without creating a new template item
				return jQuery( build( parentItem, null, parentItem.tmpl( jQuery, parentItem ) ));
			}
			if ( !tmpl ) {
				return []; // Could throw...
			}
			if ( typeof data === "function" ) {
				data = data.call( parentItem || {} );
			}
			if ( options && options.wrapped ) {
				updateWrapped( options, options.wrapped );
			}
			ret = jQuery.isArray( data ) ?
				jQuery.map( data, function( dataItem ) {
					return dataItem ? newTmplItem( options, parentItem, tmpl, dataItem ) : null;
				}) :
				[ newTmplItem( options, parentItem, tmpl, data ) ];
			return topLevel ? jQuery( build( parentItem, null, ret ) ) : ret;
		},

		// Return rendered template item for an element.
		tmplItem: function( elem ) {
			var tmplItem;
			if ( elem instanceof jQuery ) {
				elem = elem[0];
			}
			while ( elem && elem.nodeType === 1 && !(tmplItem = jQuery.data( elem, "tmplItem" )) && (elem = elem.parentNode) ) {}
			return tmplItem || topTmplItem;
		},

		// Set:
		// Use $.template( name, tmpl ) to cache a named template,
		// where tmpl is a template string, a script element or a jQuery instance wrapping a script element, etc.
		// Use $( "selector" ).template( name ) to provide access by name to a script block template declaration.

		// Get:
		// Use $.template( name ) to access a cached template.
		// Also $( selectorToScriptBlock ).template(), or $.template( null, templateString )
		// will return the compiled template, without adding a name reference.
		// If templateString includes at least one HTML tag, $.template( templateString ) is equivalent
		// to $.template( null, templateString )
		template: function( name, tmpl ) {
			if (tmpl) {
				// Compile template and associate with name
				if ( typeof tmpl === "string" ) {
					// This is an HTML string being passed directly in.
					tmpl = buildTmplFn( tmpl );
				} else if ( tmpl instanceof jQuery ) {
					tmpl = tmpl[0] || {};
				}
				if ( tmpl.nodeType ) {
					// If this is a template block, use cached copy, or generate tmpl function and cache.
					tmpl = jQuery.data( tmpl, "tmpl" ) || jQuery.data( tmpl, "tmpl", buildTmplFn( tmpl.innerHTML ));
					// Issue: In IE, if the container element is not a script block, the innerHTML will remove quotes from attribute values whenever the value does not include white space.
					// This means that foo="${x}" will not work if the value of x includes white space: foo="${x}" -> foo=value of x.
					// To correct this, include space in tag: foo="${ x }" -> foo="value of x"
				}
				return typeof name === "string" ? (jQuery.template[name] = tmpl) : tmpl;
			}
			// Return named compiled template
			return name ? (typeof name !== "string" ? jQuery.template( null, name ):
				(jQuery.template[name] ||
					// If not in map, and not containing at least on HTML tag, treat as a selector.
					// (If integrated with core, use quickExpr.exec)
					jQuery.template( null, htmlExpr.test( name ) ? name : jQuery( name )))) : null;
		},

		encode: function( text ) {
			// Do HTML encoding replacing < > & and ' and " by corresponding entities.
			return ("" + text).split("<").join("&lt;").split(">").join("&gt;").split('"').join("&#34;").split("'").join("&#39;");
		}
	});

	jQuery.extend( jQuery.tmpl, {
		tag: {
			"tmpl": {
				_default: { $2: "null" },
				open: "if($notnull_1){__=__.concat($item.nest($1,$2));}"
				// tmpl target parameter can be of type function, so use $1, not $1a (so not auto detection of functions)
				// This means that {{tmpl foo}} treats foo as a template (which IS a function).
				// Explicit parens can be used if foo is a function that returns a template: {{tmpl foo()}}.
			},
			"wrap": {
				_default: { $2: "null" },
				open: "$item.calls(__,$1,$2);__=[];",
				close: "call=$item.calls();__=call._.concat($item.wrap(call,__));"
			},
			"each": {
				_default: { $2: "$index, $value" },
				open: "if($notnull_1){$.each($1a,function($2){with(this){",
				close: "}});}"
			},
			"if": {
				open: "if(($notnull_1) && $1a){",
				close: "}"
			},
			"else": {
				_default: { $1: "true" },
				open: "}else if(($notnull_1) && $1a){"
			},
			"html": {
				// Unecoded expression evaluation.
				open: "if($notnull_1){__.push($1a);}"
			},
			"=": {
				// Encoded expression evaluation. Abbreviated form is ${}.
				_default: { $1: "$data" },
				open: "if($notnull_1){__.push($.encode($1a));}"
			},
			"!": {
				// Comment tag. Skipped by parser
				open: ""
			}
		},

		// This stub can be overridden, e.g. in jquery.tmplPlus for providing rendered events
		complete: function( items ) {
			newTmplItems = {};
		},

		// Call this from code which overrides domManip, or equivalent
		// Manage cloning/storing template items etc.
		afterManip: function afterManip( elem, fragClone, callback ) {
			// Provides cloned fragment ready for fixup prior to and after insertion into DOM
			var content = fragClone.nodeType === 11 ?
				jQuery.makeArray(fragClone.childNodes) :
				fragClone.nodeType === 1 ? [fragClone] : [];

			// Return fragment to original caller (e.g. append) for DOM insertion
			callback.call( elem, fragClone );

			// Fragment has been inserted:- Add inserted nodes to tmplItem data structure. Replace inserted element annotations by jQuery.data.
			storeTmplItems( content );
			cloneIndex++;
		}
	});

	//========================== Private helper functions, used by code above ==========================

	function build( tmplItem, nested, content ) {
		// Convert hierarchical content into flat string array
		// and finally return array of fragments ready for DOM insertion
		var frag, ret = content ? jQuery.map( content, function( item ) {
			return (typeof item === "string") ?
				// Insert template item annotations, to be converted to jQuery.data( "tmplItem" ) when elems are inserted into DOM.
				(tmplItem.key ? item.replace( /(<\w+)(?=[\s>])(?![^>]*_tmplitem)([^>]*)/g, "$1 " + tmplItmAtt + "=\"" + tmplItem.key + "\" $2" ) : item) :
				// This is a child template item. Build nested template.
				build( item, tmplItem, item._ctnt );
		}) :
		// If content is not defined, insert tmplItem directly. Not a template item. May be a string, or a string array, e.g. from {{html $item.html()}}.
		tmplItem;
		if ( nested ) {
			return ret;
		}

		// top-level template
		ret = ret.join("");

		// Support templates which have initial or final text nodes, or consist only of text
		// Also support HTML entities within the HTML markup.
		ret.replace( /^\s*([^<\s][^<]*)?(<[\w\W]+>)([^>]*[^>\s])?\s*$/, function( all, before, middle, after) {
			frag = jQuery( middle ).get();

			storeTmplItems( frag );
			if ( before ) {
				frag = unencode( before ).concat(frag);
			}
			if ( after ) {
				frag = frag.concat(unencode( after ));
			}
		});
		return frag ? frag : unencode( ret );
	}

	function unencode( text ) {
		// Use createElement, since createTextNode will not render HTML entities correctly
		var el = document.createElement( "div" );
		el.innerHTML = text;
		return jQuery.makeArray(el.childNodes);
	}

	// Generate a reusable function that will serve to render a template against data
	function buildTmplFn( markup ) {
		return new Function("jQuery","$item",
			// Use the variable __ to hold a string array while building the compiled template. (See https://github.com/jquery/jquery-tmpl/issues#issue/10).
			"var $=jQuery,call,__=[],$data=$item.data;" +

			// Introduce the data as local variables using with(){}
			"with($data){__.push('" +

			// Convert the template into pure JavaScript
			jQuery.trim(markup)
				.replace( /([\\'])/g, "\\$1" )
				.replace( /[\r\t\n]/g, " " )
				.replace( /\$\{([^\}]*)\}/g, "{{= $1}}" )
				.replace( /\{\{(\/?)(\w+|.)(?:\(((?:[^\}]|\}(?!\}))*?)?\))?(?:\s+(.*?)?)?(\(((?:[^\}]|\}(?!\}))*?)\))?\s*\}\}/g,
				function( all, slash, type, fnargs, target, parens, args ) {
					var tag = jQuery.tmpl.tag[ type ], def, expr, exprAutoFnDetect;
					if ( !tag ) {
						throw "Unknown template tag: " + type;
					}
					def = tag._default || [];
					if ( parens && !/\w$/.test(target)) {
						target += parens;
						parens = "";
					}
					if ( target ) {
						target = unescape( target );
						args = args ? ("," + unescape( args ) + ")") : (parens ? ")" : "");
						// Support for target being things like a.toLowerCase();
						// In that case don't call with template item as 'this' pointer. Just evaluate...
						expr = parens ? (target.indexOf(".") > -1 ? target + unescape( parens ) : ("(" + target + ").call($item" + args)) : target;
						exprAutoFnDetect = parens ? expr : "(typeof(" + target + ")==='function'?(" + target + ").call($item):(" + target + "))";
					} else {
						exprAutoFnDetect = expr = def.$1 || "null";
					}
					fnargs = unescape( fnargs );
					return "');" +
						tag[ slash ? "close" : "open" ]
							.split( "$notnull_1" ).join( target ? "typeof(" + target + ")!=='undefined' && (" + target + ")!=null" : "true" )
							.split( "$1a" ).join( exprAutoFnDetect )
							.split( "$1" ).join( expr )
							.split( "$2" ).join( fnargs || def.$2 || "" ) +
						"__.push('";
				}) +
			"');}return __;"
		);
	}
	function updateWrapped( options, wrapped ) {
		// Build the wrapped content.
		options._wrap = build( options, true,
			// Suport imperative scenario in which options.wrapped can be set to a selector or an HTML string.
			jQuery.isArray( wrapped ) ? wrapped : [htmlExpr.test( wrapped ) ? wrapped : jQuery( wrapped ).html()]
		).join("");
	}

	function unescape( args ) {
		return args ? args.replace( /\\'/g, "'").replace(/\\\\/g, "\\" ) : null;
	}
	function outerHtml( elem ) {
		var div = document.createElement("div");
		div.appendChild( elem.cloneNode(true) );
		return div.innerHTML;
	}

	// Store template items in jQuery.data(), ensuring a unique tmplItem data data structure for each rendered template instance.
	function storeTmplItems( content ) {
		var keySuffix = "_" + cloneIndex, elem, elems, newClonedItems = {}, i, l, m;
		for ( i = 0, l = content.length; i < l; i++ ) {
			if ( (elem = content[i]).nodeType !== 1 ) {
				continue;
			}
			elems = elem.getElementsByTagName("*");
			for ( m = elems.length - 1; m >= 0; m-- ) {
				processItemKey( elems[m] );
			}
			processItemKey( elem );
		}
		function processItemKey( el ) {
			var pntKey, pntNode = el, pntItem, tmplItem, key;
			// Ensure that each rendered template inserted into the DOM has its own template item,
			if ( (key = el.getAttribute( tmplItmAtt ))) {
				while ( pntNode.parentNode && (pntNode = pntNode.parentNode).nodeType === 1 && !(pntKey = pntNode.getAttribute( tmplItmAtt ))) { }
				if ( pntKey !== key ) {
					// The next ancestor with a _tmplitem expando is on a different key than this one.
					// So this is a top-level element within this template item
					// Set pntNode to the key of the parentNode, or to 0 if pntNode.parentNode is null, or pntNode is a fragment.
					pntNode = pntNode.parentNode ? (pntNode.nodeType === 11 ? 0 : (pntNode.getAttribute( tmplItmAtt ) || 0)) : 0;
					if ( !(tmplItem = newTmplItems[key]) ) {
						// The item is for wrapped content, and was copied from the temporary parent wrappedItem.
						tmplItem = wrappedItems[key];
						tmplItem = newTmplItem( tmplItem, newTmplItems[pntNode]||wrappedItems[pntNode] );
						tmplItem.key = ++itemKey;
						newTmplItems[itemKey] = tmplItem;
					}
					if ( cloneIndex ) {
						cloneTmplItem( key );
					}
				}
				el.removeAttribute( tmplItmAtt );
			} else if ( cloneIndex && (tmplItem = jQuery.data( el, "tmplItem" )) ) {
				// This was a rendered element, cloned during append or appendTo etc.
				// TmplItem stored in jQuery data has already been cloned in cloneCopyEvent. We must replace it with a fresh cloned tmplItem.
				cloneTmplItem( tmplItem.key );
				newTmplItems[tmplItem.key] = tmplItem;
				pntNode = jQuery.data( el.parentNode, "tmplItem" );
				pntNode = pntNode ? pntNode.key : 0;
			}
			if ( tmplItem ) {
				pntItem = tmplItem;
				// Find the template item of the parent element.
				// (Using !=, not !==, since pntItem.key is number, and pntNode may be a string)
				while ( pntItem && pntItem.key != pntNode ) {
					// Add this element as a top-level node for this rendered template item, as well as for any
					// ancestor items between this item and the item of its parent element
					pntItem.nodes.push( el );
					pntItem = pntItem.parent;
				}
				// Delete content built during rendering - reduce API surface area and memory use, and avoid exposing of stale data after rendering...
				delete tmplItem._ctnt;
				delete tmplItem._wrap;
				// Store template item as jQuery data on the element
				jQuery.data( el, "tmplItem", tmplItem );
			}
			function cloneTmplItem( key ) {
				key = key + keySuffix;
				tmplItem = newClonedItems[key] =
					(newClonedItems[key] || newTmplItem( tmplItem, newTmplItems[tmplItem.parent.key + keySuffix] || tmplItem.parent ));
			}
		}
	}

	//---- Helper functions for template item ----

	function tiCalls( content, tmpl, data, options ) {
		if ( !content ) {
			return stack.pop();
		}
		stack.push({ _: content, tmpl: tmpl, item:this, data: data, options: options });
	}

	function tiNest( tmpl, data, options ) {
		// nested template, using {{tmpl}} tag
		return jQuery.tmpl( jQuery.template( tmpl ), data, options, this );
	}

	function tiWrap( call, wrapped ) {
		// nested template, using {{wrap}} tag
		var options = call.options || {};
		options.wrapped = wrapped;
		// Apply the template, which may incorporate wrapped content,
		return jQuery.tmpl( jQuery.template( call.tmpl ), call.data, options, call.item );
	}

	function tiHtml( filter, textOnly ) {
		var wrapped = this._wrap;
		return jQuery.map(
			jQuery( jQuery.isArray( wrapped ) ? wrapped.join("") : wrapped ).filter( filter || "*" ),
			function(e) {
				return textOnly ?
					e.innerText || e.textContent :
					e.outerHTML || outerHtml(e);
			});
	}

	function tiUpdate() {
		var coll = this.nodes;
		jQuery.tmpl( null, null, null, this).insertBefore( coll[0] );
		jQuery( coll ).remove();
	}
})( jQuery );
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
      var event_name, _i, _len, _results;
      _results = [];
      for (_i = 0, _len = events_names.length; _i < _len; _i++) {
        event_name = events_names[_i];
        this._ensure_event(event_name);
        _results.push(this.events[event_name].splice(this.events[event_name].indexOf(fn), 1));
      }
      return _results;
    };

    Eventable.prototype.fire_event = function(event_name, e1, e2, e3) {
      var fn, _i, _len, _ref, _results;
      this._ensure_event(event_name);
      _ref = this.events[event_name];
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        fn = _ref[_i];
        _results.push(fn(e1, e2, e3));
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
/**
 * @name InfoBox
 * @version 1.1.11 [January 9, 2012]
 * @author Gary Little (inspired by proof-of-concept code from Pamela Fox of Google)
 * @copyright Copyright 2010 Gary Little [gary at luxcentral.com]
 * @fileoverview InfoBox extends the Google Maps JavaScript API V3 <tt>OverlayView</tt> class.
 *  <p>
 *  An InfoBox behaves like a <tt>google.maps.InfoWindow</tt>, but it supports several
 *  additional properties for advanced styling. An InfoBox can also be used as a map label.
 *  <p>
 *  An InfoBox also fires the same events as a <tt>google.maps.InfoWindow</tt>.
 */

/*!
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *       http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

/*jslint browser:true */
/*global google */

/**
 * @name InfoBoxOptions
 * @class This class represents the optional parameter passed to the {@link InfoBox} constructor.
 * @property {string|Node} content The content of the InfoBox (plain text or an HTML DOM node).
 * @property {boolean} disableAutoPan Disable auto-pan on <tt>open</tt> (default is <tt>false</tt>).
 * @property {number} maxWidth The maximum width (in pixels) of the InfoBox. Set to 0 if no maximum.
 * @property {Size} pixelOffset The offset (in pixels) from the top left corner of the InfoBox
 *  (or the bottom left corner if the <code>alignBottom</code> property is <code>true</code>)
 *  to the map pixel corresponding to <tt>position</tt>.
 * @property {LatLng} position The geographic location at which to display the InfoBox.
 * @property {number} zIndex The CSS z-index style value for the InfoBox.
 *  Note: This value overrides a zIndex setting specified in the <tt>boxStyle</tt> property.
 * @property {string} boxClass The name of the CSS class defining the styles for the InfoBox container.
 *  The default name is <code>infoBox</code>.
 * @property {Object} [boxStyle] An object literal whose properties define specific CSS
 *  style values to be applied to the InfoBox. Style values defined here override those that may
 *  be defined in the <code>boxClass</code> style sheet. If this property is changed after the
 *  InfoBox has been created, all previously set styles (except those defined in the style sheet)
 *  are removed from the InfoBox before the new style values are applied.
 * @property {string} closeBoxMargin The CSS margin style value for the close box.
 *  The default is "2px" (a 2-pixel margin on all sides).
 * @property {string} closeBoxURL The URL of the image representing the close box.
 *  Note: The default is the URL for Google's standard close box.
 *  Set this property to "" if no close box is required.
 * @property {Size} infoBoxClearance Minimum offset (in pixels) from the InfoBox to the
 *  map edge after an auto-pan.
 * @property {boolean} isHidden Hide the InfoBox on <tt>open</tt> (default is <tt>false</tt>).
 * @property {boolean} alignBottom Align the bottom left corner of the InfoBox to the <code>position</code>
 *  location (default is <tt>false</tt> which means that the top left corner of the InfoBox is aligned).
 * @property {string} pane The pane where the InfoBox is to appear (default is "floatPane").
 *  Set the pane to "mapPane" if the InfoBox is being used as a map label.
 *  Valid pane names are the property names for the <tt>google.maps.MapPanes</tt> object.
 * @property {boolean} enableEventPropagation Propagate mousedown, mousemove, mouseover, mouseout,
 *  mouseup, click, dblclick, touchstart, touchend, touchmove, and contextmenu events in the InfoBox
 *  (default is <tt>false</tt> to mimic the behavior of a <tt>google.maps.InfoWindow</tt>). Set
 *  this property to <tt>true</tt> if the InfoBox is being used as a map label.
 */

/**
 * Creates an InfoBox with the options specified in {@link InfoBoxOptions}.
 *  Call <tt>InfoBox.open</tt> to add the box to the map.
 * @constructor
 * @param {InfoBoxOptions} [opt_opts]
 */

function InfoBox(opt_opts) {

  opt_opts = opt_opts || {};

  google.maps.OverlayView.apply(this, arguments);

  // Standard options (in common with google.maps.InfoWindow):
  //
  this.content_ = opt_opts.content || "";
  this.disableAutoPan_ = opt_opts.disableAutoPan || false;
  this.maxWidth_ = opt_opts.maxWidth || 0;
  this.pixelOffset_ = opt_opts.pixelOffset || new google.maps.Size(0, 0);
  this.position_ = opt_opts.position || new google.maps.LatLng(0, 0);
  this.zIndex_ = opt_opts.zIndex || null;

  // Additional options (unique to InfoBox):
  //
  this.boxClass_ = opt_opts.boxClass || "infoBox";
  this.boxStyle_ = opt_opts.boxStyle || {};
  this.closeBoxMargin_ = opt_opts.closeBoxMargin || "2px";
  this.closeBoxURL_ = opt_opts.closeBoxURL || "http://www.google.com/intl/en_us/mapfiles/close.gif";
  if (opt_opts.closeBoxURL === "") {
    this.closeBoxURL_ = "";
  }
  this.infoBoxClearance_ = opt_opts.infoBoxClearance || new google.maps.Size(1, 1);
  this.isHidden_ = opt_opts.isHidden || false;
  this.alignBottom_ = opt_opts.alignBottom || false;
  this.pane_ = opt_opts.pane || "floatPane";
  this.enableEventPropagation_ = opt_opts.enableEventPropagation || false;

  this.div_ = null;
  this.closeListener_ = null;
  this.moveListener_ = null;
  this.contextListener_ = null;
  this.eventListeners_ = null;
  this.fixedWidthSet_ = null;
}

/* InfoBox extends OverlayView in the Google Maps API v3.
 */
InfoBox.prototype = new google.maps.OverlayView();

/**
 * Creates the DIV representing the InfoBox.
 * @private
 */
InfoBox.prototype.createInfoBoxDiv_ = function () {

  var i;
  var events;
  var bw;
  var me = this;

  // This handler prevents an event in the InfoBox from being passed on to the map.
  //
  var cancelHandler = function (e) {
    e.cancelBubble = true;
    if (e.stopPropagation) {
      e.stopPropagation();
    }
  };

  // This handler ignores the current event in the InfoBox and conditionally prevents
  // the event from being passed on to the map. It is used for the contextmenu event.
  //
  var ignoreHandler = function (e) {

    e.returnValue = false;

    if (e.preventDefault) {

      e.preventDefault();
    }

    if (!me.enableEventPropagation_) {

      cancelHandler(e);
    }
  };

  if (!this.div_) {

    this.div_ = document.createElement("div");

    this.setBoxStyle_();

    if (typeof this.content_.nodeType === "undefined") {
      this.div_.innerHTML = this.getCloseBoxImg_() + this.content_;
    } else {
      this.div_.innerHTML = this.getCloseBoxImg_();
      this.div_.appendChild(this.content_);
    }

    // Add the InfoBox DIV to the DOM
    this.getPanes()[this.pane_].appendChild(this.div_);

    this.addClickHandler_();

    if (this.div_.style.width) {

      this.fixedWidthSet_ = true;

    } else {

      if (this.maxWidth_ !== 0 && this.div_.offsetWidth > this.maxWidth_) {

        this.div_.style.width = this.maxWidth_;
        this.div_.style.overflow = "auto";
        this.fixedWidthSet_ = true;

      } else { // The following code is needed to overcome problems with MSIE

        bw = this.getBoxWidths_();

        this.div_.style.width = (this.div_.offsetWidth - bw.left - bw.right) + "px";
        this.fixedWidthSet_ = false;
      }
    }

    this.panBox_(this.disableAutoPan_);

    if (!this.enableEventPropagation_) {

      this.eventListeners_ = [];

      // Cancel event propagation.
      //
      // Note: mousemove not included (to resolve Issue 152)
      events = ["mousedown", "mouseover", "mouseout", "mouseup",
      "click", "dblclick", "touchstart", "touchend", "touchmove"];

      for (i = 0; i < events.length; i++) {

        this.eventListeners_.push(google.maps.event.addDomListener(this.div_, events[i], cancelHandler));
      }

      // Workaround for Google bug that causes the cursor to change to a pointer
      // when the mouse moves over a marker underneath InfoBox.
      this.eventListeners_.push(google.maps.event.addDomListener(this.div_, "mouseover", function (e) {
        this.style.cursor = "default";
      }));
    }

    this.contextListener_ = google.maps.event.addDomListener(this.div_, "contextmenu", ignoreHandler);

    /**
     * This event is fired when the DIV containing the InfoBox's content is attached to the DOM.
     * @name InfoBox#domready
     * @event
     */
    google.maps.event.trigger(this, "domready");
  }
};

/**
 * Returns the HTML <IMG> tag for the close box.
 * @private
 */
InfoBox.prototype.getCloseBoxImg_ = function () {

  var img = "";

  if (this.closeBoxURL_ !== "") {

    img  = "<img";
    img += " src='" + this.closeBoxURL_ + "'";
    img += " align=right"; // Do this because Opera chokes on style='float: right;'
    img += " style='";
    img += " position: relative;"; // Required by MSIE
    img += " cursor: pointer;";
    img += " margin: " + this.closeBoxMargin_ + ";";
    img += "'>";
  }

  return img;
};

/**
 * Adds the click handler to the InfoBox close box.
 * @private
 */
InfoBox.prototype.addClickHandler_ = function () {

  var closeBox;

  if (this.closeBoxURL_ !== "") {

    closeBox = this.div_.firstChild;
    this.closeListener_ = google.maps.event.addDomListener(closeBox, 'click', this.getCloseClickHandler_());

  } else {

    this.closeListener_ = null;
  }
};

/**
 * Returns the function to call when the user clicks the close box of an InfoBox.
 * @private
 */
InfoBox.prototype.getCloseClickHandler_ = function () {

  var me = this;

  return function (e) {

    // 1.0.3 fix: Always prevent propagation of a close box click to the map:
    e.cancelBubble = true;

    if (e.stopPropagation) {

      e.stopPropagation();
    }

    /**
     * This event is fired when the InfoBox's close box is clicked.
     * @name InfoBox#closeclick
     * @event
     */
    google.maps.event.trigger(me, "closeclick");

    me.close();
  };
};

/**
 * Pans the map so that the InfoBox appears entirely within the map's visible area.
 * @private
 */
InfoBox.prototype.panBox_ = function (disablePan) {

  var map;
  var bounds;
  var xOffset = 0, yOffset = 0;

  if (!disablePan) {

    map = this.getMap();

    if (map instanceof google.maps.Map) { // Only pan if attached to map, not panorama

      if (!map.getBounds().contains(this.position_)) {
      // Marker not in visible area of map, so set center
      // of map to the marker position first.
        map.setCenter(this.position_);
      }

      bounds = map.getBounds();

      var mapDiv = map.getDiv();
      var mapWidth = mapDiv.offsetWidth;
      var mapHeight = mapDiv.offsetHeight;
      var iwOffsetX = this.pixelOffset_.width;
      var iwOffsetY = this.pixelOffset_.height;
      var iwWidth = this.div_.offsetWidth;
      var iwHeight = this.div_.offsetHeight;
      var padX = this.infoBoxClearance_.width;
      var padY = this.infoBoxClearance_.height;
      var pixPosition = this.getProjection().fromLatLngToContainerPixel(this.position_);

      if (pixPosition.x < (-iwOffsetX + padX)) {
        xOffset = pixPosition.x + iwOffsetX - padX;
      } else if ((pixPosition.x + iwWidth + iwOffsetX + padX) > mapWidth) {
        xOffset = pixPosition.x + iwWidth + iwOffsetX + padX - mapWidth;
      }
      if (this.alignBottom_) {
        if (pixPosition.y < (-iwOffsetY + padY + iwHeight)) {
          yOffset = pixPosition.y + iwOffsetY - padY - iwHeight;
        } else if ((pixPosition.y + iwOffsetY + padY) > mapHeight) {
          yOffset = pixPosition.y + iwOffsetY + padY - mapHeight;
        }
      } else {
        if (pixPosition.y < (-iwOffsetY + padY)) {
          yOffset = pixPosition.y + iwOffsetY - padY;
        } else if ((pixPosition.y + iwHeight + iwOffsetY + padY) > mapHeight) {
          yOffset = pixPosition.y + iwHeight + iwOffsetY + padY - mapHeight;
        }
      }

      if (!(xOffset === 0 && yOffset === 0)) {

        // Move the map to the shifted center.
        //
        var c = map.getCenter();
        map.panBy(xOffset, yOffset);
      }
    }
  }
};

/**
 * Sets the style of the InfoBox by setting the style sheet and applying
 * other specific styles requested.
 * @private
 */
InfoBox.prototype.setBoxStyle_ = function () {

  var i, boxStyle;

  if (this.div_) {

    // Apply style values from the style sheet defined in the boxClass parameter:
    this.div_.className = this.boxClass_;

    // Clear existing inline style values:
    this.div_.style.cssText = "";

    // Apply style values defined in the boxStyle parameter:
    boxStyle = this.boxStyle_;
    for (i in boxStyle) {

      if (boxStyle.hasOwnProperty(i)) {

        this.div_.style[i] = boxStyle[i];
      }
    }

    // Fix up opacity style for benefit of MSIE:
    //
    if (typeof this.div_.style.opacity !== "undefined" && this.div_.style.opacity !== "") {

      this.div_.style.filter = "alpha(opacity=" + (this.div_.style.opacity * 100) + ")";
    }

    // Apply required styles:
    //
    this.div_.style.position = "absolute";
    this.div_.style.visibility = 'hidden';
    if (this.zIndex_ !== null) {

      this.div_.style.zIndex = this.zIndex_;
    }
  }
};

/**
 * Get the widths of the borders of the InfoBox.
 * @private
 * @return {Object} widths object (top, bottom left, right)
 */
InfoBox.prototype.getBoxWidths_ = function () {

  var computedStyle;
  var bw = {top: 0, bottom: 0, left: 0, right: 0};
  var box = this.div_;

  if (document.defaultView && document.defaultView.getComputedStyle) {

    computedStyle = box.ownerDocument.defaultView.getComputedStyle(box, "");

    if (computedStyle) {

      // The computed styles are always in pixel units (good!)
      bw.top = parseInt(computedStyle.borderTopWidth, 10) || 0;
      bw.bottom = parseInt(computedStyle.borderBottomWidth, 10) || 0;
      bw.left = parseInt(computedStyle.borderLeftWidth, 10) || 0;
      bw.right = parseInt(computedStyle.borderRightWidth, 10) || 0;
    }

  } else if (document.documentElement.currentStyle) { // MSIE

    if (box.currentStyle) {

      // The current styles may not be in pixel units, but assume they are (bad!)
      bw.top = parseInt(box.currentStyle.borderTopWidth, 10) || 0;
      bw.bottom = parseInt(box.currentStyle.borderBottomWidth, 10) || 0;
      bw.left = parseInt(box.currentStyle.borderLeftWidth, 10) || 0;
      bw.right = parseInt(box.currentStyle.borderRightWidth, 10) || 0;
    }
  }

  return bw;
};

/**
 * Invoked when <tt>close</tt> is called. Do not call it directly.
 */
InfoBox.prototype.onRemove = function () {

  if (this.div_) {

    this.div_.parentNode.removeChild(this.div_);
    this.div_ = null;
  }
};

/**
 * Draws the InfoBox based on the current map projection and zoom level.
 */
InfoBox.prototype.draw = function () {

  this.createInfoBoxDiv_();

  var pixPosition = this.getProjection().fromLatLngToDivPixel(this.position_);

  this.div_.style.left = (pixPosition.x + this.pixelOffset_.width) + "px";

  if (this.alignBottom_) {
    this.div_.style.bottom = -(pixPosition.y + this.pixelOffset_.height) + "px";
  } else {
    this.div_.style.top = (pixPosition.y + this.pixelOffset_.height) + "px";
  }

  if (this.isHidden_) {

    this.div_.style.visibility = 'hidden';

  } else {

    this.div_.style.visibility = "visible";
  }
};

/**
 * Sets the options for the InfoBox. Note that changes to the <tt>maxWidth</tt>,
 *  <tt>closeBoxMargin</tt>, <tt>closeBoxURL</tt>, and <tt>enableEventPropagation</tt>
 *  properties have no affect until the current InfoBox is <tt>close</tt>d and a new one
 *  is <tt>open</tt>ed.
 * @param {InfoBoxOptions} opt_opts
 */
InfoBox.prototype.setOptions = function (opt_opts) {
  if (typeof opt_opts.boxClass !== "undefined") { // Must be first

    this.boxClass_ = opt_opts.boxClass;
    this.setBoxStyle_();
  }
  if (typeof opt_opts.boxStyle !== "undefined") { // Must be second

    this.boxStyle_ = opt_opts.boxStyle;
    this.setBoxStyle_();
  }
  if (typeof opt_opts.content !== "undefined") {

    this.setContent(opt_opts.content);
  }
  if (typeof opt_opts.disableAutoPan !== "undefined") {

    this.disableAutoPan_ = opt_opts.disableAutoPan;
  }
  if (typeof opt_opts.maxWidth !== "undefined") {

    this.maxWidth_ = opt_opts.maxWidth;
  }
  if (typeof opt_opts.pixelOffset !== "undefined") {

    this.pixelOffset_ = opt_opts.pixelOffset;
  }
  if (typeof opt_opts.alignBottom !== "undefined") {

    this.alignBottom_ = opt_opts.alignBottom;
  }
  if (typeof opt_opts.position !== "undefined") {

    this.setPosition(opt_opts.position);
  }
  if (typeof opt_opts.zIndex !== "undefined") {

    this.setZIndex(opt_opts.zIndex);
  }
  if (typeof opt_opts.closeBoxMargin !== "undefined") {

    this.closeBoxMargin_ = opt_opts.closeBoxMargin;
  }
  if (typeof opt_opts.closeBoxURL !== "undefined") {

    this.closeBoxURL_ = opt_opts.closeBoxURL;
  }
  if (typeof opt_opts.infoBoxClearance !== "undefined") {

    this.infoBoxClearance_ = opt_opts.infoBoxClearance;
  }
  if (typeof opt_opts.isHidden !== "undefined") {

    this.isHidden_ = opt_opts.isHidden;
  }
  if (typeof opt_opts.enableEventPropagation !== "undefined") {

    this.enableEventPropagation_ = opt_opts.enableEventPropagation;
  }

  if (this.div_) {

    this.draw();
  }
};

/**
 * Sets the content of the InfoBox.
 *  The content can be plain text or an HTML DOM node.
 * @param {string|Node} content
 */
InfoBox.prototype.setContent = function (content) {
  this.content_ = content;

  if (this.div_) {

    if (this.closeListener_) {

      google.maps.event.removeListener(this.closeListener_);
      this.closeListener_ = null;
    }

    // Odd code required to make things work with MSIE.
    //
    if (!this.fixedWidthSet_) {

      this.div_.style.width = "";
    }

    if (typeof content.nodeType === "undefined") {
      this.div_.innerHTML = this.getCloseBoxImg_() + content;
    } else {
      this.div_.innerHTML = this.getCloseBoxImg_();
      this.div_.appendChild(content);
    }

    // Perverse code required to make things work with MSIE.
    // (Ensures the close box does, in fact, float to the right.)
    //
    if (!this.fixedWidthSet_) {
      this.div_.style.width = this.div_.offsetWidth + "px";
      if (typeof content.nodeType === "undefined") {
        this.div_.innerHTML = this.getCloseBoxImg_() + content;
      } else {
        this.div_.innerHTML = this.getCloseBoxImg_();
        this.div_.appendChild(content);
      }
    }

    this.addClickHandler_();
  }

  /**
   * This event is fired when the content of the InfoBox changes.
   * @name InfoBox#content_changed
   * @event
   */
  google.maps.event.trigger(this, "content_changed");
};

/**
 * Sets the geographic location of the InfoBox.
 * @param {LatLng} latlng
 */
InfoBox.prototype.setPosition = function (latlng) {

  this.position_ = latlng;

  if (this.div_) {

    this.draw();
  }

  /**
   * This event is fired when the position of the InfoBox changes.
   * @name InfoBox#position_changed
   * @event
   */
  google.maps.event.trigger(this, "position_changed");
};

/**
 * Sets the zIndex style for the InfoBox.
 * @param {number} index
 */
InfoBox.prototype.setZIndex = function (index) {

  this.zIndex_ = index;

  if (this.div_) {

    this.div_.style.zIndex = index;
  }

  /**
   * This event is fired when the zIndex of the InfoBox changes.
   * @name InfoBox#zindex_changed
   * @event
   */
  google.maps.event.trigger(this, "zindex_changed");
};

/**
 * Returns the content of the InfoBox.
 * @returns {string}
 */
InfoBox.prototype.getContent = function () {

  return this.content_;
};

/**
 * Returns the geographic location of the InfoBox.
 * @returns {LatLng}
 */
InfoBox.prototype.getPosition = function () {

  return this.position_;
};

/**
 * Returns the zIndex for the InfoBox.
 * @returns {number}
 */
InfoBox.prototype.getZIndex = function () {

  return this.zIndex_;
};

/**
 * Shows the InfoBox.
 */
InfoBox.prototype.show = function () {

  this.isHidden_ = false;
  if (this.div_) {
    this.div_.style.visibility = "visible";
  }
};

/**
 * Hides the InfoBox.
 */
InfoBox.prototype.hide = function () {

  this.isHidden_ = true;
  if (this.div_) {
    this.div_.style.visibility = "hidden";
  }
};

/**
 * Adds the InfoBox to the specified map or Street View panorama. If <tt>anchor</tt>
 *  (usually a <tt>google.maps.Marker</tt>) is specified, the position
 *  of the InfoBox is set to the position of the <tt>anchor</tt>. If the
 *  anchor is dragged to a new location, the InfoBox moves as well.
 * @param {Map|StreetViewPanorama} map
 * @param {MVCObject} [anchor]
 */
InfoBox.prototype.open = function (map, anchor) {

  var me = this;

  if (anchor) {

    this.position_ = anchor.getPosition();
    this.moveListener_ = google.maps.event.addListener(anchor, "position_changed", function () {
      me.setPosition(this.getPosition());
    });
  }

  this.setMap(map);

  if (this.div_) {

    this.panBox_();
  }
};

/**
 * Removes the InfoBox from the map.
 */
InfoBox.prototype.close = function () {

  var i;

  if (this.closeListener_) {

    google.maps.event.removeListener(this.closeListener_);
    this.closeListener_ = null;
  }

  if (this.eventListeners_) {

    for (i = 0; i < this.eventListeners_.length; i++) {

      google.maps.event.removeListener(this.eventListeners_[i]);
    }
    this.eventListeners_ = null;
  }

  if (this.moveListener_) {

    google.maps.event.removeListener(this.moveListener_);
    this.moveListener_ = null;
  }

  if (this.contextListener_) {

    google.maps.event.removeListener(this.contextListener_);
    this.contextListener_ = null;
  }

  this.setMap(null);
};

/**
 * Returns true. Because it gets called, is just a hotfix.
 */
InfoBox.prototype.remove = function () {
  return true
};
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
          "hc": this.build_gmap,
          "fh": this.map_settings,
          "c": this.build_gmap
        }, {
          "dc": this.calculate_center,
          "bb": this.calculate_center,
          "gf": this.build_gmap
        }, {
          "ce": this.calculate_center,
          "gh": this.calculate_center,
          "ii": this.calculate_center
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
var AdminCity = {};
(function() {

  AdminCity.AddressFetcher = (function() {

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
      var options,
        _this = this;
      this.fetching = true;
      console.log("Fetching...", address);
      options = this.options(address);
      console.log($.param(options));
      console.log("Options", options);
      return this.geocoder.geocode(options, function(results, status) {
        var result;
        console.log(results);
        _this.fetching = false;
        _this.last_fetch_time = _this.time();
        if (status === 'OK') {
          console.log("Success!");
          result = _this.parse_results(results);
          return callback(result[0], result[1]);
        } else {
          console.log("FAILED!", status);
          return callback(false, false);
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

    AddressFetcher.prototype.parse_results = function(results) {
      var approximated, location, partial_match, result;
      result = results[0];
      console.log("Gathering results from, ", result);
      approximated = result.geometry.location_type === "APPROXIMATE";
      partial_match = !!result.partial_match;
      location = result.geometry.location;
      return [location, !(approximated || partial_match)];
    };

    return AddressFetcher;

  })();

}).call(this);
(function() {

  AdminCity.Builder = (function() {

    function Builder(data, element) {
      this.data = data;
      this.element = element != null ? element : $$("map");
      this.build_map();
      this.build_fetcher();
    }

    Builder.prototype.build_map = function() {
      this.map = new MapTools.Map(this.element, this.data['viewport']);
      return this.gmap = this.map.gmap;
    };

    Builder.prototype.build_fetcher = function() {
      return this.fetcher = new AdminCity.AddressFetcher(this.data["name"], this.data["country"], this.data["region_tag"]);
    };

    Builder.prototype.fetch_address = function(address, callback) {
      return this.fetcher.fetch(address, callback);
    };

    return Builder;

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
var SellLocationsEditor = {};
(function() {
  var __hasProp = Object.prototype.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor; child.__super__ = parent.prototype; return child; };

  SellLocationsEditor.FormElement = (function(_super) {

    __extends(FormElement, _super);

    function FormElement(data, template, number) {
      this.data = data;
      this.template = template;
      this.number = number;
      this.build_elements();
      this.build_inputs();
      this.fill_element();
      this.replace_name();
      this.bind_elements();
    }

    FormElement.prototype.build_elements = function() {
      this.element = this.template.clone();
      return this.close = this.element.find('.remove');
    };

    FormElement.prototype.build_inputs = function() {
      var input, inputs, name, value, _ref, _results;
      inputs = this.element.find(':input');
      this.all_inputs = inputs;
      this.inputs = {};
      this.data._destroy = false;
      _ref = this.data;
      _results = [];
      for (name in _ref) {
        value = _ref[name];
        input = inputs.filter("[name*='" + name + "']").last();
        if (input.length > 0) {
          _results.push(this.inputs[name] = input);
        } else {
          _results.push(void 0);
        }
      }
      return _results;
    };

    FormElement.prototype.fill_element = function() {
      var i, val, _ref, _results;
      _ref = this.data;
      _results = [];
      for (i in _ref) {
        val = _ref[i];
        _results.push(this.fill_input(i, val));
      }
      return _results;
    };

    FormElement.prototype.replace_name = function() {
      var _this = this;
      return this.all_inputs.each(function(i, input) {
        return input.name = input.name.replace('[0]', "[" + _this.number + "]");
      });
    };

    FormElement.prototype.fill_input = function(name, value) {
      var input;
      input = this.inputs[name];
      if (input.prop('type') === 'checkbox') {
        input.prop('checked', value);
      } else {
        if (input.prop('tagName') === 'SELECT') {
          if (typeof value === "boolean") {
            if (value) {
              value = 1;
            } else {
              value = 0;
            }
          }
        }
        input.val(value);
      }
      return this.data[name] = value;
    };

    FormElement.prototype.gather_input = function(name) {
      var input, value;
      input = this.inputs[name];
      if (input.prop('type') === 'checkbox') {
        value = input.is(':checked');
      } else {
        value = $(input).val();
      }
      return this.data[name] = value;
    };

    FormElement.prototype.bind_elements = function() {
      var _this = this;
      this.all_inputs.keypress(function(e) {
        if (e.charCode === 13) {
          e.preventDefault();
          return _this.fire_event('enter', _this.inheritable_data());
        }
      });
      this.all_inputs.focus(function(e) {
        return _this.fire_event('focus');
      });
      this.all_inputs.change(function(e) {
        var data_name;
        data_name = e.target.name.match(/\[([^[]+)\]$/)[1];
        _this.gather_input(data_name);
        return _this.fire_event('change');
      });
      this.inputs.address.change(function(e) {
        return _this.fire_event('address_change');
      });
      return this.close.click(function() {
        return _this.fire_event('remove');
      });
    };

    FormElement.prototype.append_to = function(parent) {
      parent.append(this.element);
      return this.inputs.address.focus();
    };

    FormElement.prototype.remove = function() {
      if (!this.data.id) {
        return this.element.remove();
      } else {
        this.inputs._destroy.val(true);
        return this.element.hide();
      }
    };

    FormElement.prototype.address_val = function() {
      return this.inputs.address.val();
    };

    FormElement.prototype.set_latlng = function(latlng) {
      this.fill_input('lat', latlng.lat());
      return this.fill_input('lng', latlng.lng());
    };

    FormElement.prototype.set_manual_position = function(boolean) {
      return this.fill_input('manual_position', boolean);
    };

    FormElement.prototype.focus = function() {
      return this.inputs.address.focus();
    };

    FormElement.prototype.inheritable_data = function() {
      return {
        card_selling: this.data.card_selling,
        card_reloading: this.data.card_reloading,
        ticket_selling: this.data.ticket_selling
      };
    };

    return FormElement;

  })(Utils.Eventable);

}).call(this);
(function() {

  $(function() {
    if ($(document["body"]).is('.edit_sell_locations')) {
      return new SellLocationsEditor.Manager(window["sell_locations_editor_data"]);
    }
  });

}).call(this);
(function() {

  SellLocationsEditor.Manager = (function() {

    Manager.prototype.sell_locations = [];

    Manager.prototype.number = 0;

    function Manager(city_data) {
      this.city_data = city_data;
      this.find_elements();
      this.parse_template();
      this.build_city();
      this.build_sell_locations();
    }

    Manager.prototype.find_elements = function() {
      this.map = $$('map');
      this.form_template = $$("sell_location_template");
      return this.container = $$("sell_locations_container");
    };

    Manager.prototype.parse_template = function() {
      this.form_template.remove();
      this.form_template.removeAttr('id');
      return this.form_template.find(':input').removeAttr('id');
    };

    Manager.prototype.build_city = function() {
      return this.city = new AdminCity.Builder(this.city_data, this.map);
    };

    Manager.prototype.build_sell_locations = function() {
      var i, sell_location_data, _ref, _results;
      if (this.city_data.sell_locations.length > 0) {
        _ref = this.city_data.sell_locations;
        _results = [];
        for (i in _ref) {
          sell_location_data = _ref[i];
          _results.push(this.build_sell_location(sell_location_data, i));
        }
        return _results;
      } else {
        return this.build_sell_location();
      }
    };

    Manager.prototype.build_sell_location = function(data) {
      var sell_location;
      if (data == null) data = false;
      sell_location = new SellLocationsEditor.SellLocation(data, this.form_template, this.city, this.number++);
      sell_location.append_to(this.container);
      this.sell_locations.push(sell_location);
      return this.bind_sell_location(sell_location);
    };

    Manager.prototype.bind_sell_location = function(sell_location) {
      var _this = this;
      sell_location.add_listener('enter', function(data) {
        return _this.build_sell_location(data);
      });
      sell_location.add_listener('remove', function() {
        return _this.remove_sell_location(sell_location);
      });
      return sell_location.add_listener('focus', function(focused_sell_location) {
        var sell_location, _i, _len, _ref, _results;
        _ref = _this.sell_locations;
        _results = [];
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          sell_location = _ref[_i];
          if (sell_location === focused_sell_location) {
            if (!sell_location.highlighted) {
              _results.push(sell_location.highlight());
            } else {
              _results.push(void 0);
            }
          } else {
            _results.push(sell_location.unhighlight());
          }
        }
        return _results;
      });
    };

    Manager.prototype.remove_sell_location = function(sell_location) {
      this.sell_locations.splice(this.sell_locations.indexOf(sell_location), 1);
      return sell_location.remove();
    };

    return Manager;

  })();

}).call(this);
(function() {
  var __hasProp = Object.prototype.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor; child.__super__ = parent.prototype; return child; };

  SellLocationsEditor.Marker = (function(_super) {

    __extends(Marker, _super);

    function Marker(gmap, latlng) {
      this.gmap = gmap;
      this.latlng = latlng;
      this.add_to_map();
      this.bind_marker();
    }

    Marker.prototype.add_to_map = function() {
      return this.marker = new $G.Marker(this.options());
    };

    Marker.prototype.options = function() {
      return {
        map: this.gmap,
        draggable: true,
        position: this.latlng,
        flat: true,
        cursor: "default",
        icon: this.blue_icon(),
        raiseOnDrag: false
      };
    };

    Marker.prototype.bind_marker = function() {
      var _this = this;
      $G.event.addListener(this.marker, 'dragend', function(latlng) {
        return _this.fire_event('change', latlng.latLng);
      });
      return $G.event.addListener(this.marker, 'click', function() {
        return _this.fire_event('select');
      });
    };

    Marker.prototype.highlight = function() {
      return this.marker.setIcon(this.red_icon());
    };

    Marker.prototype.unhighlight = function() {
      return this.marker.setIcon(this.blue_icon());
    };

    Marker.prototype.set_latlng = function(latlng) {
      this.latlng = latlng;
      return this.marker.setPosition(this.latlng);
    };

    Marker.prototype.remove = function() {
      return this.marker.setMap(null);
    };

    Marker.prototype.red_icon = function() {
      var _base;
      return (_base = SellLocationsEditor.Marker).red_icon || (_base.red_icon = new $G.MarkerImage("http://chart.apis.google.com/chart?chst=d_map_pin_letter&chld=%E2%80%A2|FF0000", new $G.Size(21, 34), new $G.Point(0, 0), new $G.Point(10, 34)));
    };

    Marker.prototype.blue_icon = function() {
      var _base;
      return (_base = SellLocationsEditor.Marker).blue_icon || (_base.blue_icon = new $G.MarkerImage("http://chart.apis.google.com/chart?chst=d_map_pin_letter&chld=%E2%80%A2|0000FF", new $G.Size(21, 34), new $G.Point(0, 0), new $G.Point(10, 34)));
    };

    return Marker;

  })(Utils.Eventable);

}).call(this);
(function() {
  var __hasProp = Object.prototype.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor; child.__super__ = parent.prototype; return child; };

  SellLocationsEditor.SellLocation = (function(_super) {

    __extends(SellLocation, _super);

    function SellLocation(data, template, city, number) {
      this.template = template;
      this.city = city;
      this.number = number;
      this.highlighted = false;
      this.data = _.extend({
        id: null,
        address: '',
        name: '',
        info: '',
        lat: 0,
        lng: 0,
        card_selling: null,
        card_reloading: null,
        ticket_selling: null,
        visibility: true,
        inexact: false,
        manual_position: false
      }, data);
      this.build_form_element();
      this.bind_form_element();
      this.create_marker();
    }

    SellLocation.prototype.build_form_element = function() {
      return this.form_element = new SellLocationsEditor.FormElement(this.data, this.template, this.number);
    };

    SellLocation.prototype.bind_form_element = function() {
      var _this = this;
      this.inherit_listener(this.form_element, 'remove');
      this.form_element.add_listener('enter', function(e) {
        return _this.fire_event('enter', e);
      });
      this.form_element.add_listener('focus', function() {
        return _this.fire_event('focus', _this);
      });
      return this.form_element.add_listener('address_change', function() {
        if (!_this.form_element.data.manual_position) return _this.fetch_address();
      });
    };

    SellLocation.prototype.create_marker = function(latlng) {
      latlng = new $G.LatLng(this.data.lat, this.data.lng);
      this.marker = new SellLocationsEditor.Marker(this.city.gmap, latlng);
      return this.bind_marker();
    };

    SellLocation.prototype.bind_marker = function() {
      var _this = this;
      this.marker.add_listener('change', function(latlng) {
        return _this.update_from_dragging(latlng);
      });
      return this.marker.add_listener('select', function() {
        console.log('click');
        return _this.form_element.focus();
      });
    };

    SellLocation.prototype.append_to = function(parent) {
      return this.form_element.append_to(parent);
    };

    SellLocation.prototype.remove = function() {
      this.form_element.remove();
      return this.marker.remove();
    };

    SellLocation.prototype.highlight = function() {
      this.highlighted = true;
      return this.marker.highlight();
    };

    SellLocation.prototype.unhighlight = function() {
      this.highlighted = false;
      return this.marker.unhighlight();
    };

    SellLocation.prototype.fetch_address = function() {
      var value,
        _this = this;
      value = this.google_api_bug_workaround(this.form_element.address_val());
      return this.city.fetch_address(value, function(latlng, partial_match) {
        _this.update_from_fetching(latlng);
        return _this.update_marker(latlng);
      });
    };

    SellLocation.prototype.update_from_fetching = function(latlng) {
      return this.update_form_latlng(latlng);
    };

    SellLocation.prototype.update_from_dragging = function(latlng) {
      this.form_element.set_manual_position(true);
      return this.update_form_latlng(latlng);
    };

    SellLocation.prototype.update_form_latlng = function(latlng) {
      return this.form_element.set_latlng(latlng);
    };

    SellLocation.prototype.update_marker = function(latlng) {
      return this.marker.set_latlng(latlng);
    };

    SellLocation.prototype.google_api_bug_workaround = function(fetch_address) {
      var do_work_around, number, trigger_key;
      trigger_key = '+';
      do_work_around = fetch_address[fetch_address.length - 1] === trigger_key;
      console.log(do_work_around);
      if (do_work_around) {
        fetch_address = fetch_address.replace(/.$/, '');
        number = fetch_address.match(/[0-9]+[^0-9]*$/);
        number = parseInt(number);
        ++number;
        fetch_address = fetch_address.replace(/[0-9]+[^0-9]*$/, number);
      }
      return fetch_address;
    };

    return SellLocation;

  })(Utils.Eventable);

}).call(this);
// CLOSURE_COMPILER_SKIP_FILE





      

true;
