require 'fluent/plugin/output'
require 'rfc5424/formatter'

module Fluent
  module Plugin
    class SyslogRFC5424 < Output
      Fluent::Plugin.register_output('syslog_rfc5424', self)

      helpers :socket

      config_param :host, :string
      config_param :port, :integer
      config_param :transport, :string, default: "tls"

      def configure(config)
        super
        @sockets = {}
      end

      def write(chunk)
        socket = find_or_create_socket(@transport.to_sym, @host, @port)
        chunk.each do |time, record|
          syslog = RFC5424::Formatter.format(log: record["log"], timestamp: time)
          socket.puts syslog.size.to_s + " " + syslog
        end
        # close socket
        # retry socket
        # backoff behavior?
      end

      def close
        super
        @sockets.each_value { |s| s.close }
        @sockets = {}
      end

      private

      def find_or_create_socket(transport, host, port)
        socket = find_socket(transport, host, port)
        return socket if socket

        @sockets[socket_key(transport, host, port)] = self.socket_create(transport.to_sym, host, port)
      end

      def socket_key(transport, host, port)
        "#{host}:#{port}:#{transport}"
      end

      def find_socket(transport, host, port)
        @sockets[socket_key(transport, host, port)]
      end
    end
  end
end