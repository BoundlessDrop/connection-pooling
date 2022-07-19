# frozen_string_literal: true

class ConnectionPooling
  class AbstractConnectionAdapter
    attr_accessor :pool
    attr_reader :owner, :lock, :conn
    alias in_use? :owner

    def initialize(spec, conn_klass)
      @conn = conn_klass.new(spec)
      @idle_since = Concurrent.monotonic_time
      @lock = ActiveSupport::Concurrency::LoadInterlockAwareMonitor.new
    end

    def lease
      if in_use?
        msg = +"Cannot lease connection, "
        if @owner == Thread.current
          msg << "it is already leased by the current thread."
        else
          msg << "it is already in use by a different thread: #{@owner}. " \
            "Current thread: #{Thread.current}."
        end
        raise ActiveRecord::ActiveRecordError, msg
      end

      @owner = Thread.current
    end

    def steal! # :nodoc:
      if in_use?
        if @owner != Thread.current
          pool.send :remove_connection_from_thread_cache, self, @owner

          @owner = Thread.current
        end
      else
        raise ActiveRecord::ActiveRecordError, "Cannot steal connection, it is not currently leased."
      end
    end

    def expire
      if in_use?
        if @owner != Thread.current
          raise ActiveRecord::ActiveRecordError, "Cannot expire connection, " \
            "it is owned by a different thread: #{@owner}. " \
            "Current thread: #{Thread.current}."
        end

        @idle_since = Concurrent.monotonic_time
        @owner = nil
      else
        raise ActiveRecord::ActiveRecordError, "Cannot expire connection, it is not currently leased."
      end
    end

    def seconds_idle # :nodoc:
      return 0 if in_use?

      Concurrent.monotonic_time - @idle_since
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
