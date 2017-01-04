require 'spec_helper'

describe OauthController, type: :controller do
  let(:organization) { create(:organization) }

  describe 'create_omniauth' do
    let(:provider) { 'pipedrive' }
    let(:valid_email) { 'mehreentahir18@gmail.com' }
    let(:invalid_email) { 'abc@xyz.com' }
    let(:password) { 'mehreen19' }

    subject { get :create_omniauth, provider: provider, email: valid_email, password: password }

    before { allow_any_instance_of(Maestrano::Connector::Rails::SessionHelper).to receive(:current_organization).and_return(organization) }

    context 'when not admin' do
      before { allow_any_instance_of(Maestrano::Connector::Rails::SessionHelper).to receive(:is_admin).and_return(false) }
      it { expect(subject).to redirect_to(root_url) }
    end

    context 'when admin' do
      before { allow_any_instance_of(Maestrano::Connector::Rails::SessionHelper).to receive(:is_admin).and_return(true) }

      context 'credentials are valid' do
        it { expect { subject }.to change { organization.oauth_token } }
      end

      context 'credentails are invalid' do
        it 'error flashed' do
         get :create_omniauth, provider: provider, email: invalid_email, password: password
         expect(flash[:warning]).to start_with 'Error validating the credentials'
        end
      end
    end
  end

  describe 'destroy_omniauth' do
    subject { get :destroy_omniauth, organization_id: id }

    before { allow_any_instance_of(Maestrano::Connector::Rails::SessionHelper).to receive(:current_organization).and_return(organization) }

    context 'when no organization is found' do
      let(:id) { 9 }

      it { expect { subject }.to_not change { organization.oauth_token } }
    end

    context 'when organization is found' do
      let(:id) { organization.id }
      let(:user) { Maestrano::Connector::Rails::User.new(email: 'mehreen@mail.com', tenant: 'default') }

      before { allow_any_instance_of(Maestrano::Connector::Rails::SessionHelper).to receive(:current_user).and_return(user) }

      context 'when not admin' do
        before { allow_any_instance_of(Maestrano::Connector::Rails::SessionHelper).to receive(:is_admin?).and_return(false) }

        it { expect { subject }.to_not change { organization.oauth_token } }
      end

      context 'when admin' do
        before { allow_any_instance_of(Maestrano::Connector::Rails::SessionHelper).to receive(:is_admin?).and_return(true) }

        it 'clear omniauth fields' do
          subject
          organization.reload
          expect(organization.oauth_token).to be_nil
        end
      end
    end
  end

end
