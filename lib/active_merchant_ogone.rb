# Ogone Integration developed by Openminds (www.openminds.be)
# For problems contact us at ogone@openminds.be
require 'active_merchant'
require 'active_merchant_ogone/helper.rb'
require 'active_merchant_ogone/notification.rb'

module ActiveMerchant #:nodoc:
  module Billing #:nodoc:
    module Integrations #:nodoc:
      module Ogone

        mattr_accessor :test_service_url
        mattr_accessor :live_service_url
        
        self.test_service_url = 'https://secure.ogone.com/ncol/test/orderstandard.asp'
        self.live_service_url = 'https://secure.ogone.com/ncol/prod/orderstandard.asp'
        
        
        def self.service_url
          mode = ActiveMerchant::Billing::Base.integration_mode
          case mode
          when :production then self.live_service_url
          when :test       then self.test_service_url
          else
            raise StandardError, "Integration mode set to an invalid value: #{mode}"
          end
        end
        
        def self.notification(post, options={})
          Notification.new(post, options={})
        end
        
        def self.outbound_message_signature(fields, signature)
          keys = ['orderID','amount','currency','PSPID']
          datastring = keys.collect{|key| fields[key]}.join('')
          Digest::SHA1.hexdigest("#{datastring}#{signature}").upcase
        end
        
        def self.inbound_message_signature(fields, signature)
          keys = ['orderID','currency','amount','PM','ACCEPTANCE','STATUS','CARDNO','PAYID','NCERROR','BRAND']
          datastring = keys.collect{|key| fields[key]}.join('')
          Digest::SHA1.hexdigest("#{datastring}#{signature}").upcase
        end
        
      end
    end
  end

  class OgoneError < ActiveMerchantError; end
end

