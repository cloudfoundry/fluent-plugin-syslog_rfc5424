require 'rfc5424/formatter'

module Fluent
  module Plugin
    class FormatterSyslogRFC5424 < Formatter
      Fluent::Plugin.register_formatter('syslog_rfc5424', self)

      config_param :rfc6587_message_size, :bool, default: true
      config_param :app_name_field, :string, default: "app_name"
      config_param :proc_id_field, :string, default: "proc_id"

      def configure(conf)
        super
        @app_name_field_array = @app_name_field.split(".")
        @proc_id_field_array = @proc_id_field.split(".")
      end

      def format(tag, time, record)
        log.debug("Record")
        log.debug(record.map { |k, v| "#{k}=#{v}" }.join('&'))

        msg = RFC5424::Formatter.format(
          log: record['log'],
          timestamp: time,
          app_name: record.dig(*@app_name_field_array) || "-",
          proc_id: record.dig(*@proc_id_field_array) || "-"
        )

        log.debug("RFC 5424 Message")
        log.debug(msg)

        return msg + "\n" unless @rfc6587_message_size

        msg.length.to_s + ' ' + msg
      end
    end
  end
end