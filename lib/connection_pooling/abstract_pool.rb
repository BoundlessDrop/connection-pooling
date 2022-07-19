# frozen_string_literal: true

class ConnectionPooling
  class AbstractPool < ActiveRecord::ConnectionAdapters::ConnectionPool
    def initialize(spec, client_spec, adapter_klass)
      super(spec)

      @adapter_klass = adapter_klass
      @client_spec = client_spec
    end

    def new_connection
      @adapter_klass.new(@client_spec)
    end
  end
end

