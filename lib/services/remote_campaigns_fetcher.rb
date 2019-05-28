# frozen_string_literal: true

require 'json'
require 'open-uri'

module Services
  class RemoteCampaignsFetcher
    CAMPAIGNS_URL = 'https://mockbin.org/bin/fcb30500-7b98-476f-810d-463a0b8fc3df'

    def call
      response_body = URI.parse(CAMPAIGNS_URL).read
      json_body = JSON.parse(response_body)

      json_body['ads'].map { |ad| Structs::RemoteCampaign.new(ad['reference'], ad['status'], ad['description']) }
    end
  end
end
