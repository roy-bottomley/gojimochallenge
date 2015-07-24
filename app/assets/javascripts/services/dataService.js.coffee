# service to set and retreive data
# uses localstorage if available
# otherwise uses server data
# can be forced to use server data
@gojimoTestApp.service 'dataService', [ '$cookieStore',  '$localStorage','$resource',  "$q", ( $cookieStore,  $localStorage, $resource,  $q) ->

    # server address
    rootUrl = '/api/qualifications/:id'

    # called to retreive data
    # if forceCheck true then local data will be used if present
    # if forceCheck false then data will be requested form server
    # server will return an object conatining new data if the remote change has changed
    # or no data if the current local data is still valid
    getData: (id, forceCheck) ->
      # create a promise
      deferred = $q.defer()
      # retrieve the local copy of the data unless forcing data from the server
      data = $localStorage.id  unless forceCheck
      # if there is local data return it
      if data?
        # Resolve the the promise before returning it
        deferred.resolve(data)
      else
        #if no local data request data from the server
        $resource(rootUrl, {id: id, update_at: $localStorage.updateAt}).get().$promise.then (result) =>
          # update the time at which the remote data was checked
          $localStorage.checkAt =  result.check_at
          # determien if there is any new data
          if result.new_data
            # if there is new data update the local store
            $localStorage.id = result.data
            $localStorage.updateAt = result.update_at
          # resolve the promise with and new data
          deferred.resolve(result.data)

      return deferred.promise

    # called to retrieve the date at which the remote data was last checked
    lastCheck: () ->
      if $localStorage.checkAt?
        $localStorage.checkAt
      else
        'Never'

    # called to retrieve the date at which the remote data was last updated
    lastUpdate: () ->
      if $localStorage.updateAt?
        $localStorage.updateAt
      else
        'It must be in the dim and distant past as there is have no record'

    # called to delete all local data
    deleteLocalData: () ->
      $localStorage.$reset()

]