class Entities::Organization < Maestrano::Connector::Rails::Entity
  def self.connec_entity_name
    'Organization'
  end

  def self.external_entity_name
    'Organization'
  end

  def self.mapper_class
    OrganizationMapper
  end

  def self.object_name_from_connec_entity_hash(entity)
    entity['name']
  end

  def self.object_name_from_external_entity_hash(entity)
    entity['name']
  end
end

class OrganizationMapper
  extend HashMapper

  map from('name'), to('name')
  map from('code'), to('company_id')
  map from('number_of_employees'), to('people_count')
  map from('address/billing/line1'), to('address_admin_area_level_1')
  map from('address/billing/line2'), to('address_admin_area_level_2')
  map from('address/billing/postal_code'), to('address_postal_code')
  map from('address/billing/country'), to('address_country')
end

