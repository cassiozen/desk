Base = require("Base")
utils = require("utils")

class Issue extends Base.ViewController
  events:
    "click #send,#close,#open,#hold": "sendForm"

  constructor: ->
    super "issue", "/requests/:issue"

  setup: ->
    super()

  activate: ->
    super()
    @log("Issue")

    # Show tooltips for toolbar buttons
    @$('a[title]').tooltip(container:'body')
    # Avoid closing dropdown when focusing on input field
    @$('.dropdown-menu input').click(-> false)
      .change(-> $(@).parent('.dropdown-menu').siblings('.dropdown-toggle').dropdown('toggle'))
      .keydown('esc', -> @value = ''; $(@).change())

    # Init Bootstrap Wysiwyg
    @$('#editor').wysiwyg(toolbarSelector: '[data-role=editor-toolbar]', fileUpload: @imageUpload)

    # Init Uploadifive (file attachments)
    @$('#file_upload').uploadifive
      'auto'             : true
      'dnd'              : false
      'queueID'          : 'editor-queue'
      'fileSizeLimit'    : "5MB"
      'buttonText'       : '<i class="fa fa-paperclip"></i>'
      'fileObjName'      : 'file'
      'formData'         : {'authenticity_token': jQuery( 'meta[name="csrf-token"]' ).attr( 'content' )}
      'uploadScript'     : '/attachments'
      'itemTemplate'     : '<div class="uploadifive-queue-item"><a class="close" href="#">X</a><div><span class="filename"></span><span class="fileinfo"></span></div><div class="progress"><div class="progress-bar"></div></div><input type="hidden" class="attachment_id" name="attachment_ids[]"></input></div>'
      'buttonClass'      : 'btn btn-default'
      'onUploadComplete' : (file, data) ->
        file.queueItem.data("id", JSON.parse(data).id)
        file.queueItem.find('.attachment_id').val(file.queueItem.data("id"))

    @$('[data-role=magic-overlay]').each ->
      overlay = $(@)
      target = $(overlay.data('target'))
      overlay.css('opacity', 0).css('position', 'absolute').offset(target.offset()).width(target.outerWidth()).height(target.outerHeight());



  imageUpload: (file) ->
    formData = new FormData()
    uploader = $.Deferred()
    formData.append('image', file, file.name)
    $.ajax(
      url: '/images'
      data: formData
      cache: false
      processData: false
      contentType: false
      dataType: 'json'
      type: 'POST'
    )
    .done (returnObj) -> uploader.resolve(returnObj.url)
    .fail(uploader.reject)

    return uploader.promise()

  sendForm: (evt) ->
    evt.preventDefault()
    evt.currentTarget = @$("form")[0] #Pjax form submission needs currentTarget to be the form element

    @$("form #body").val @$('#editor').cleanHtml()

    if evt.target.id == "send"
      @$("form #interaction_type").val "message"
    else if evt.target.id == "close"
      @$("form #interaction_type").val "closed"
    else if evt.target.id == "open"
      @$("form #interaction_type").val "open"
    else if evt.target.id == "hold"
      @$("form #interaction_type").val "pending"

    $.pjax.submit(evt, '[data-pjax-container]', push: false, scrollTo: $(document).height()-$(window).height())

  deactivate: ->
    super()

module.exports = Issue
