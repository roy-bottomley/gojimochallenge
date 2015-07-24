# diretive to flash a message on the screen
# displays nothing until until it receives a flash event
# it then breifly displays the msg sent with the event
@gojimoTestApp.directive( 'flash', [ '$timeout', ($timeout) ->
  return {
  restrict: 'E',
  scope: {
  },

  templateUrl: "flash.html",

  link: (scope, el, attrs) ->
    el.fadeOut(0)

    scope.doFlash= (msg) ->
      # stop and clear and previous message
      el.stop()
      $timeout.cancel( scope.timer ) if scope.timer

      # update the msg
      scope.msg = msg

      #fade the msg in, wait then fade it out
      el.fadeIn(500)
      timer = $timeout(
        () =>
          scope.timer = null
          el.fadeOut(2000)
        , 3000
      )

    # listen for events to flash
    scope.$on("flash", (e, msg) ->
      scope.doFlash(msg)
    )

  }
])
