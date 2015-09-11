require! { http, connect, ecstatic }

app = connect!

app.use ecstatic root: "#__dirname/static"

#app.use (request, response) !->

http.create-server app .listen 9980
