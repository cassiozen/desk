/*
 * jQuery Hotkeys Plugin
 * Copyright 2010, John Resig
 * Dual licensed under the MIT or GPL Version 2 licenses.
 *
 * Based upon the plugin by Tzury Bar Yochay:
 * http://github.com/tzuryby/hotkeys
 *
 * Original idea by:
 * Binny V A, http://www.openjs.com/scripts/events/keyboard_shortcuts/
*/

(function(jQuery){

	jQuery.hotkeys = {
		version: "0.8",

		specialKeys: {
			8: "backspace", 9: "tab", 13: "return", 16: "shift", 17: "ctrl", 18: "alt", 19: "pause",
			20: "capslock", 27: "esc", 32: "space", 33: "pageup", 34: "pagedown", 35: "end", 36: "home",
			37: "left", 38: "up", 39: "right", 40: "down", 45: "insert", 46: "del",
			96: "0", 97: "1", 98: "2", 99: "3", 100: "4", 101: "5", 102: "6", 103: "7",
			104: "8", 105: "9", 106: "*", 107: "+", 109: "-", 110: ".", 111 : "/",
			112: "f1", 113: "f2", 114: "f3", 115: "f4", 116: "f5", 117: "f6", 118: "f7", 119: "f8",
			120: "f9", 121: "f10", 122: "f11", 123: "f12", 144: "numlock", 145: "scroll", 191: "/", 224: "meta"
		},

		shiftNums: {
			"`": "~", "1": "!", "2": "@", "3": "#", "4": "$", "5": "%", "6": "^", "7": "&",
			"8": "*", "9": "(", "0": ")", "-": "_", "=": "+", ";": ": ", "'": "\"", ",": "<",
			".": ">",  "/": "?",  "\\": "|"
		}
	};

	function keyHandler( handleObj ) {
		// Only care when a possible input has been specified
		if ( typeof handleObj.data !== "string" ) {
			return;
		}

		var origHandler = handleObj.handler,
			keys = handleObj.data.toLowerCase().split(" "),
			textAcceptingInputTypes = ["text", "password", "number", "email", "url", "range", "date", "month", "week", "time", "datetime", "datetime-local", "search", "color"];

		handleObj.handler = function( event ) {
			// Don't fire in text-accepting inputs that we didn't directly bind to
			if ( this !== event.target && (/textarea|select/i.test( event.target.nodeName ) ||
				jQuery.inArray(event.target.type, textAcceptingInputTypes) > -1 ) ) {
				return;
			}

			// Keypress represents characters, not special keys
			var special = event.type !== "keypress" && jQuery.hotkeys.specialKeys[ event.which ],
				character = String.fromCharCode( event.which ).toLowerCase(),
				key, modif = "", possible = {};

			// check combinations (alt|ctrl|shift+anything)
			if ( event.altKey && special !== "alt" ) {
				modif += "alt+";
			}

			if ( event.ctrlKey && special !== "ctrl" ) {
				modif += "ctrl+";
			}

			// TODO: Need to make sure this works consistently across platforms
			if ( event.metaKey && !event.ctrlKey && special !== "meta" ) {
				modif += "meta+";
			}

			if ( event.shiftKey && special !== "shift" ) {
				modif += "shift+";
			}

			if ( special ) {
				possible[ modif + special ] = true;

			} else {
				possible[ modif + character ] = true;
				possible[ modif + jQuery.hotkeys.shiftNums[ character ] ] = true;

				// "$" can be triggered as "Shift+4" or "Shift+$" or just "$"
				if ( modif === "shift+" ) {
					possible[ jQuery.hotkeys.shiftNums[ character ] ] = true;
				}
			}

			for ( var i = 0, l = keys.length; i < l; i++ ) {
				if ( possible[ keys[i] ] ) {
					return origHandler.apply( this, arguments );
				}
			}
		};
	}

	jQuery.each([ "keydown", "keyup", "keypress" ], function() {
		jQuery.event.special[ this ] = { add: keyHandler };
	});

})( jQuery );
/* @fileoverview
 * Provides full bootstrap based, multi-instance WYSIWYG editor.
 *
 * "Name"    = 'bootstrap-wysiwyg'
 * "Author"  = 'Various, see LICENCE'
 * "Version" = '1.0.1'
 * "About"   = 'Tiny Bootstrap and JQuery Based WISWYG rich text editor.'
 */
