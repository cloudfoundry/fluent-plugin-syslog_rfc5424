require 'fluent/plugin/output'

module Fluent
  module Plugin
    class OutSyslogRFC5424 < Output
      Fluent::Plugin.register_output('syslog_rfc5424', self)

      helpers :socket, :formatter
      DEFAULT_FORMATTER = "syslog_rfc5424"

      config_param :host, :string
      config_param :port, :integer
      config_param :transport, :string, default: "tls"
      config_param :insecure, :bool, default: false
      config_param :trusted_ca_path, :string, default: nil
      config_section :format do
        config_set_default :@type, DEFAULT_FORMATTER
      end

      def configure(config)
        super
        @sockets = {}
        @formatter = formatter_create
      end

      def write(chunk)
        socket = find_or_create_socket(@transport.to_sym, @host, @port)
        tag = chunk.metadata.tag
        chunk.each do |time, record|
          begin
            socket.puts @formatter.format(tag, time, record)
          rescue
            @sockets[socket_key(@transport.to_sym, @host, @port)] = nil
            raise
          end
        end
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

        @sockets[socket_key(transport, host, port)] = socket_create(transport.to_sym, host, port, socket_options)
      end

      def socket_options
        return {} unless @transport == 'tls'

        { insecure: @insecure, verify_fqdn: !@insecure, cert_paths: @trusted_ca_path }
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