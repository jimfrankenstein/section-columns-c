---
---

# basic namespace

window.leadpagesUX ||= {}

leadpagesUX.gatherScripts = ->

  # call each script
    
  [].forEach.call( window.leadscripts, (script) ->
    leadpagesUX[script].init()
  )

leadpagesUX.home =

  init: () ->
    # console.debug 'home?'
