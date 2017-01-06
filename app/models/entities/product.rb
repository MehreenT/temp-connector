class Entities::Product < Maestrano::Connector::Rails::Entity
  def self.connec_entity_name
    'Item'
  end

  def self.external_entity_name
    'Product'
  end

  def self.mapper_class
    ProductMapper
  end

  def self.object_name_from_connec_entity_hash(entity)
    entity['name']
  end

  def self.object_name_from_external_entity_hash(entity)
    entity['name']
  end
end

class ProductMapper
  extend HashMapper

  map from('name'), to('name')
  map from('code'), to('code')
  map from('unit'), to('unit')
  map from('sale_price/currency'), to('prices[0]/currency')
  map from('sale_price/total_amount'), to('prices[0]/price')
  map from('sale_price/net_amount'), to('prices[0]/cost')
  map from('sale_price/tax_amount'), to('prices[0]/overhead_cost')
end
