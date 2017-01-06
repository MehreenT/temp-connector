require 'spec_helper'

describe Entities::Deal do

  describe 'class methods' do
    subject { Entities::Deal }

    it { expect(subject.connec_entity_name).to eql('Opportunities') }
    it { expect(subject.external_entity_name).to eql('Deal') }
    it { expect(subject.object_name_from_connec_entity_hash({ name: 'abc' }.with_indifferent_access)).to eql('abc') }
    it { expect(subject.object_name_from_external_entity_hash({ title: 'xyz' }.with_indifferent_access)).to eql('xyz') }
  end

  describe 'instance methods' do
    let(:organization) { create(:organization) }
    let(:connec_client) { Maestrano::Connector::Rails::ConnecHelper.get_client(organization) }
    let(:external_client) { Maestrano::Connector::Rails::External.get_client(organization) }
    let(:opts) { {} }
    subject { Entities::Deal.new(organization, connec_client, external_client, opts) }

    describe 'external to connec!' do
      let(:external_hash) {
        {
          id: 'id-deal1',
          title: 'Deal 1',
          status: 'Active',
          value: 18,
          expected_close_date: '27-01-2017',
          next_activity_subject: 'abc',
          org_id: {
            value: 1,
          },
          creator_user_id: {
            id: 2,
          },
          add_time: 2285824789,
          update_time: 2285824799,
        }.with_indifferent_access
      }

      let (:connec_hash) {
        {
          id: [{ id: 'id-deal1', provider: organization.oauth_provider, realm: organization.oauth_uid }],
          lead_id: [{ id: 1, provider: organization.oauth_provider, realm: organization.oauth_uid }],
          assignee_id: [{ id: 2, provider: organization.oauth_provider, realm: organization.oauth_uid }],
          assignee_type: 'AppUser',
          name: 'Deal 1',
          sales_stage: 'Active',
          amount: {
            total_amount: 18,
          },
          expected_close_date: '27-01-2017',
          next_step: 'abc',
        }.with_indifferent_access
      }

      it { expect(subject.map_to_connec(external_hash)).to eql(connec_hash) }
    end

    describe 'connec to external' do
      let(:connec_hash) {
        {
          name: 'Deal 2',
          sales_stage: 'Active',
          amount: {
            total_amount: 15,
          },
          expected_close_date: '15-02-2017',
          next_step: 'xyz',
        }.with_indifferent_access
      }

      let(:external_hash) {
        {
          title: 'Deal 2',
          status: 'Active',
          value: 15,
          expected_close_date: '15-02-2017',
          next_activity_subject: 'xyz',
        }.with_indifferent_access
      }

      it { expect(subject.map_to_external(connec_hash)).to eql(external_hash) }
    end
  end

end
