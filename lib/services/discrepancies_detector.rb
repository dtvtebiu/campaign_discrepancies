# frozen_string_literal: true

module Services
  class DiscrepanciesDetector
    def call
      remote_campaigns = RemoteCampaignsFetcher.new.call
      remote_campaigns.each_with_object([]) do |remote_campaign, discrepancies|
        local_campaign = Campaign.find(external_reference: remote_campaign.reference)

        next unless local_campaign

        discrepancies << {
          remote_reference: remote_campaign.reference,
          discrepancies: CampaignComparator.new(local_campaign: local_campaign, remote_campaign: remote_campaign).call
        }
      end
    end
  end
end
