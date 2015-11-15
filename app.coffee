
alert = (message) ->
    $('#message').html(message).removeClass('hide').show()
    setTimeout ->
        $('#message').hide()
    , 3000

class App
    constructor: (app_id) ->
        @app_id = app_id
        @loaded = 0

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

    on_status_change: (login_response) ->
        # console.log "---- on_status_change ----"
        # console.log login_response
        if login_response.status == 'connected'
            @on_connected(login_response.authResponse)
        else if login_response.status == 'not_authorized'
            alert "로그인해주세요."  # FIXME: 메세지
        else
            alert "페이스북으로 로그인해주세요."  # FIXME: 메세지

    on_connected: (auth_response) ->
        profile_image_url = "http://graph.facebook.com/#{auth_response.userID}/picture?width=200&height=200"
        @merge(profile_image_url)
        FB.api '/me', (response) ->
            alert "#{response.name}님. 로그인하셨습니다."

    check_login_state: ->
        me = @
        FB.getLoginStatus (response) -> me.on_status_change(response)

    #
    # image load
    #
    load: (src, onload) ->
        img = new Image()
        img.onload = onload
        img.src = src
        img

    on_image_load: ->
        @loaded += 1
        console.log "image loaded : #{@loaded}"
        if @loaded == 2
            # composite now
            ctx.drawImage(@img1, 0, 0)
            # ctx.globalAlpha = 0.5
            ctx.drawImage(@img2, 0, 0)
            # document.getElementById('merged').src = ctx.toDataURL()

    merge: (source_url)->
        @loaded = 0
        @img1 = @load(source_url, @on_image_load)
        @img2 = @load('taegeuk-opacity-50.png', @on_image_load)

window.app = new App("1507474466213153")
app.load_fb_sdk()
window.fbAsyncInit = -> app.init_fb()

canvas = document.getElementById("canvas")
ctx = canvas.getContext("2d")

