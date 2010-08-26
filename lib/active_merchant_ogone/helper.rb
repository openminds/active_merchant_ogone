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
                             
          def customer(mapping = {})
            add_field('ownertelno', mapping[:phone])
            add_field('EMAIL', mapping[:email])
            add_field('CN', "#{mapping[:first_name]} #{mapping[:last_name]}")
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