require 'open-uri'

class MeteorologistController < ApplicationController
  def street_to_weather_form
    # Nothing to do here.
    render("meteorologist/street_to_weather_form.html.erb")
  end

  def street_to_weather
    @street_address = params[:user_street_address]

    address_w_addition = @street_address.gsub(" ","+")
    address_url_first_half = "https://maps.googleapis.com/maps/api/geocode/json?address="
    address_url = address_url_first_half+address_w_addition
    parsed_data = JSON.parse(open(address_url).read)
    latitude = parsed_data["results"][0]["geometry"]["location"]["lat"]
    longitude = parsed_data["results"][0]["geometry"]["location"]["lng"]
    latitude_string = latitude.to_s
    longitude_string = longitude.to_s

    weather_url_first_half = "https://api.darksky.net/forecast/bf39e908bb517967c0dd410a06e19f4c/"
    weather_url = weather_url_first_half+latitude_string+","+longitude_string
    new_parsed_data = JSON.parse(open(weather_url).read)

    current_temperature = new_parsed_data["currently"]["temperature"]
    current_summary = new_parsed_data["currently"]["summary"]
    summary_of_next_sixty_minutes = new_parsed_data["minutely"]["summary"]
    summary_of_next_several_hours = new_parsed_data["hourly"]["summary"]
    summary_of_next_several_days = new_parsed_data["daily"]["summary"]


    @current_temperature = current_temperature

    @current_summary = current_summary

    @summary_of_next_sixty_minutes = summary_of_next_sixty_minutes

    @summary_of_next_several_hours = summary_of_next_several_hours

    @summary_of_next_several_days = summary_of_next_several_days

    render("meteorologist/street_to_weather.html.erb")
  end
end
