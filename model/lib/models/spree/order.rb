require 'models/spree/payment'
require 'models/spree/customer'
require 'models/spree/item'
require 'exceptions/spree/attribute_locked'

module Spree
  class Order

    include Virtus.model

    attr_accessor :state
    attr_accessor :created_at

    attribute :number, String
    attribute :payments, Array[Spree::Payment]
    attribute :items, Array[Spree::Item]
    attribute :customer, Spree::Customer

    def cancel!
      self.state = 'canceled'
    end

    def save!
      self.created_at = Time.now
    end

    def payments=(payments)
      raise Spree::AttributeLocked.new('Payments cannot be changed on a saved instance') if persisted?
      super payments
    end

    def items=(items)
      raise Spree::AttributeLocked.new('Items cannot be changed on a saved instance') if persisted?
      super items
    end

    def customer=(customer)
      raise Spree::AttributeLocked.new('Customer cannot be changed on a saved instance') if persisted?
      super customer
    end

    private

    def persisted?
      self.created_at || false
    end

  end
end