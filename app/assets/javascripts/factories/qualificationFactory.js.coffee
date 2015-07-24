# class to hold qualification data
# keeps data structure of the test data away from the display
# and could easily update to monitor timestamps of individual
# qualificatiosn# rather than just the whole dataset.
@gojimoTestApp.factory 'qualification', [  ()->
  class qualification
    constructor: (qualificationData) ->

      @name = qualificationData.name

      # extract the country name from the data
      if qualificationData.country && qualificationData.country.name
        @country = qualificationData.country.name
        @nameWithCountry = "#{qualificationData.name} (#{@country})"
      else
        @nameWithCountry = @name
        @country = null


      #extract the subjects from the data
      @subjects = qualificationData.subjects
      if @subjects? && @subjects.length > 0
        @subjectMsg = "#{@subjects.length} subjects available"
      else
        @subjectMsg = "No subjects available"

]