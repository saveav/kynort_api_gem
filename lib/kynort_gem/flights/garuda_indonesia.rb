class Kynort::Flights::GarudaIndonesia
  class << self
    def search(request_guid, query)
      raise "Query must be an instance of Kynort::Flights::Query" unless query.is_a?(Kynort::Flights::Query)
      query_hash = query.to_hash
      query_hash[:request_guid] = request_guid
      reply = RestClient.post "http://localhost:4001/api/v1/flights/search/garuda.json", query_hash
      reply
    end

    def book(request_guid, query)
      raise "Query must be an instance of Kynort::Flights::Query" unless query.is_a?(Kynort::Flights::Query)
      raise "There is no passenger, please fill the passenger data" if query.passengers.nil?
      query_hash = query.to_hash
      query_hash[:request_guid] = request_guid
      reply = RestClient.post "http://localhost:4001/api/v1/flights/book/garuda.json", query_hash
      reply
    end
  end
end