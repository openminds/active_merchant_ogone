require 'test_helper'

class ActiveMerchantOgoneTest < Test::Unit::TestCase
  include ActiveMerchant::Billing::Integrations

  def test_sha1_signature_out
    # input values and return value taken from BASIC documentation
    data = {'orderID'  => '1234',
            'currency' => 'EUR',
            'amount'   => 1500,
            'PSPID'    => 'MyPSPID',
            'operation' => 'RES' }

    signature = 'Mysecretsig1875!?'

    assert_equal 'EB52902BCC4B50DC1250E5A7C1068ECF97751256',
      Ogone.outbound_message_signature(data, signature)
  end

  def test_sha1_signature_in
    # input values and return value taken from BASIC documentation
    data = {'orderID'    => '12',
            'currency'   => 'EUR',
            'amount'     => '15',
            'PM'         => 'CreditCard',
            'ACCEPTANCE' => '1234',
            'STATUS'     => '9',
            'CARDNO'     => 'xxxxxxxxxxxx1111',
            'PAYID'      => '32100123',
            'NCERROR'    => '0',
            'BRAND'      => 'VISA'}

    signature = 'Mysecretsig1875!?'

    assert_equal 'B209960D5703DD1047F95A0F97655FFE5AC8BD52',
      Ogone.inbound_message_signature(data, signature)
  end
end
