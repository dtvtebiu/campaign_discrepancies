# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Services::CampaignComparator do
  let(:local_campaign) do
    Campaign.new(external_reference: '1', status: 'enabled', ad_description: 'Description for campaign 11')
  end

  subject(:campaign_comparator) do
    described_class.new(local_campaign: local_campaign, remote_campaign: remote_campaign)
  end

  describe '#call' do
    context 'when remote and local compaign have no discrepancies' do
      let(:remote_campaign) { Structs::RemoteCampaign.new('1', 'enabled', 'Description for campaign 11') }

      it { expect(campaign_comparator.call).to eq({}) }
    end

    context 'when remote and local compaign have a different description' do
      let(:remote_campaign) { Structs::RemoteCampaign.new('1', 'enabled', 'Description for campaign 99') }

      it do
        expect(campaign_comparator.call)
          .to eq({ description: { local: 'Description for campaign 11', remote: 'Description for campaign 99' } })
      end
    end
  end
end
