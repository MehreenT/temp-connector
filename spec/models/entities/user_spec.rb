require 'spec_helper'

describe Entities::User do

  describe 'class methods' do
    subject { Entities::User }

    it { expect(subject.connec_entity_name).to eql('App_User') }
    it { expect(subject.external_entity_name).to eql('User') }
    it { expect(subject.object_name_from_connec_entity_hash({ first_name: 'abc', last_name: 'def' }.with_indifferent_access)).to eql('abc def') }
    it { expect(subject.object_name_from_external_entity_hash({ name: 'xyz' }.with_indifferent_access)).to eql('xyz') }
    it { expect(subject.can_update_external?).to eql(false) }
  end

  describe 'instance methods' do
    let(:organization) { create(:organization) }
    let(:connec_client) { Maestrano::Connector::Rails::ConnecHelper.get_client(organization) }
    let(:external_client) { Maestrano::Connector::Rails::External.get_client(organization) }
    let(:opts) { {} }
    subject { Entities::User.new(organization, connec_client, external_client, opts) }


    describe 'external to connec!' do
      let(:external_hash) {
        {
          id: 'id-person1',
          name: 'user 1',
          role_id: 'role 1',
          email: 'mail@gmail.com',
          is_admin: true,
          add_time: 2285824789,
          update_time: 2285824799,
        }.with_indifferent_access
      }

      let (:connec_hash) {
        {
          id: [{ id: 'id-person1', provider: organization.oauth_provider, realm: organization.oauth_uid }],
          first_name: 'user',
          last_name: '1',
          role: 'role 1',
          email: {
            address: 'mail@gmail.com',
          },
          is_admin: true,
        }.with_indifferent_access
      }

      it { expect(subject.map_to_connec(external_hash)).to eql(connec_hash) }
    end

    describe 'connec to external' do
      let(:connec_hash) {
        {
          first_name: 'user',
          last_name: '2',
          role: 'role 2',
          email: {
            address: 'mail@gmail.com',
          },
          is_admin: false,
        }.with_indifferent_access
      }

      let(:external_hash) {
        {
          name: 'user 2',
          role_id: 'role 2',
          email: 'mail@gmail.com',
          is_admin: false,
        }.with_indifferent_access
      }

      it { expect(subject.map_to_external(connec_hash)).to eql(external_hash) }
    end
  end

end
