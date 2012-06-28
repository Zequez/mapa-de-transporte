//= require_self
//= require ./mdc/settings
//= require ./mdc/interface
//= require ./mdc/interface/toggleable
//= require_tree ./mdc

// Declaring this in JavaScript we avoid to have to
// declare it in the window variable. This is because
// CoffeeScript uses a modularization in each file, and
// every variable declared is local.
// Doing it this way allows us to have to call window.MDC
// each time we want to call MDC. We COULD do it without calling
// window.MDC, but compressors won't detect it very well and
// will probably mess it up. At least it happens in the advanced
// settings in the ClosureCompiler.
var MDC = {};