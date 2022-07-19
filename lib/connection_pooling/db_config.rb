# frozen_string_literal: true

class ConnectionPooling
  class DbConfig < ActiveRecord::DatabaseConfigurations::DatabaseConfig
    CONFIG_KEYS = %i[
      adapter pool min_threads max_threads
      checkout_timeout reaping_frequency idle_timeout
    ].freeze

    def initialize(spec, env_name, name)
      super(env_name, name)
      @spec = spec
    end

    CONFIG_KEYS.each do |conf|
      define_method(:"#{conf}") do
        @spec[conf]
      end
    end
  end
end
