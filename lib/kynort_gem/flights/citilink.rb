module Kynort::Flights::Citilink
  module_function

  def search(request_guid, query)
    raise "Query must be an instance of Kynort::Flights::Query" unless query.is_a?(Kynort::Flights::Query)
    query_hash = query.to_hash
    query_hash[:request_guid] = request_guid
    reply = RestClient.post "http://localhost:4001/api/v1/flights/search/citilink.json", query_hash
    reply
  end

  def quote_final_price(request_guid, query, go_flight_key, return_flight_key = nil)
    raise "Query must be an instance of Kynort::FLights::Query" unless query.is_a?(Kynort::Flights::Query)
    query_hash = query.to_hash

    reply = RestClient.post "http://localhost:4001/api/v1/flights/quote/citilink", query_hash
    reply
  end

  def book(request_guid, query)
    raise "Query must be an instance of Kynort::Flights::Query" unless query.is_a?(Kynort::Flights::Query)
    raise "There is no passenger, please fill the passenger data" if query.passengers.nil?

    validate_booking! query

    query_hash = query.to_hash
    query_hash[:request_guid] = request_guid
    reply = RestClient.post "http://localhost:4001/api/v1/flights/book/citilink.json", query_hash
    reply
  end

  def validate_booking!(query)
    validate_passenger_data! query
    # passenger phone must present
    raise "Passenger phone cannot be blank" if query.passenger_phone.blank?
  end

  # return errors of each passengers grouped by the passenger's index
  def validate_passenger_data!(query)
    query.passengers.each { |pax| pax.validate! }
  end
end