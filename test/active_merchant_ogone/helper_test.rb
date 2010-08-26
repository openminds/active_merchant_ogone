require 'test_helper'

class OgoneHelperTest < Test::Unit::TestCase
  include ActiveMerchant::Billing::Integrations

  def setup
    @helper = Ogone::Helper.new('order-500','openminds', :amount => 900, :currency => 'EUR')
  end

  def test_basic_helper_fields
    assert_field 'PSPID', 'openminds'

    assert_field 'orderID', 'order-500'
    assert_field 'amount', '900'
    assert_field 'currency', 'EUR'
  end

  def test_customer_fields
    @helper.customer :first_name => 'Jan', :last_name => 'De Poorter', :email => 'ogone@openminds.be'
    assert_field 'CN', 'Jan De Poorter'
    assert_field 'EMAIL', 'ogone@openminds.be'
  end
  
  def test_operation
    @helper.operation :payment
    assert_field 'operation', 'SAL'
    
    @helper.operation :auth
    assert_field 'operation', 'RES'
    
    @helper.operation 'SAL'
    assert_field 'operation', 'SAL'
  end

  def test_address_mapping
    @helper.billing_address :address1 => 'Zilverenberg 39',
                            :address2 => '',
                            :city => 'Ghent',
                            :zip => '9000',
                            :country  => 'BE'

    assert_field 'owneraddress', 'Zilverenberg 39'
    assert_field 'ownertown', 'Ghent'
    assert_field 'ownerZIP', '9000'
    assert_field 'ownercty', 'BE'
  end

  def test_unknown_mapping
    assert_nothing_raised do
      @helper.company_address :address => 'Zilverenberg 39'
    end
  end

  def test_setting_invalid_address_field
    fields = @helper.fields.dup
    @helper.billing_address :street => 'Zilverenberg'
    assert_equal fields, @helper.fields
  end
end
