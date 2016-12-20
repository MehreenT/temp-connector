# frozen_string_literal: true
class Maestrano::Connector::Rails::Entity < Maestrano::Connector::Rails::EntityBase
  include Maestrano::Connector::Rails::Concerns::Entity

  # In this class and in all entities which inherit from it, the following instance variables are available:
  # * @organization
  # * @connec_client
  # * @external_client
  # * @opts

  # Return an array of entities from the external app
  def get_external_entities(external_entity_name, last_synchronization_date = nil)
    Maestrano::Connector::Rails::ConnectorLogger.log('info', @organization, "Fetching #{Maestrano::Connector::Rails::External.external_name} #{self.class.external_entity_name.pluralize}")

    last_synchronization_date = nil if @opts[:full_sync]
    fetch_opts = {
      last_sync_date: last_synchronization_date,
    }
    entities = @external_client.perform(:fetch, external_entity_name, @opts.merge(fetch_opts))

    Maestrano::Connector::Rails::ConnectorLogger.log('info', @organization, "Received data: Source=#{Maestrano::Connector::Rails::External.external_name}, Entity=#{self.class.external_entity_name}, Response=#{entities}")
    entities
  end

  def create_external_entity(mapped_connec_entity, external_entity_name)
    Maestrano::Connector::Rails::ConnectorLogger.log('info', @organization, "Sending create #{external_entity_name}: #{mapped_connec_entity} to #{Maestrano::Connector::Rails::External.external_name}")

    create_opts = {
      params: mapped_connec_entity,
    }
    @external_client.perform(:create, external_entity_name, create_opts)
  end

  def update_external_entity(mapped_connec_entity, external_id, external_entity_name)
    Maestrano::Connector::Rails::ConnectorLogger.log('info', @organization, "Sending update #{external_entity_name} (id=#{external_id}): #{mapped_connec_entity} to #{Maestrano::Connector::Rails::External.external_name}")

    update_opts = {
      entity_id: external_id,
      params: mapped_connec_entity,
    }
    @external_client.perform(:update, external_entity_name, update_opts)
  end

  def self.id_from_external_entity_hash(entity)
    entity['id']
  end

  def self.last_update_date_from_external_entity_hash(entity)
    entity['update_time'] || entity['modified']
  end

  def self.creation_date_from_external_entity_hash(entity)
    entity['add_time'] || entity['created']
  end

  def self.inactive_from_external_entity_hash?(entity)
    # TODO
    # This method return true is entity is inactive in the external application
    # e.g entity['status'] == 'INACTIVE'
  end
end
