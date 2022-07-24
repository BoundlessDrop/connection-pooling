# frozen_string_literal: true

class ConnectionPooling
  # This class servers as a simple interface for implmenting a specific DB adapter
  class AbstractConnectionAdapter < ActiveRecord::ConnectionAdapters::AbstractAdapter
    attr_accessor :pool
    attr_reader :owner, :lock, :conn
    alias in_use? :owner

    def initialize(connection = nil)
      raise NotImplementedError if connection.nil?

      super
    end

    def disconnect!
      raise NotImplementedError
    end

    def reconnect!
      raise NotImplementedError
    end

    def active?
      raise NotImplementedError
    end

    def reset!
      raise NotImplementedError
    end

    def discard!
      raise NotImplementedError
    end

    def verify!
      raise NotImplementedError
    end

    def _run_checkout_callbacks
      yield
    end

    def _run_checkin_callbacks
      yield
    end
  end
end