(function($) {
  'use strict';
  /** underscoreThrottle()
   * 	From underscore http://underscorejs.org/docs/underscore.html
   */
  var underscoreThrottle = function(func, wait) {
    var context, args, timeout, result;
    var previous = 0;
    var later = function() {
      previous = new Date;
      timeout = null;
      result = func.apply(context, args);
    };
    return function() {
      var now = new Date;
      var remaining = wait - (now - previous);
      context = this;
      args = arguments;
      if (remaining <= 0) {
        clearTimeout(timeout);
        timeout = null;
        previous = now;
        result = func.apply(context, args);
      } else if (!timeout) {
        timeout = setTimeout(later, remaining);
      }
      return result;
    };
  }
  var readFileIntoDataUrl = function(fileInfo) {
    var loader = $.Deferred(),
      fReader = new FileReader();
    fReader.onload = function(e) {
      loader.resolve(e.target.result);
    };
    fReader.onerror = loader.reject;
    fReader.onprogress = loader.notify;
    fReader.readAsDataURL(fileInfo);
    return loader.promise();
  };
  $.fn.cleanHtml = function() {
    var html = $(this).html();
    return html && html.replace(/(<br>|\s|<div><br><\/div>|&nbsp;)*$/, '');
  };
  $.fn.wysiwyg = function(userOptions) {
    var editor = this,
      wrapper = $(editor).parent(),
      selectedRange,
      options,
      toolbarBtnSelector,
      updateToolbar = function() {
        if (options.activeToolbarClass) {
          $(options.toolbarSelector, wrapper).find(toolbarBtnSelector).each(underscoreThrottle(function() {
            var commandArr = $(this).data(options.commandRole).split(' '),
              command = commandArr[0];

            // If the command has an argument and its value matches this button. == used for string/number comparison
            if (commandArr.length > 1 && document.queryCommandEnabled(command) && document.queryCommandValue(command) == commandArr[1]) {
              $(this).addClass(options.activeToolbarClass);
              // Else if the command has no arguments and it is active
            } else if (commandArr.length === 1 && document.queryCommandEnabled(command) && document.queryCommandState(command)) {
              $(this).addClass(options.activeToolbarClass);
              // Else the command is not active
            } else {
              $(this).removeClass(options.activeToolbarClass);
            }
          }, options.keypressTimeout));
        }
      },
      execCommand = function(commandWithArgs, valueArg) {
        var commandArr = commandWithArgs.split(' '),
          command = commandArr.shift(),
          args = commandArr.join(' ') + (valueArg || '');
        document.execCommand(command, 0, args);
        updateToolbar();
      },
      bindHotkeys = function(hotKeys) {
        $.each(hotKeys, function(hotkey, command) {
          editor.keydown(hotkey, function(e) {
            if (editor.attr('contenteditable') && editor.is(':visible')) {
              e.preventDefault();
              e.stopPropagation();
              execCommand(command);
            }
          }).keyup(hotkey, function(e) {
            if (editor.attr('contenteditable') && editor.is(':visible')) {
              e.preventDefault();
              e.stopPropagation();
            }
          });
        });
      },
      getCurrentRange = function() {
        var sel, range;
        if (window.getSelection) {
          sel = window.getSelection();
          if (sel.getRangeAt && sel.rangeCount) {
            range = sel.getRangeAt(0);
          }
        } else if (document.selection) {
          range = document.selection.createRange();
        }
        return range;
      },
      saveSelection = function() {
        selectedRange = getCurrentRange();
      },
      restoreSelection = function() {
        setSelection(selectedRange);
      },
      setSelection = function(range) {
        var selection;
        if (window.getSelection || document.createRange) {
          selection = window.getSelection();
          if (range) {
            try {
              selection.removeAllRanges();
            } catch (ex) {
              document.body.createTextRange().select();
              document.selection.empty();
            }
            selection.addRange(range);
          }
        } else if (document.selection && range) {
          range.select()
        }
      },
      insertHTML = function(value) {
        if (document.queryCommandSupported('insertHTML')) {
          execCommand('insertHTML', value);
        } else if (Object.pasteHTML !== undefined) {
          getCurrentRange().pasteHTML(value);
        } else {
          var el = document.createElement("div");
          el.innerHTML = value;
          var frag = document.createDocumentFragment(),
            node, lastNode;
          while ((node = el.firstChild)) {
            lastNode = frag.appendChild(node);
          }
          getCurrentRange().insertNode(frag);
        }
      },
      insertFiles = function(files) {
        editor.focus();
        $.each(files, function(idx, fileInfo) {
          if (/^image\//.test(fileInfo.type)) {
            var imgRange = getCurrentRange()
            var fileID = fileInfo.name.replace(/[`~!@#$%^&*()_ |+\-=?;:'",.<>\{\}\[\]\\\/]/gi, '');
            insertHTML('<span class="fileuploading" data-loading="[Uploading '+ fileInfo.name +' ...]" id="' + fileID + '"></span>');
            $.when(options.fileUpload(fileInfo)).done(function(source) {
              $('#' + fileID).remove();
              setSelection(imgRange);
              execCommand('insertimage', source);
            }).fail(function(e) {
              options.fileUploadError("file-reader", e);
            });
          } else {
            options.fileUploadError("unsupported-file-type", fileInfo.type);
          }
        });
      },
      markSelection = function(input, color) {
        restoreSelection();
        if (document.queryCommandSupported('hiliteColor')) {
          document.execCommand('hiliteColor', 0, color || 'transparent');
        }
        saveSelection();
        input.data(options.selectionMarker, color);
      },
      bindToolbar = function(toolbar, options) {
        toolbar.find(toolbarBtnSelector, wrapper).click(function() {
          restoreSelection();
          editor.focus();
          execCommand($(this).data(options.commandRole));
          saveSelection();
        });
        toolbar.find('[data-toggle=dropdown]').click(restoreSelection);

        toolbar.find('input[type=text][data-' + options.commandRole + ']').on('webkitspeechchange change', function() {
          var newValue = this.value; /* ugly but prevents fake double-calls due to selection restoration */
          this.value = '';
          restoreSelection();
          if (newValue) {
            editor.focus();
            execCommand($(this).data(options.commandRole), newValue);
          }
          saveSelection();
        }).on('focus', function() {
          var input = $(this);
          if (!input.data(options.selectionMarker)) {
            markSelection(input, options.selectionColor);
            input.focus();
          }
        }).on('blur', function() {
          var input = $(this);
          if (input.data(options.selectionMarker)) {
            markSelection(input, false);
          }
        });
        toolbar.find('input[type=file][data-' + options.commandRole + ']').change(function() {
          restoreSelection();
          if (this.type === 'file' && this.files && this.files.length > 0) {
            insertFiles(this.files);
          }
          saveSelection();
          this.value = '';
        });
      },
      initFileDrops = function() {
        editor.on('dragenter dragover', false)
          .on('drop', function(e) {
            var dataTransfer = e.originalEvent.dataTransfer;
            e.stopPropagation();
            e.preventDefault();
            if (dataTransfer && dataTransfer.files && dataTransfer.files.length > 0) {
              insertFiles(dataTransfer.files);
            }
          });
      };
    options = $.extend(true, {}, $.fn.wysiwyg.defaults, userOptions);
    toolbarBtnSelector = 'a[data-' + options.commandRole + '],button[data-' + options.commandRole + '],input[type=button][data-' + options.commandRole + ']';
    bindHotkeys(options.hotKeys);
    if (options.dragAndDropImages) {
      initFileDrops();
    }
    bindToolbar($(options.toolbarSelector), options);
    editor.attr('contenteditable', true)
      .on('mouseup keyup mouseout', function() {
        saveSelection();
        updateToolbar();
      });
    $(window).bind('touchend', function(e) {
      var isInside = (editor.is(e.target) || editor.has(e.target).length > 0),
        currentRange = getCurrentRange(),
        clear = currentRange && (currentRange.startContainer === currentRange.endContainer && currentRange.startOffset === currentRange.endOffset);
      if (!clear || isInside) {
        saveSelection();
        updateToolbar();
      }
    });
    return this;
  };
  $.fn.wysiwyg.defaults = {
    hotKeys: {
      'ctrl+b meta+b': 'bold',
      'ctrl+i meta+i': 'italic',
      'ctrl+u meta+u': 'underline',
      'ctrl+z meta+z': 'undo',
      'ctrl+y meta+y meta+shift+z': 'redo',
      'ctrl+l meta+l': 'justifyleft',
      'ctrl+r meta+r': 'justifyright',
      'ctrl+e meta+e': 'justifycenter',
      'ctrl+j meta+j': 'justifyfull',
      'shift+tab': 'outdent',
      'tab': 'indent'
    },
    toolbarSelector: '[data-role=editor-toolbar]',
    commandRole: 'edit',
    activeToolbarClass: 'btn-info',
    selectionMarker: 'edit-focus-marker',
    selectionColor: 'darkgrey',
    dragAndDropImages: true,
    keypressTimeout: 200,
    fileUpload: readFileIntoDataUrl,
    fileUploadError: function(reason, detail) {
      console.log("File upload error", reason, detail);
    }
  };
}(window.jQuery));