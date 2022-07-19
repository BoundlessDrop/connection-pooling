require 'active_record'
require 'active_record/database_configurations/database_config'
require "connection_pooling/abstract_pool"
require "connection_pooling/abstract_connection_adapter"
require "connection_pooling/db_config"

class ConnectionPooling
  EmptyConfig = Class.new(StandardError)
  DEFAULT_OPTIONS = {
    checkout_timeout: 2,
    idle_timeout: 3,
    pool: 5,
    reaping_frequency: 5
  }

  attr_accessor :pool

  def initialize(spec, client_config, adapter_klass, env_name)
    raise EmptyConfig if client_config.empty? || adapter_klass.blank?

    spec = spec.merge(DEFAULT_OPTIONS)
    db_config = DbConfig.new(spec, env_name, adapter_klass.name)
    pool_config = ActiveRecord::ConnectionAdapters::PoolConfig.new(
      adapter_klass,
      db_config,
      nil,
      nil
    )

    @pool = AbstractPool.new(pool_config, client_config, adapter_klass)
  end

  def method_missing(meth, *args)
    run { |c| c.conn.send(meth, *args) }
  end

  def run
    begin
      @c = pool.checkout
      yield @c
    ensure
      pool.checkin(@c) if @c && @c.owner == Thread.current
    end
  end
end
