class Entities::Person < Maestrano::Connector::Rails::Entity
  def self.connec_entity_name
    'Person'
  end

  def self.external_entity_name
    'Person'
  end

  def self.mapper_class
    PersonMapper
  end

  def self.object_name_from_connec_entity_hash(entity)
    "#{entity['first_name']} #{entity['last_name']}"
  end

  def self.object_name_from_external_entity_hash(entity)
    entity['name']
  end

  def self.references
    %w(organization_id lead_referent_id)
  end
end

class PersonMapper
  extend HashMapper

  # Mapping to PipeDrive
  after_normalize do |input, output|
    output[:name] = [input['first_name'], input['last_name']].join(' ').strip

    output
  end

  # Mapping to Connec!
  after_denormalize do |input, output|
    output[:is_customer] = true
    output[:lead_referent_type] = 'Entity::Person'

    output
  end

  map from('first_name'), to('first_name')
  map from('last_name'), to('last_name')
  map from('email/address'), to('email[0]/value')
  map from('organization_id'), to('company_id')
  map from('lead_referent_id'), to('owner_id/id')
end
