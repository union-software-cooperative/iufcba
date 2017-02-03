# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

ready = ->
  
  $('.switch').bootstrapSwitch();
  $('.ac-select2').each ->
    url = $(this).data('url')
    #placeholder = $(this).data('placeholder')
    $(this).select2
      theme: "bootstrap"
      minimumInputLength: 0
      maximumSelectionLength:1
      #placeholder: placeholder
      allowClear: true
      ajax:
        url: url
        dataType: 'json'
        quietMillis: 500
        data: (params) ->
          { name_like: params.term }
        processResults: (data, page) ->
          formatted = []
          data.forEach (item) ->
            formatted.push
              id: item['id']
              text: item['name']
            return
          { 
            results: formatted 
          }
      formatResult: (item, page) ->
        item.name
      formatSelection: (item, page) ->
        item.name
    return
  
  $('.ac-select2-tags').each ->
    placeholder = $(this).data('placeholder')
    $(this).select2
      theme: "bootstrap"
      multiple: true
      placeholder: placeholder
      allowClear: false
      tags: true
    return

  $('.ac-select2-multi').each ->
    url = $(this).data('url')
    placeholder = $(this).data('placeholder')
    $(this).select2
      theme: "bootstrap"
      minimumInputLength: 0
      multiple: true
      placeholder: placeholder
      allowClear: false
      ajax:
        url: url
        dataType: 'json'
        quietMillis: 500
        data: (params) ->
          { name_like: params.term }
        processResults: (data, page) ->
          formatted = []
          data.forEach (item) ->
            formatted.push
              id: item['id']
              text: item['name']
            return
          {
            results: formatted
          }
        formatResult: (item, page) ->
          item.name
        formatSelection: (item, page) ->
          item.name
    return

  # This is a hack the preserves selection order, but its then lost when rendering!  I want selection order preserved to specify language preference
  $('.ac-select2-multi').on 'select2:select', (evt) ->
    element = evt.params.data.element
    $element = $(element)
    $element.detach()
    $(this).append $element
    $(this).trigger 'change'
    return

  return

  
$(document).ready(ready);
$(document).on('page:load', ready);
