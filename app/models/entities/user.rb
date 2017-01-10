class Entities::User < Maestrano::Connector::Rails::Entity
  def self.connec_entity_name
    'App_User'
  end

  def self.external_entity_name
    'User'
  end

  def self.mapper_class
    UserMapper
  end

  def self.object_name_from_connec_entity_hash(entity)
    "#{entity['first_name']} #{entity['last_name']}"
  end

  def self.object_name_from_external_entity_hash(entity)
    entity['name']
  end

  def self.can_update_external?
    false
  end
end

class UserMapper
  extend HashMapper

  # Mapping to PipeDrive
  after_normalize do |input, output|
    output[:name] = [input['first_name'], input['last_name']].join(' ').strip

    output
  end

  # Mapping to Connec!
  after_denormalize do |input, output|
    if input['name']
      output[:first_name] = input['name'].split(' ', 2).first
      output[:last_name] = input['name'].split(' ', 2).last
    end
    output
  end

  map from('role'), to('role_id')
  map from('email/address'), to('email')
  map from('is_admin'), to('is_admin')
end
