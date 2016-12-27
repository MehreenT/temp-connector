require 'pipedrive-ruby'
class PipedriveClient

  def initialize(organization)
    @organization = organization
  end

  def perform(method, entity_name, opts = {})
    authenticate_entity(entity_name)
    case method
      when :fetch
        results = fetch(entity_name, opts)
        log(:info, 'Succesfully fetched', entity_name)
      when :create
        results = create(entity_name, opts[:params])
        log(:info, 'Succesfully created', entity_name)
      when :update
        results = update(entity_name, opts[:entity_id], opts[:params])
        log(:info, 'Succesfully updated', entity_name, opts[:entity_id])
      end
    results
    rescue HTTParty::ResponseError => error
      log(:warn, error.response['error'], entity_name, opts[:entity_id])
    rescue StandardError => error
      log(:warn, error, entity_name, opts[:entity_id])
  end

  def fetch(entity_name, params)
    entities = pipedrive_entity_name(entity_name).all(nil, query: { limit:  params[:__limit], start: params[:__skip] })

    entities.collect do |entity|
      JSON.parse(entity.to_json)['table'] if require_syncronization?(params[:last_sync_date], entity)
    end.compact
  end

  def create(entity_name, params)
    pipedrive_entity_name(entity_name).create(params)
  end

  def update(entity_name, entity_id, params)
    entity = find(entity_name, entity_id)
    entity.present? ? entity.update(params) : create(entity_name, params)
  end

  def log(type, message, external_entity_name = nil, external_id = nil)
    return Maestrano::Connector::Rails::ConnectorLogger.log(type, @organization, message) if [:warn].exclude?(type)
    Maestrano::Connector::Rails::ConnectorLogger.log(type, @organization, message, { external_entity_name: external_entity_name, external_id: external_id, message: message })
    raise message
   end

  def find(entity_name, entity_id)
    pipedrive_entity_name(entity_name).find(entity_id)
    rescue HTTParty::ResponseError => error
      nil
  end

  class << self

    def authorization(email, password)
      Pipedrive::Base.post('/authorizations', body: { email: email, password: password })
    end

  end

  private
    def pipedrive_entity_name(entity_name)
      "Pipedrive::#{entity_name}".constantize
    end

    def require_syncronization?(last_sync_date, parsed_entity)
      creation_time = parsed_entity['add_time'].nil? ? parsed_entity['created'] : parsed_entity['add_time']
      last_sync_date.nil? || (creation_time.to_date >= last_sync_date.to_date)
    end

    def authenticate_entity(entity_name)
      "Pipedrive::#{entity_name}".constantize.authenticate(@organization.oauth_token)
    end
end
