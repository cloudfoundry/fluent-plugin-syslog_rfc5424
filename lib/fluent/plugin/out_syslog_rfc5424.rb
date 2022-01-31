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
      config_param :private_key_path, :string, default: nil
      config_param :private_key_passphrase, :string, default: nil
      config_param :allow_self_signed_cert, :string, default: false
      config_param :fqdn, :string, default: nil
      config_param :version, :string, default: "TLSv1_2"
      config_section :format do
        config_set_default :@type, DEFAULT_FORMATTER
      end

      def configure(config)
        super
        @sockets = {}
        @formatter = formatter_create
      end

      def multi_workers_ready?
        true
      end

      def write(chunk)
        socket = find_or_create_socket(@transport.to_sym, @host, @port)
        tag = chunk.metadata.tag
        chunk.each do |time, record|
          begin
            socket.write_nonblock @formatter.format(tag, time, record)
            IO.select(nil, [socket], nil, 1) || raise(StandardError.new "ReconnectError")
          rescue => e
            @sockets.delete(socket_key(@transport.to_sym, @host, @port))
            socket.close
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
        if @transport == 'udp'
          { connect: true }
        elsif @transport == 'tls'
          # TODO: make timeouts configurable
          {
            insecure: @insecure,
            verify_fqdn: !@insecure,
            cert_paths: @trusted_ca_path,
            private_key_path: @private_key_path,
            private_key_passphrase: @private_key_passphrase,
            allow_self_signed_cert: @allow_self_signed_cert,
            fqdn: @fqdn,
            version: @version,
          } #, connect_timeout: 1, send_timeout: 1, recv_timeout: 1, linger_timeout: 1 }
        else
          {}
        end
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
