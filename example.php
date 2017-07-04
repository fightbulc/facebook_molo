<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Facebook MoLo</title>
</head>
<body>

<div>
    <a href="#" id="fblogin" style="display:block;width:200px;font-size:20px;background:#4F5E97;color:#FFF;padding:10px;text-align: center;border-radius: 4px">FB LOGIN</a>
    <div id="fbconnected" style="display:none;width:200px;font-size:20px;background:#45AF66;color:#FFF;padding:10px;text-align: center;border-radius: 4px">FB CONNECTED</div>
    <p>Find the auth response in the console</p>
</div>

<script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>
<script src="facebook-molo.min.js?v=<?= time() ?>"></script>

<script>
    window.fbAsyncInit = function () {
        FB.init({
            appId: '946621778709815',
            xfbml: true,
            version: 'v2.8'
        });

        var fbMolo = new FacebookMoLo(FB, '946621778709815', 'public_profile,user_photos', true);

        var authCallback = function (response) {
            console.log('AUTH CALLBACK', response);

            if (response.status === 'connected') {
                $('#fblogin').hide();
                $('#fbconnected').css('display', 'block');
            }
        };

        if (fbMolo.isSuccessfulCallback()) {
            fbMolo.authenticate(authCallback);
        }

        $('#fblogin').click(function (e) {
            e.preventDefault();
            fbMolo.authenticate(authCallback);
        });
    };

    (function (d, s, id) {
        var js, fjs = d.getElementsByTagName(s)[0];
        if (d.getElementById(id)) {
            return;
        }
        js = d.createElement(s);
        js.id = id;
        js.src = "//connect.facebook.net/en_US/sdk.js";
        fjs.parentNode.insertBefore(js, fjs);
    }(document, 'script', 'facebook-jssdk'));
</script>

</body>
</html>