require 'fluent/plugin/output'

module Fluent
  module Plugin
    class SyslogRFC5424 < Output

      # Register the name of your plugin (Choose a name which
      # is not used by any other output plugins).
      Fluent::Plugin.register_output('SyslogRFC5424', self)

      helpers :socket

      # Define parameters for your plugin
      config_param :host, :string
      config_param :port, :integer
      config_param :transport, :string, default: "tls"
      # config_param :enterprise_id, :integer

      #### Sync Buffered Output ##############################
      # Implement write() if your plugin uses a normal buffer.
      # Read "Sync Buffered Output" for details.
      ########################################################
      def write(chunk)
        begin
          socket = self.socket_create(@transport.to_sym, @host, @port)
          chunk.each do |time, record|
            # TODO: consider using extract_placeholder for logs
            syslog = RFC5424::Formatter.format(log: record["log"], timestamp: time)
            socket.puts syslog.size.to_s + " " + syslog
          end
        rescue Exception => e
          puts e.message
        end
      end
    end
  end
end