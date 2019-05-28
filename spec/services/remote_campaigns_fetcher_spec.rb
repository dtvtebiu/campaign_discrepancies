# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Services::RemoteCampaignsFetcher do
  subject(:remote_campaign_fetcher) { described_class.new }

  describe '#call' do
    let(:campaigns_body) do
      '{ "ads": [ { "reference": "1", "status": "enabled", "description": "Description for campaign 11" }, { "reference": "2", "status": "disabled", "description": "Description for campaign 12" }, { "reference": "3", "status": "enabled", "description": "Description for campaign 13" } ] }'
    end
    let(:expected_remote_campaigns) do
      [
        Structs::RemoteCampaign.new('1', 'enabled', 'Description for campaign 11'),
        Structs::RemoteCampaign.new('2', 'disabled', 'Description for campaign 12'),
        Structs::RemoteCampaign.new('3', 'enabled', 'Description for campaign 13')
      ]
    end

    before { stub_request(:get, described_class::CAMPAIGNS_URL).to_return(body: campaigns_body) }

    it { expect(remote_campaign_fetcher.call).to match_array(expected_remote_campaigns) }
  end
end
