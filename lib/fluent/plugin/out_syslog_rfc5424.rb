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

      def write(chunk)
          self.socket_create(@transport.to_sym, @host, @port) do | socket |
            chunk.each do |time, record|
              syslog = RFC5424::Formatter.format(log: record["log"], timestamp: time)
              socket.puts syslog.size.to_s + " " + syslog
            end
          end
      end
    end
  end
end