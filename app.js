// Generated by CoffeeScript 1.10.0
(function() {
  var App, alert, canvas, ctx;

  alert = function(message) {
    $('#message').html(message).removeClass('hide').show();
    return setTimeout(function() {
      return $('#message').hide();
    }, 3000);
  };

  App = (function() {
    function App(app_id) {
      this.app_id = app_id;
      this.loaded = 0;
    }

    App.prototype.load_fb_sdk = function() {
      var d, fjs, id, js, s;
      d = document;
      s = 'script';
      id = 'facebook-jssdk';
      fjs = document.getElementsByTagName('script')[0];
      if (!document.getElementById(id)) {
        js = document.createElement('script');
        js.id = id;
        js.src = "//connect.facebook.net/en_US/sdk.js";
        return fjs.parentNode.insertBefore(js, fjs);
      }
    };

    App.prototype.init_fb = function() {
      FB.init({
        appId: this.app_id,
        cookie: true,
        xfbml: true,
        version: 'v2.5'
      });
      return this.check_login_state();
    };

    App.prototype.on_status_change = function(login_response) {
      if (login_response.status === 'connected') {
        return this.on_connected(login_response.authResponse);
      } else if (login_response.status === 'not_authorized') {
        return alert("로그인해주세요.");
      } else {
        return alert("페이스북으로 로그인해주세요.");
      }
    };

    App.prototype.on_connected = function(auth_response) {
      var profile_image_url;
      profile_image_url = "http://graph.facebook.com/" + auth_response.userID + "/picture?width=200&height=200";
      this.merge(profile_image_url);
      return FB.api('/me', function(response) {
        return alert(response.name + "님. 로그인하셨습니다.");
      });
    };

    App.prototype.check_login_state = function() {
      var me;
      me = this;
      return FB.getLoginStatus(function(response) {
        return me.on_status_change(response);
      });
    };

    App.prototype.load = function(src, onload) {
      var img;
      img = new Image();
      img.onload = onload;
      img.src = src;
      return img;
    };

    App.prototype.on_image_load = function() {
      this.loaded += 1;
      console.log("image loaded : " + this.loaded);
      if (this.loaded === 2) {
        ctx.drawImage(this.img1, 0, 0);
        return ctx.drawImage(this.img2, 0, 0);
      }
    };

    App.prototype.merge = function(source_url) {
      this.loaded = 0;
      this.img1 = this.load(source_url, this.on_image_load);
      return this.img2 = this.load('taegeuk-opacity-50.png', this.on_image_load);
    };

    return App;

  })();

  window.app = new App("1507474466213153");

  app.load_fb_sdk();

  window.fbAsyncInit = function() {
    return app.init_fb();
  };

  canvas = document.getElementById("canvas");

  ctx = canvas.getContext("2d");

}).call(this);
