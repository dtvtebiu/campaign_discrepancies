# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Services::DiscrepanciesDetector do
  subject(:campaign_discrepancies) { described_class.new }

  describe '#call' do
    let(:expected_discrepancies) do
      [
        {
          remote_reference: '1',
          discrepancies: {}
        },
        {
          remote_reference: '2',
          discrepancies: {
            status: {
              remote: 'disabled',
              local: 'enabled'
            }
          }
        },
        {
          remote_reference: '3',
          discrepancies: {
            description: {
              remote: 'Description for campaign 13',
              local: 'Description for campaign 99'
            }
          }
        }
      ]
    end
    let(:campaigns_body) do
      '{ "ads": [ { "reference": "1", "status": "enabled", "description": "Description for campaign 11" }, { "reference": "2", "status": "disabled", "description": "Description for campaign 12" }, { "reference": "3", "status": "enabled", "description": "Description for campaign 13" } ] }'
    end

    before do
      Campaign.insert(external_reference: '1', status: 'enabled', ad_description: 'Description for campaign 11')
      Campaign.insert(external_reference: '2', status: 'enabled', ad_description: 'Description for campaign 12')
      Campaign.insert(external_reference: '3', status: 'enabled', ad_description: 'Description for campaign 99')

      stub_request(:get, Services::RemoteCampaignsFetcher::CAMPAIGNS_URL).to_return(body: campaigns_body)
    end

    it { expect(campaign_discrepancies.call).to eq(expected_discrepancies) }
  end
end
