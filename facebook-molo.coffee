#
# Facebook MoLo (mobile login)
# Helper to ease facebook login across all mobile browsers
#

class FacebookMoLo
  fbCallbackParam: 'fbauthcallback=1'

  constructor: (@facebook, @appId, @scope) ->

  # ---------------------------------------------

  isSuccessfulCallback: (uri = null) ->
    uri = window.location.href if uri is null
    new RegExp(@fbCallbackParam).test(window.location.href) and /error=/.test(uri) is false

  # ---------------------------------------------

  authenticate: (callback, redirectUri = null) ->
    # autoset redirect uri
    redirectUri = window.location.href if redirectUri is null

    @facebook.getLoginStatus (authResponse) =>
      return callback(authResponse) if authResponse && authResponse.status is 'connected'

      # we need to login first
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
    window.location.href =
      "https://m.facebook.com/dialog/oauth?" +
        "client_id=" + @appId +
        "&scope=" + @scope +
        "&redirect_uri=" + encodeURIComponent(redirect.href)
