module ActiveMerchant #:nodoc:
  module Billing #:nodoc:
    module Integrations #:nodoc:
      module Ogone
        class Helper < ActiveMerchant::Billing::Integrations::Helper
          
          # required
          mapping :order,    'orderID'
          mapping :account,  'PSPID'
          mapping :amount,   'amount'
          mapping :currency, 'currency'

          # optional - TODO
          mapping :billing_address, :city     => 'ownertown',
                                    :address1 => 'owneraddress',
                                    :zip      => 'ownerZIP',
                                    :country  => 'ownercty'

          # mapping :description, 'COM'
          # mapping :tax, ''
          # mapping :shipping, ''

          # redirection
          mapping :redirect, :accepturl    => 'accepturl',
                             :declineurl   => 'declineurl',
                             :cancelurl    => 'cancelurl',
                             :exceptionurl => 'exceptionurl'
                             
          mapping :language, 'language'
          mapping :template, 'tp'
                             
          def customer(mapping = {})
            add_field('ownertelno', mapping[:phone])
            add_field('EMAIL', mapping[:email])
            add_field('CN', "#{mapping[:first_name]} #{mapping[:last_name]}")
            add_field('CIVILITY', mapping[:civility])
          end
          
          def after_pay(mapping = {})
            # Billing adres
            add_field('ECOM_BILLTO_POSTAL_NAME_FIRST', mapping[:bill_first_name])
            add_field('ECOM_BILLTO_POSTAL_NAME_LAST', mapping[:bill_last_name])
            add_field('ECOM_BILLTO_POSTAL_STREET_NUMBER', mapping[:bill_street_number])
            # Shipping adres
            add_field('ECOM_SHIPTO_POSTAL_NAME_FIRST', mapping[:ship_first_name])
            add_field('ECOM_SHIPTO_POSTAL_NAME_LAST', mapping[:ship_last_name])
            add_field('ECOM_SHIPTO_POSTAL_STREET_LINE1', mapping[:ship_adress])
            add_field('ECOM_SHIPTO_POSTAL_STREET_NUMBER', mapping[:ship_adress_number])
            add_field('ECOM_SHIPTO_POSTAL_POSTALCODE', mapping[:ship_adress_zip])
            add_field('ECOM_SHIPTO_POSTAL_CITY', mapping[:ship_adress_city])
            add_field('ECOM_SHIPTO_POSTAL_COUNTRYCODE', mapping[:ship_adress_country_code])
            add_field('ECOM_SHIPTO_DOB', mapping[:ship_dob])
          end
          
          def operation operation
            op = case operation
            when :authorization, :auth; 'RES'
            when :payment, :pay;        'SAL'
            else;                       operation
            end

            add_field('operation', op)
          end

          # return the fields
          def form_fields
            add_field('SHASign', outbound_message_signature)
            super
          end
          
        private
          
          def outbound_message_signature
            Ogone.outbound_message_signature(@fields)
          end
          
        end
      end
    end
  end
end