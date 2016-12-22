class OauthController < ApplicationController

  def create_omniauth
    if is_admin
      response = PipedriveClient.authorization(params[:email], params[:password])
      raise response['error'] unless response.code == 200

      response = response['data'][0]

      current_organization.update(
        oauth_uid: response['company_id'],
        oauth_token: response['api_token'],
        oauth_provider: params[:provider],
        name: response['company']['info']['name']
      )
      Pipedrive.authenticate(response['api_token'])
    end

    redirect_to root_url
    rescue => e
      Maestrano::Connector::Rails::ConnectorLogger.log('warn', current_organization, "Error validating the credentials: #{e.message}, #{e.backtrace.join("\n")}")
      flash[:warning] = "Error validating the credentials #{e.message}"
      redirect_to root_url
  end

  def destroy_omniauth
    if current_organization && is_admin
      current_organization.oauth_uid = nil
      current_organization.oauth_token = nil
      current_organization.oauth_provider = nil
      current_organization.sync_enabled = false
      current_organization.save
    end
    redirect_to root_url
  end
end
