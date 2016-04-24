#! qHint 1.1 | http://gyoshev.mit-license.org 
(->
  
  # jsHintTest('file.js', [options])
  createXMLHTTPObject = ->
    i = 0

    while i < XMLHttpFactories.length
      try
        return XMLHttpFactories[i]()
      i++
    false
  qHint = window.jsHintTest = window.qHint = qHint = (name, sourceFile, options, globals) ->
    if sourceFile is `undefined` or typeof (sourceFile) is "object"
      globals = options
      options = sourceFile
      sourceFile = name
    asyncTest name, ->
      qHint.sendRequest sourceFile, (req) ->
        start()
        if req.status is 200
          qHint.validateFile req.responseText, options, globals
        else
          ok false, "HTTP error " + req.status + " while fetching " + sourceFile



  qHint.validateFile = (source, options, globals) ->
    i = undefined
    len = undefined
    err = undefined
    if JSHINT(source, options, globals)
      ok true
      return
    i = 0
    len = JSHINT.errors.length

    while i < len
      err = JSHINT.errors[i]
      continue  unless err
      ok false, err.reason + " on line " + err.line + ", character " + err.character
      i++

  XMLHttpFactories = [ ->
    new XMLHttpRequest()
  , ->
    new ActiveXObject("Msxml2.XMLHTTP")
  , ->
    new ActiveXObject("Msxml3.XMLHTTP")
  , ->
    new ActiveXObject("Microsoft.XMLHTTP")
   ]
  
  # modified version of XHR script by PPK
  # http://www.quirksmode.org/js/xmlhttp.html
  # attached to qHint to allow substitution / mocking
  qHint.sendRequest = (url, callback) ->
    req = createXMLHTTPObject()
    return  unless req
    method = "GET"
    req.open method, url, true
    req.onreadystatechange = ->
      return  unless req.readyState is 4
      callback req

    return  if req.readyState is 4
    req.send()
)()
