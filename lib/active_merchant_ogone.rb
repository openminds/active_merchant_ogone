# Ogone Integration developed by Openminds (www.openminds.be)
# For problems contact us at ogone@openminds.be
require 'active_merchant'
require 'active_merchant_ogone/helper.rb'
require 'active_merchant_ogone/notification.rb'

module ActiveMerchant #:nodoc:
  module Billing #:nodoc:
    module Integrations #:nodoc:
      module Ogone
        TEST_URL = 'https://secure.ogone.com/ncol/test/orderstandard.asp'
        LIVE_URL = 'https://secure.ogone.com/ncol/prod/orderstandard.asp'

        mattr_accessor :service_url
        class << self
          def service_url
            mode = ActiveMerchant::Billing::Base.integration_mode
            case mode
            when :production
              LIVE_URL
            when :test
              TEST_URL
            else
              raise StandardError, "Integration mode set to an invalid value: #{mode}"
            end
          end

          def notification(post, options)
            Notification.new(post, options)
          end

          def SHASign_out(fields, signature)
            keys = ['orderID','amount','currency','PSPID']
            datastring = keys.collect{|key| fields[key]}.join('')
            Digest::SHA1.hexdigest("#{datastring}#{signature}").upcase
          end

          def SHASign_in(fields, signature)
            keys = ['orderID','currency','amount','PM','ACCEPTANCE','STATUS','CARDNO','PAYID','NCERROR','BRAND']
            datastring = keys.collect{|key| fields[key]}.join('')
            Digest::SHA1.hexdigest("#{datastring}#{signature}").upcase
          end
        end
      end
    end
  end

  class OgoneError < ActiveMerchantError; end
end

