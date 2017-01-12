require 'spec_helper'

describe Entities::Product do

  describe 'class methods' do
    subject { Entities::Product }

    it { expect(subject.connec_entity_name).to eql('Item') }
    it { expect(subject.external_entity_name).to eql('Product') }
    it { expect(subject.object_name_from_connec_entity_hash({ name: 'abc' }.with_indifferent_access)).to eql('abc') }
    it { expect(subject.object_name_from_external_entity_hash({ name: 'xyz' }.with_indifferent_access)).to eql('xyz') }
  end

  describe 'instance methods' do
    let(:organization) { create(:organization) }
    let(:connec_client) { Maestrano::Connector::Rails::ConnecHelper.get_client(organization) }
    let(:external_client) { Maestrano::Connector::Rails::External.get_client(organization) }
    let(:opts) { {} }
    subject { Entities::Product.new(organization, connec_client, external_client, opts) }

    describe 'external to connec!' do
      let(:external_hash) {
        {
          id: 'id-pr1',
          name: 'Product 1',
          code: '1',
          unit: 23,
          prices: [
            {
              currency: '$',
              price: 10,
              cost: 7,
              overhead_cost: 3,
            }
          ],
          selectable: true,
          add_time: 2285824789,
          update_time: 2285824799,
        }.with_indifferent_access
      }

      let (:connec_hash) {
        {
          id: [{ id: 'id-pr1', provider: organization.oauth_provider, realm: organization.oauth_uid }],
          name: 'Product 1',
          code: '1',
          unit: 23,
          sale_price: {
            currency: '$',
            total_amount: 10,
            net_amount: 7,
            tax_amount: 3,
          },
          status: 'ACTIVE',
        }.with_indifferent_access
      }

      it { expect(subject.map_to_connec(external_hash)).to eql(connec_hash) }
    end

    describe 'connec to external' do
      let(:connec_hash) {
        {
          name: 'Product 2',
          code: '2',
          unit: 12,
          sale_price: {
            currency: '$',
            total_amount: 15,
            net_amount: 10,
            tax_amount: 5,
           },
          status: 'INACTIVE',
        }.with_indifferent_access
      }

      let(:external_hash) {
        {
          name: 'Product 2',
          code: '2',
          unit: 12,
          prices: [
            {
              currency: '$',
              price: 15,
              cost: 10,
              overhead_cost: 5,
            }
          ],
          selectable: false,
        }.with_indifferent_access
      }

      it { expect(subject.map_to_external(connec_hash)).to eql(external_hash) }
    end
  end

end
