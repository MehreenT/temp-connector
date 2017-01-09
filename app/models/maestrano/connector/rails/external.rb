# frozen_string_literal: true
class Maestrano::Connector::Rails::External
  include Maestrano::Connector::Rails::Concerns::External

  def self.external_name
    'Pipedrive'
  end

  def self.get_client(organization)
    PipedriveClient.new organization
  end

  def self.create_account_link(organization = nil)
    'https://app.pipedrive.com/register'
  end

  def self.entities_list
    %w(user organization product deal)
  end
end
