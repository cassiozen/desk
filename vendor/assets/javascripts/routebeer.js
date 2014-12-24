// Data
var _data = {
  'currentPath'  : null,
  'currentRoute' : null,
  'lastRoute'    : null
};

// Options
var options = {
  'routes'   : {},
  'always'   : function(route) { }, // runs before every route load
  'notFound' : function(route) { }, // runs if route is not found in user defined routes
  'root'     : null,
  'event'    : null
}

/**
 * Returns current path (window)
 * - Replaces string root in path (if exists)
 */
var _getCurrentPath = function(root){
  var url  = liteURL(window.location.href);
  var path = url.pathname;
  return (!root) ? path : path.replace(root, '');
}

/**
 * Navigates a route
 * - Fires unload of previous route (if exists) and load of current route
 */
var _navigate = function(){
  _data.lastRoute    = _data.currentRoute;
  _data.currentRoute = null; // reset current route
  _data.currentPath  = _getCurrentPath(options.root); // get current path

  Object.keys(options.routes).some(function(key) { // loop through routes until we find a match
    var routeToMatch = pattern(options.routes[key].pattern);
    var routeParams  = routeToMatch(_data.currentPath);
    if(routeParams){ // if params exist, we've got a match
      _data.currentRoute = {
        'name'   : key,
        'params' : routeParams
      }
      return true; // exit some
    }
  });

  if(_data.lastRoute)
    _unload(_data.lastRoute);

  if(typeof options.always === 'function')
    options.always(_data.currentRoute);

  if(_data.currentRoute)
    _load(_data.currentRoute);
  else
    options.notFound(_data.currentPath);
}

/**
 * Runs routes load, and dispatches event
 */
var _load = function(route){
  if(typeof options.routes[route.name].load === 'function')
    options.routes[route.name].load(route.params);

  _doEvent('routeLoad', route);
}

/**
 * Runs routes unload, and dispatches event
 */
var _unload = function(route){
  if(typeof options.routes[route.name].unload === 'function')
    options.routes[route.name].unload(route.params);

  _doEvent('routeUnload', route);
}

/**
 * Defines and dispatches custom events on the window
 */
var _doEvent = function(name, details){
  var event = new CustomEvent(name, {
    detail : details
  });
  window.dispatchEvent(event);
}

/**
 * Merge options
 */
var init = function(opts) {
  options = $.extend(true, options, opts);
  if(options.event)
    $(document).on(options.event, _navigate);
  _navigate()
};

/**
 * Add a route
 */
var add = function(opts) {
  if(('name' in opts) && ('pattern' in opts)){
    options.routes[opts.name] = {
      'pattern' : opts.pattern,
      'load'    : opts.load,
      'unload'  : opts.unload
    };
  } else {
    console.log('You need at least a name and pattern defined');
  }
};

/**
 * Remove a route
 */
var remove = function(route) {
  delete options.routes[route];
};




