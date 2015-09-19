require! querystring

export get = (url, data, callback) !->
  xhr = new XMLHttpRequest!
  xhr.onload = !-> callback @response
  xhr.open \GET url + '?' + querystring.stringify data
  xhr.send!

export post = (url, data, callback) !->
  xhr = new XMLHttpRequest!
  xhr.onload = !-> @response-text |> JSON.parse |> callback
  xhr.open \POST url
  xhr.set-request-header \content-type 'application/x-www-form-urlencoded'
  xhr.send querystring.stringify data
