require 'spec_helper'

describe Entities::Organization do

  describe 'class methods' do
    subject { Entities::Organization }

    it { expect(subject.connec_entity_name).to eql('Organization') }
    it { expect(subject.external_entity_name).to eql('Organization') }
    it { expect(subject.object_name_from_connec_entity_hash({ name: 'abc' }.with_indifferent_access)).to eql('abc') }
    it { expect(subject.object_name_from_external_entity_hash({ name: 'xyz' }.with_indifferent_access)).to eql('xyz') }
  end

  describe 'instance methods' do
    let(:organization) { create(:organization) }
    let(:connec_client) { Maestrano::Connector::Rails::ConnecHelper.get_client(organization) }
    let(:external_client) { Maestrano::Connector::Rails::External.get_client(organization) }
    let(:opts) { {} }
    subject { Entities::Organization.new(organization, connec_client, external_client, opts) }

    describe 'external to connec!' do
      let(:external_hash) {
        {
          id: 'id-org1',
          name: 'organization 1',
          company_id: '1',
          people_count: 23,
          address: 'Address xyz',
          address_locality: 'New York',
          address_postal_code: '5400',
          address_country: 'US',
          add_time: 2285824789,
          update_time: 2285824799,
        }.with_indifferent_access
      }

      let (:connec_hash) {
        {
          id: [{ id: 'id-org1', provider: organization.oauth_provider, realm: organization.oauth_uid }],
          name: 'organization 1',
          code: '1',
          number_of_employees: 23,
          address: {
            billing: {
              line1: 'Address xyz',
              city: 'New York',
              postal_code: '5400',
              country: 'US',
            },
          },
        }.with_indifferent_access
      }

      it { expect(subject.map_to_connec(external_hash)).to eql(connec_hash) }
    end

    describe 'connec to external' do
      let(:connec_hash) {
        {
          name: 'organization 2',
          code: '2',
          number_of_employees: 19,
          address: {
            billing: {
              line1: 'Address abc',
              city: 'New York',
              postal_code: '5400',
              country: 'US',
            },
          },
        }.with_indifferent_access
      }

      let(:external_hash) {
        {
          name: 'organization 2',
          company_id: '2',
          people_count: 19,
          address: 'Address abc',
          address_locality: 'New York',
          address_postal_code: '5400',
          address_country: 'US',
        }.with_indifferent_access
      }

      it { expect(subject.map_to_external(connec_hash)).to eql(external_hash) }
    end
  end

end