/**
* Dependencies
*/
var liteURL = (function(){
    'use strict';

    /**
     * Establish the root object, `window` in the browser, or `exports` on the server.
     */
    var root = this;

    /**
     * In memory cache for so we don't parse the same url twice
     * @type {{}}
     */
    var memo = {};

    /**
     * For parsing query params out
     * @type {RegExp}
     */
    var queryParser = /(?:^|&)([^&=]*)=?([^&]*)/g;

    /**
     * For parsing a url into component parts
     * there are other parts which are suppressed (?:) but we only want to represent what would be available
     *  from `(new URL(urlstring))` in this api.
     *
     * @type {RegExp}
     */
    var uriParser = /^(?:(?:(([^:\/#\?]+:)?(?:(?:\/\/)(?:(?:(?:([^:@\/#\?]+)(?:\:([^:@\/#\?]*))?)@)?(([^:\/#\?\]\[]+|\[[^\/\]@#?]+\])(?:\:([0-9]+))?))?)?)?((?:\/?(?:[^\/\?#]+\/+)*)(?:[^\?#]*)))?(\?[^#]+)?)(#.*)?/;
    var keys = [
        "href",                    // http://user:pass@host.com:81/directory/file.ext?query=1#anchor
        "origin",                  // http://user:pass@host.com:81
        "protocol",                // http:
        "username",                // user
        "password",                // pass
        "host",                    // host.com:81
        "hostname",                // host.com
        "port",                    // 81
        "pathname",                // /directory/file.ext
        "search",                  // ?query=1
        "hash"                     // #anchor
    ];


    /**
     * Uri parsing method.
     *
     * @param str
     * @returns {{
     *   href:string,
     *   origin:string,
     *   protocol:string,
     *   username:string,
     *   password:string,
     *   host:string,
     *   hostname:string,
     *   port:string,
     *   path:string,
     *   search:string,
     *   hash:string,
     *   params:{}
     * }}
     */
    function liteURL(str) {
        // We first check if we have parsed this URL before, to avoid running the
        // monster regex over and over (which is expensive!)
        var uri = memo[str];

        if (typeof uri !== 'undefined') {
            return uri;
        } else {
            //final object to return
            uri = {};
        }

        //parsed url
        var matches   = uriParser.exec(str);

        //number of indexes pulled from the url via the urlParser (see 'keys')
        var i   = keys.length;

        while (i--) {
            uri[keys[i]] = matches[i] || '';
        }

        uri.params = {};

        //strip the question mark from search
        var query = uri.search ? uri.search.substring( uri.search.indexOf('?') + 1 ) : '';
        query.replace(queryParser, function ($0, $1, $2) {
            //query isn't actually modified, .replace() is used as an iterator to populate params
            if ($1) {
                uri.params[$1] = $2;
            }
        });

        // Stored parsed values
        memo[str] = uri;

        return uri;
    }

    //moduleType support
    if (typeof exports !== 'undefined') {
        //supports node
        if (typeof module !== 'undefined' && module.exports) {
            exports = module.exports = liteURL;
        }
        exports.liteURL = liteURL;
    } else {
        //supports globals
        root.liteURL = liteURL;
    }

    //supports requirejs/amd
    return liteURL;
}).call(this);
var pattern = (function(){
  var pathToRegexp = (function(){
    /**
     * The main path matching regexp utility.
     *
     * @type {RegExp}
     */
    var PATH_REGEXP = new RegExp([
      // Match already escaped characters that would otherwise incorrectly appear
      // in future matches. This allows the user to escape special characters that
      // shouldn't be transformed.
      '(\\\\.)',
      // Match Express-style parameters and un-named parameters with a prefix
      // and optional suffixes. Matches appear as:
      //
      // "/:test(\\d+)?" => ["/", "test", "\d+", undefined, "?"]
      // "/route(\\d+)" => [undefined, undefined, undefined, "\d+", undefined]
      '([\\/.])?(?:\\:(\\w+)(?:\\(((?:\\\\.|[^)])*)\\))?|\\(((?:\\\\.|[^)])*)\\))([+*?])?',
      // Match regexp special characters that should always be escaped.
      '([.+*?=^!:${}()[\\]|\\/])'
    ].join('|'), 'g');

    /**
     * Escape the capturing group by escaping special characters and meaning.
     *
     * @param  {String} group
     * @return {String}
     */
    function escapeGroup (group) {
      return group.replace(/([=!:$\/()])/g, '\\$1');
    }

    /**
     * Attach the keys as a property of the regexp.
     *
     * @param  {RegExp} re
     * @param  {Array}  keys
     * @return {RegExp}
     */
    function attachKeys (re, keys) {
      re.keys = keys;

      return re;
    };

    /**
     * Normalize the given path string, returning a regular expression.
     *
     * An empty array should be passed in, which will contain the placeholder key
     * names. For example `/user/:id` will then contain `["id"]`.
     *
     * @param  {(String|RegExp|Array)} path
     * @param  {Array}                 keys
     * @param  {Object}                options
     * @return {RegExp}
     */
    function pathtoRegexp (path, keys, options) {
      if (!$.isArray(keys)) {
        options = keys;
        keys = null;
      }

      keys = keys || [];
      options = options || {};

      var strict = options.strict;
      var end = options.end !== false;
      var flags = options.sensitive ? '' : 'i';
      var index = 0;

      if (path instanceof RegExp) {
        // Match all capturing groups of a regexp.
        var groups = path.source.match(/\((?!\?)/g);

        // Map all the matches to their numeric indexes and push into the keys.
        if (groups) {
          for (var i = 0; i < groups.length; i++) {
            keys.push({
              name:      i,
              delimiter: null,
              optional:  false,
              repeat:    false
            });
          }
        }

        // Return the source back to the user.
        return attachKeys(path, keys);
      }

      // Map array parts into regexps and return their source. We also pass
      // the same keys and options instance into every generation to get
      // consistent matching groups before we join the sources together.
      if ($.isArray(path)) {
        var parts = [];

        for (var i = 0; i < path.length; i++) {
          parts.push(pathtoRegexp(path[i], keys, options).source);
        }
        // Generate a new regexp instance by joining all the parts together.
        return attachKeys(new RegExp('(?:' + parts.join('|') + ')', flags), keys);
      }

      // Alter the path string into a usable regexp.
      path = path.replace(PATH_REGEXP, function (match, escaped, prefix, key, capture, group, suffix, escape) {
        // Avoiding re-escaping escaped characters.
        if (escaped) {
          return escaped;
        }

        // Escape regexp special characters.
        if (escape) {
          return '\\' + escape;
        }

        var repeat   = suffix === '+' || suffix === '*';
        var optional = suffix === '?' || suffix === '*';

        keys.push({
          name:      key || index++,
          delimiter: prefix || '/',
          optional:  optional,
          repeat:    repeat
        });

        // Escape the prefix character.
        prefix = prefix ? '\\' + prefix : '';

        // Match using the custom capturing group, or fallback to capturing
        // everything up to the next slash (or next period if the param was
        // prefixed with a period).
        capture = escapeGroup(capture || group || '[^' + (prefix || '\\/') + ']+?');

        // Allow parameters to be repeated more than once.
        if (repeat) {
          capture = capture + '(?:' + prefix + capture + ')*';
        }

        // Allow a parameter to be optional.
        if (optional) {
          return '(?:' + prefix + '(' + capture + '))?';
        }

        // Basic parameter support.
        return prefix + '(' + capture + ')';
      });

      // Check whether the path ends in a slash as it alters some match behaviour.
      var endsWithSlash = path[path.length - 1] === '/';

      // In non-strict mode we allow an optional trailing slash in the match. If
      // the path to match already ended with a slash, we need to remove it for
      // consistency. The slash is only valid at the very end of a path match, not
      // anywhere in the middle. This is important for non-ending mode, otherwise
      // "/test/" will match "/test//route".
      if (!strict) {
        path = (endsWithSlash ? path.slice(0, -2) : path) + '(?:\\/(?=$))?';
      }

      // In non-ending mode, we need prompt the capturing groups to match as much
      // as possible by using a positive lookahead for the end or next path segment.
      if (!end) {
        path += strict && endsWithSlash ? '' : '(?=\\/|$)';
      }

      return attachKeys(new RegExp('^' + path + (end ? '$' : ''), flags), keys);
    };
    return pathtoRegexp;
  }).call(this);

  var createError = (function(){
    var statuses = (function(){
    var codes = {
      "100": "Continue", "101": "Switching Protocols", "102": "Processing", "200": "OK", "201": "Created", "202": "Accepted", "203": "Non-Authoritative Information", "204": "No Content", "205": "Reset Content", "206": "Partial Content", "207": "Multi-Status", "208": "Already Reported", "226": "IM Used", "300": "Multiple Choices", "301": "Moved Permanently", "302": "Found", "303": "See Other", "304": "Not Modified", "305": "Use Proxy", "306": "(Unused)", "307": "Temporary Redirect", "308": "Permanent Redirect", "400": "Bad Request", "401": "Unauthorized", "402": "Payment Required", "403": "Forbidden", "404": "Not Found", "405": "Method Not Allowed", "406": "Not Acceptable", "407": "Proxy Authentication Required", "408": "Request Timeout", "409": "Conflict", "410": "Gone", "411": "Length Required", "412": "Precondition Failed", "413": "Payload Too Large", "414": "URI Too Long", "415": "Unsupported Media Type", "416": "Range Not Satisfiable", "417": "Expectation Failed", "418": "I'm a teapot", "422": "Unprocessable Entity", "423": "Locked", "424": "Failed Dependency", "425": "Unordered Collection", "426": "Upgrade Required", "428": "Precondition Required", "429": "Too Many Requests", "431": "Request Header Fields Too Large", "451": "Unable For Legal Reasons", "500": "Internal Server Error", "501": "Not Implemented", "502": "Bad Gateway", "503": "Service Unavailable", "504": "Gateway Timeout", "505": "HTTP Version Not Supported", "506": "Variant Also Negotiates", "507": "Insufficient Storage", "508": "Loop Detected", "509": "Bandwidth Limit Exceeded", "510": "Not Extended", "511": "Network Authentication Required"
    };

    // [Integer...]
    status.codes = Object.keys(codes).map(function (code) {
      code = ~~code;
      var msg = codes[code];
      status[code] = msg;
      status[msg] = status[msg.toLowerCase()] = code;
      return code;
    });

    // status codes for redirects
    status.redirect = {
      300: true,
      301: true,
      302: true,
      303: true,
      305: true,
      307: true,
      308: true,
    };

    // status codes for empty bodies
    status.empty = {
      204: true,
      205: true,
      304: true,
    };

    // status codes for when you should retry the request
    status.retry = {
      502: true,
      503: true,
      504: true,
    };

    function status(code) {
      if (typeof code === 'number') {
        if (!status[code]) throw new Error('invalid status code: ' + code);
        return code;
      }

      if (typeof code !== 'string') {
        throw new TypeError('code must be a number or string');
      }

      // '403'
      var n = parseInt(code, 10)
      if (!isNaN(n)) {
        if (!status[n]) throw new Error('invalid status code: ' + n);
        return n;
      }

      n = status[code.toLowerCase()];
      if (!n) throw new Error('invalid status message: "' + code + '"');
      return n;
    }

    return status;
    }).call(this);
    var inherits = require('inherits');
    function httpError() {
      // so much arity going on ~_~
      var err;
      var msg;
      var status = 500;
      var props = {};
      for (var i = 0; i < arguments.length; i++) {
        var arg = arguments[i];
        if (arg instanceof Error) {
          err = arg;
          status = err.status || err.statusCode || status;
          continue;
        }
        switch (typeof arg) {
          case 'string':
            msg = arg;
            break;
          case 'number':
            status = arg;
            break;
          case 'object':
            props = arg;
            break;
        }
      }

      if (typeof status !== 'number' || !statuses[status]) status = 500;

      if (!err) {
        // create error
        err = new Error(msg || statuses[status])
        Error.captureStackTrace(err, httpError)
      }

      err.expose = status < 500;
      for (var key in props) err[key] = props[key];
      err.status = err.statusCode = status;
      return err;
    };

    // create generic error objects
    var codes = statuses.codes.filter(function (num) {
      return num >= 400;
    });

    codes.forEach(function (code) {
      if (code >= 500) {
        var ServerError = function ServerError(msg) {
          var self = new Error(msg != null ? msg : statuses[code])
          Error.captureStackTrace(self, ServerError)
          self.__proto__ = ServerError.prototype
          return self
        }
        inherits(ServerError, Error);
        ServerError.prototype.status =
        ServerError.prototype.statusCode = code;
        ServerError.prototype.expose = false;
        exports[code] =
        exports[statuses[code].replace(/\s+/g, '')] = ServerError;
        return;
      }

      var ClientError = function ClientError(msg) {
        var self = new Error(msg != null ? msg : statuses[code])
        Error.captureStackTrace(self, ClientError)
        self.__proto__ = ClientError.prototype
        return self
      }
      inherits(ClientError, Error);
      ClientError.prototype.status =
      ClientError.prototype.statusCode = code;
      ClientError.prototype.expose = true;
      exports[code] =
      exports[statuses[code].replace(/\s+/g, '')] = ClientError;
      return;
    });

    return httpError;
  }).call(this);

  function pathMatch(options) {
    options = options || {};

    return function (path) {
      var keys = [];
      var re = pathToRegexp(path, keys, options);

      return function (pathname, params) {
        var m = re.exec(pathname);
        if (!m) return false;

        params = params || {};

        var key, param;
        for (var i = 0; i < keys.length; i++) {
          key = keys[i];
          param = m[i + 1];
          if (!param) continue;
          params[key.name] = decodeParam(param);
          if (key.repeat) params[key.name] = params[key.name].split(key.delimiter)
        }

        return params;
      }
    }
  }

  function decodeParam(param) {
    try {
      return decodeURIComponent(param);
    } catch (_) {
      throw createError(400, 'failed to decode param "' + param + '"');
    }
  }
  return pathMatch()
}).call(this);

/**
 * Public methods
 */
module.exports = {
  'init'     : init,
  'add'      : add,
  'remove'   : remove,
  'navigate' : _navigate,
  'data' : _data
};

