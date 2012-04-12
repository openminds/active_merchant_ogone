require 'test_helper'

class OgoneNotificationTest < Test::Unit::TestCase
  include ActiveMerchant::Billing::Integrations

  Ogone.inbound_signature = '08445a31a78661b5c746feff39a9db6e4e2cc5cf'

  SUCCESSFULL_HTTP_RAW_DATA = "orderID=order_342&currency=EUR&amount=50&PM=CreditCard&ACCEPTANCE=test123&STATUS=9&CARDNO=XXXXXXXXXXXX1111&PAYID=2396925&NCERROR=0&BRAND=VISA&IPCTY=BE&CCCTY=US&ECI=7&CVCCheck=NO&AAVCheck=NO&VC=NO&SHASIGN=0B5DB4D379C32331939DA40DCCA16B1556FB6256&IP=82.146.99.233"

  FAULTY_HTTP_RAW_DATA = "orderID=order_342&currency=EUR&amount=50&PM=CreditCard&ACCEPTANCE=test123&STATUS=abc&CARDNO=XXXXXXXXXXXX1111&PAYID=2396925&NCERROR=0&BRAND=VISA&IPCTY=BE&CCCTY=US&ECI=7&CVCCheck=NO&AAVCheck=NO&VC=NO&SHASIGN=0B5DB4D379C32331939DA40DCCA16B1556FB6256&IP=82.146.99.233"

  def setup
    @ogone = Ogone::Notification.new(SUCCESSFULL_HTTP_RAW_DATA)
  end

  def test_accessors
    assert @ogone.complete?
    assert_equal "Completed", @ogone.status
    assert_equal "2396925", @ogone.transaction_id
    assert_equal 50.0, @ogone.gross
    assert_equal "EUR", @ogone.currency
  end

  def test_status_completed
    assert_equal "Completed", @ogone.status
  end

  def test_compositions
    assert_equal Money.new(5000, 'EUR'), @ogone.amount
  end

  def test_invalid_status_should_raise_an_error
    assert_raise(ActiveMerchant::OgoneError) do
      Ogone::Notification.new(FAULTY_HTTP_RAW_DATA)
    end
  end

end
