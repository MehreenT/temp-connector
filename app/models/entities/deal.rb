class Entities::Deal < Maestrano::Connector::Rails::Entity
  def self.connec_entity_name
    'Opportunities'
  end

  def self.external_entity_name
    'Deal'
  end

  def self.mapper_class
    DealMapper
  end

  def self.object_name_from_connec_entity_hash(entity)
    entity['name']
  end

  def self.object_name_from_external_entity_hash(entity)
    entity['title']
  end

  def self.references
    %w(lead_id assignee_id)
  end
end

class DealMapper
  extend HashMapper

  # Mapping to Connec!
  after_denormalize do |input, output|
    output[:assignee_type] = 'AppUser'

    output
  end

  map from('name'), to('title')
  map from('sales_stage'), to('status')
  map from('expected_close_date'), to('expected_close_date')
  map from('amount/total_amount'), to('value')
  map from('next_step'), to('next_activity_subject')
  map from('lead_id'), to('org_id/value')
  map from('assignee_id'), to('creator_user_id/id')
end
