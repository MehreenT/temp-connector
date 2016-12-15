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
    # TODO
    # Returns a link to the sign up page of the external application
    '#'
  end

  # Return an array of all the entities that the connector can synchronize
  # If you add new entities, you need to generate
  # a migration to add them to existing organizations
  def self.entities_list
    # TODO
    # The names in this list should match the names of your entities class
    # e.g %w(person, tasks_list)
    #  will synchronized Entities::Person and Entities::TasksList
    []
  end
end
