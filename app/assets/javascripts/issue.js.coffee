Base = require("Base")
utils = require("utils")

class Issue extends Base.ViewController
  constructor: ->
    super "issue", "/requests/:issue"

  setup: ->
    super()

  activate: ->
    super()
    @log("Issue")
    # Show tooltips for toolbar buttons
    $('a[title]').tooltip(container:'body')
    # Avoid closing dropdown when focusing on input field
    $('.dropdown-menu input').click(-> false)
      .change(-> $(@).parent('.dropdown-menu').siblings('.dropdown-toggle').dropdown('toggle'))
      .keydown('esc', -> @value = ''; $(@).change())

    # Init Bootstrap Wysiwyg
    $('#editor').wysiwyg(toolbarSelector: '[data-role=editor-toolbar]', fileUpload: @imageUpload)

    # Init Uploadifive (file attachments)
    $('#file_upload').uploadifive
      'auto'             : true
      'dnd'              : false
      'queueID'          : 'editor-queue'
      'fileSizeLimit'    : "5MB"
      'buttonText'       : '<i class="fa fa-paperclip"></i>'
      'fileObjName'      : 'file'
      'uploadScript'     : '/attachments'
      'buttonClass'      : 'btn btn-default'
      'onUploadComplete' : (file, data) ->
        file.queueItem.data("id", JSON.parse(data).id)

    $('[data-role=magic-overlay]').each ->
      overlay = $(@)
      target = $(overlay.data('target'))
      overlay.css('opacity', 0).css('position', 'absolute').offset(target.offset()).width(target.outerWidth()).height(target.outerHeight());

  deactivate: ->
    super()

module.exports = Issue
