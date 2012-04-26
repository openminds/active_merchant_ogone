# Ogone Integration developed by Openminds (www.openminds.be)
# For problems contact us at ogone@openminds.be
require 'active_merchant'
require 'active_merchant_ogone/helper.rb'
require 'active_merchant_ogone/notification.rb'

module ActiveMerchant #:nodoc:
  module Billing #:nodoc:
    module Integrations #:nodoc:
      module Ogone
        
        INBOUND_ENCRYPTED_VARIABLES = %w(
  AAVADDRESS AAVCHECK AAVZIP ACCEPTANCE ALIAS AMOUNT BRAND CARDNO CCCTY CN COMPLUS CREATION_STATUS CURRENCY CVCCHECK DCC_COMMPERCENTAGE DCC_CONVAMOUNT DCC_CONVCCY DCC_EXCHRATE DCC_EXCHRATESOURCE DCC_EXCHRATETS DCC_INDICATOR DCC_MARGINPERCENTAGE DCC_VALIDHOURS DIGESTCARDNO ECI ED ENCCARDNO IP IPCTY NBREMAILUSAGE NBRIPUSAGE NBRIPUSAGE_ALLTX NBRUSAGE NCERROR ORDERID PAYID PM SCO_CATEGORY SCORING SHA-OUT STATUS SUBSCRIPTION_ID TRXDATE VC )
        
        mattr_accessor :inbound_signature
        mattr_accessor :outbound_signature
        
        mattr_accessor :test_service_url
        mattr_accessor :live_service_url
        
        self.test_service_url = 'https://secure.ogone.com/ncol/test/orderstandard_utf8.asp'
        self.live_service_url = 'https://secure.ogone.com/ncol/prod/orderstandard_utf8.asp'
        
        def self.setup
          yield(self)
        end
        
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
        
        def self.outbound_message_signature(fields, signature=nil)
          signature ||= self.outbound_signature
          datastring = fields.select {|k, v| !v.blank? }.
                              sort_by {|k, v| k.upcase }.
                              collect{|key, value| "#{key.upcase}=#{value}#{signature}"}.join
                              
          Digest::SHA1.hexdigest(datastring).upcase
        end
        
        def self.inbound_message_signature(fields, signature=nil)
          signature ||= self.inbound_signature
          datastring = fields.select  {|k, v| !v.blank? && INBOUND_ENCRYPTED_VARIABLES.include?(k.upcase) }.
                              sort_by {|k, v| INBOUND_ENCRYPTED_VARIABLES.index(k.upcase) }.
                              collect {|key, value| "#{key.upcase}=#{value}#{signature}"}.join
                             
          Digest::SHA1.hexdigest(datastring).upcase
        end
      end
    end
  end

  class OgoneError < ActiveMerchantError; end
end

