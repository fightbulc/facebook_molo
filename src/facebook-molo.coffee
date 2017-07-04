#
# Facebook MoLo (mobile login)
# Helper to ease facebook login across all mobile browsers
#

class FacebookMoLo
  fbCallbackParam: 'fbauthcallback=1'

  constructor: (@facebook, @appId, @scope, @rerequest = false) ->

  # ---------------------------------------------

  isSuccessfulCallback: (uri = null) ->
    uri = window.location.href if uri is null
    new RegExp(@fbCallbackParam).test(window.location.href) and /error=/.test(uri) is false

  # ---------------------------------------------

  authenticate: (callback, redirectUri = null) ->
    # autoset redirect uri
    redirectUri = window.location.href if redirectUri is null

    @facebook.getLoginStatus (authResponse) =>
      if authResponse && authResponse.status is 'connected'
        @facebook.api '/me/permissions', (response) =>
          permissions = {}
          reLogin = false

          if typeof response.data
            for item in response.data
              permissions[item.permission] = item.status if item.status is 'granted'

          for scope in @scope.split(',')
            reLogin = true if typeof permissions[scope] is 'undefined'

          return callback authResponse if reLogin is false

          @login(redirectUri)

        return

      @login(redirectUri)

# ---------------------------------------------

  login: (redirectUri) ->
    # parse redirect uri
    redirect = document.createElement('a')
    redirect.href = redirectUri

    # attach callback trigger param
    queryParams = []
    queryParams = redirect.search.replace('?', '').split('&') if /\?/.test(redirect.search) is true
    queryParams.push(@fbCallbackParam)
    redirect.search = '?' + queryParams.join('&')

    # redirect to FB for authentication
    href =
      "https://m.facebook.com/dialog/oauth?" +
        "client_id=" + @appId +
        "&scope=" + @scope +
        "&redirect_uri=" + encodeURIComponent(redirect.href)

    # rerequest missing permissions
    href = href + "&auth_type=rerequest" if @rerequest is true

    window.location.href = href