# services json requests from the app
# app requests are for remote data
# interrogates the remote data for validity
# and supplies app with any updated data when
# the apps data is out of date.
class Api::QualificationsController < ApplicationController
  require 'open-uri'

  # app requests contain two parameters
  # 'id'  the id of the remote data being requested
  # 'update_at' the timestamp of the data stored locally by the app
  def show
    # base url of the remote data
    # append the 'id' to this to generate the remote url
    baseUrl = 'https://api.gojimo.net/api/v4/'

    # request the meta data from the remote server and
    # extract the time its data was last updated
    meta = open("#{baseUrl}#{params[:id]}").meta
    update_at = meta["last-modified"].to_date

    # request new data when the local data timestamp pre dates the remote data
    requires_refresh = params[:update_at].blank? || update_at > params[:update_at].to_date

    # request the remote data if it is newer than the local copy
    data = open("#{baseUrl}#{params[:id]}").read if requires_refresh
    # parse any data since we are going to add the data to an object which is then converted to json
    data = JSON.parse(data) unless data.blank?

    # return any data together with timestamps and a flag to show whetjer new data was retrieved
    render json: {new_data: requires_refresh, data: data, update_at: update_at.strftime('%a  %d %b %Y'), check_at: Time.now.strftime('%H:%M  %a  %d %b %Y')}

  end
end
