# the only controller in the app
# requests data from the server and presents it to the view
# routes commands from the view to the server and reflects any modificed data to the view
@gojimoTestApp.controller('qualificationController', [ '$scope', 'dataService', 'qualification', ($scope, dataService, qualification)->

  # id of the list of all qualifications
  $scope.qualificationListId = 'qualifications'
  # default the qualifiction sorting to by name
  $scope.sortKey = 'name'

  # update the timestamps shown in the view
  $scope.setUpdateTimes= ()->
    $scope.checkAt = dataService.lastCheck()
    $scope.updateAt = dataService.lastUpdate()

  # called on startup or when user requests a refresh of the stored data
  # retrieve data either from local store or server and display it
  # forceCheck set to false on startup so that local data will be used if present
  # forceCheck set to true when the user requests a refesh
  $scope.getData= (forceCheck) ->
    dataService.getData($scope.qualificationListId, forceCheck).then (result) =>
      # dataService returns an array of hashes containing the new data or null if there is no new data
      if result?
        # update the view if there is new data
        #clear the displayed data
        qualifications = []
        #build an array of qualification objects from the data
        for item in result
          qualifications.push(new qualification(item))

        # update the view once the data is built
        $scope.qualifications = qualifications
        # default to displaying th first qualifications subjects
        $scope.setSelectedQualification( $scope.qualifications[0] )

        #update the views timestamp dsplay
        $scope.setUpdateTimes()

        msg = 'Check complete. New data retrieved and displayed.'
      else
        msg = 'Check complete. No new data.'
      #flash a message to the user to inform them of the result
      $scope.$broadcast("flash", msg) if forceCheck

  # called when user clicks a qualification to update the displayed qualification details
  $scope.setSelectedQualification= (qualification) ->
    $scope.selectedQualification = qualification

  # called when the user clicks Delete
  # removes all local data
  $scope.deleteData= () ->
    if confirm("Are you sure you want to delete all the local data. You may have a long and tedious wait next time you reload!!")
      $scope.qualifications = []
      $scope.selectedQualification = null
      dataService.deleteLocalData()
      $scope.$broadcast("flash", "All the data is gone, this machine is squeaky clean")
      $scope.setUpdateTimes()

  # on startup retreive and display the qualification data
  $scope.getData(false)

])