class App
    constructor: (app_id) ->
        @app_id = app_id

    load_fb_sdk: ->
        # Load the SDK asynchronously
        d = document
        s = 'script'
        id = 'facebook-jssdk'
        fjs = document.getElementsByTagName('script')[0]
        unless document.getElementById(id)
            js = document.createElement('script')
            js.id = id
            js.src = "//connect.facebook.net/en_US/sdk.js"
            fjs.parentNode.insertBefore(js, fjs)
    init_fb: ->
        FB.init({
            appId: @app_id
            cookie: true
            xfbml: true
            version: 'v2.5'
        })
        @check_login_state()

    on_status_change: (response) ->
        console.log "---- on_status_change ----"
        console.log response
        if response.status == 'connected'
            @on_connected()
        else if response.status == 'not_authorized'
            alert "로그인해주세요."  # FIXME: 메세지
        else
            alert "페이스북으로 로그인해주세요."  # FIXME: 메세지

    on_connected: ->
        alert "connected"
        FB.api '/me', (response) ->
            console.log("Successful login for: #{response.name}")

    check_login_state: ->
        me = @
        FB.getLoginStatus (response) -> me.on_status_change(response)

window.app = new App("1507474466213153")
app.load_fb_sdk()

window.fbAsyncInit = -> app.init_fb()














canvas = document.getElementById("canvas")
ctx = canvas.getContext("2d")

loaded = 0
on_load = ->
    loaded += 1;
    if loaded == 2
        # composite now
        ctx.drawImage(img1, 0, 0)
        ctx.globalAlpha = 0.5
        ctx.drawImage(img2, 0, 0)
        # document.getElementById('merged').src = ctx.toDataURL()

load = (src, onload) ->
    # http://www.thefutureoftheweb.com/blog/image-onload-isnt-being-called
    img = new Image()
    img.onload = onload
    img.src = src
    img

img1 = load('http://upload.wikimedia.org/wikipedia/en/2/24/Lenna.png', on_load)
img2 = load('http://introcs.cs.princeton.edu/java/31datatype/peppers.jpg', on_load)
