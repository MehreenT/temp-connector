require 'spec_helper'

describe Entities::Person do

  describe 'class methods' do
    subject { Entities::Person }

    it { expect(subject.connec_entity_name).to eql('Person') }
    it { expect(subject.external_entity_name).to eql('Person') }
    it { expect(subject.object_name_from_connec_entity_hash({ first_name: 'abc', last_name: 'def' }.with_indifferent_access)).to eql('abc def') }
    it { expect(subject.object_name_from_external_entity_hash({ name: 'xyz' }.with_indifferent_access)).to eql('xyz') }
  end

  describe 'instance methods' do
    let(:organization) { create(:organization) }
    let(:connec_client) { Maestrano::Connector::Rails::ConnecHelper.get_client(organization) }
    let(:external_client) { Maestrano::Connector::Rails::External.get_client(organization) }
    let(:opts) { {} }
    subject { Entities::Person.new(organization, connec_client, external_client, opts) }

    describe 'external to connec!' do
      let(:external_hash) {
        {
          id: 'id-person1',
          first_name: 'person',
          last_name: '1',
          name: 'person 1',
          company_id: 'comp-id',
          email: [
            {
              value: 'mail@gmail.com',
            },
          ],
          owner_id: {
            id: 'own-id',
          },
          add_time: 2285824789,
          update_time: 2285824799,
        }.with_indifferent_access
      }

      let (:connec_hash) {
        {
          id: [{ id: 'id-person1', provider: organization.oauth_provider, realm: organization.oauth_uid }],
          organization_id: [{ id: 'comp-id', provider: organization.oauth_provider, realm: organization.oauth_uid }],
          lead_referent_id: [{ id: 'own-id', provider: organization.oauth_provider, realm: organization.oauth_uid }],
          lead_referent_type: 'Entity::Person',
          first_name: 'person',
          last_name: '1',
          is_customer: true,
          email: {
            address: 'mail@gmail.com',
          },
        }.with_indifferent_access
      }

      it { expect(subject.map_to_connec(external_hash)).to eql(connec_hash) }
    end

    describe 'connec to external' do
      let(:connec_hash) {
        {
          first_name: 'person',
          last_name: '2',
          email: {
            address: 'mail@gmail.com',
          },
        }.with_indifferent_access
      }

      let(:external_hash) {
        {
          first_name: 'person',
          last_name: '2',
          name: 'person 2',
          email: [
            {
              value: 'mail@gmail.com',
            },
          ],
        }.with_indifferent_access
      }

      it { expect(subject.map_to_external(connec_hash)).to eql(external_hash) }
    end
  end

end
