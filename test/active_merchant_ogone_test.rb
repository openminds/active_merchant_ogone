require 'test_helper'

class ActiveMerchantOgoneTest < Test::Unit::TestCase
  include ActiveMerchant::Billing::Integrations

  def test_sha1_signature_out
    # input values and return value taken from BASIC documentation
    data = {'orderID' => '1234',
      'currency' => 'EUR',
      'amount' => 1500,
      'PSPID' => 'MyPSPID' }

    signature = 'Mysecretsig'

    assert_equal 'CC88E974F684C0804FD98BEA2FE403E9D11534BB', Ogone.SHASign_out(data, signature)
  end

  def test_sha1_signature_in
    # input values and return value taken from BASIC documentation
    data = {'orderID' => '12',
      'currency' => 'EUR',
      'amount' => '15',
      'PM' => 'CreditCard',
      'ACCEPTANCE' => '1234',
      'STATUS' => '9',
      'CARDNO' => 'xxxxxxxxxxxx1111',
      'PAYID' => '32100123',
      'NCERROR' => '0',
      'BRAND' => 'VISA'}
    signature = 'Mysecretsig'
    assert_equal '6DDD8C4538ACD0462837DB66F5EAB39C58086A29', Ogone.SHASign_in(data, signature)
  end
end
