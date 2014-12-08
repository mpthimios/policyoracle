class Tenant < ActiveRecord::Base
  has_many :categories

  class << self
    def current
      Thread.current[:current_tenant]
    end

    def current=(tenant)
      Thread.current[:current_tenant] = tenant
    end
  end
end
