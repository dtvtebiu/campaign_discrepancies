# frozen_string_literal: true

module Services
  class CampaignComparator
    ATTRIBUTE_NAME_MAPPING = { status: :status, description: :ad_description }.freeze

    def initialize(local_campaign:, remote_campaign:)
      @local_campaign = local_campaign
      @remote_campaign = remote_campaign
    end

    def call
      ATTRIBUTE_NAME_MAPPING.each_with_object({}) do |(remote_attribute_name, local_attribute_name), discrepancy|
        remote_attribute_value = @remote_campaign.send(remote_attribute_name)
        local_attribute_value = @local_campaign.send(local_attribute_name)

        next if remote_attribute_value == local_attribute_value

        discrepancy[remote_attribute_name] = { remote: remote_attribute_value, local: local_attribute_value }
      end
    end
  end
end
