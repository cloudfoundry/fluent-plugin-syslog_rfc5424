require 'rfc5424/formatter'

module Fluent
  module Plugin
    class FormatterSyslogRFC5424 < Formatter
      Fluent::Plugin.register_formatter('syslog_rfc5424', self)

      config_param :rfc6587_message_size, :bool, default: false

      def format(tag, time, record)
        log.debug("Tag")
        log.debug(tag.to_s)

        log.debug("Record")
        log.debug(record.map { |k, v| "#{k}=#{v}" }.join('&'))

        msg = RFC5424::Formatter.format(
          log: record['log'],
          timestamp: time,
          app_name: record.dig("kubernetes", "labels", "cloudfoundry.org/app_guid") || "-",
          proc_id: record.dig("kubernetes", "pod_id") || "-"
        )

        log.debug("RFC 5424 Message")
        log.debug(msg)

        return msg unless @rfc6587_message_size

        msg.length.to_s + ' ' + msg
      end
    end
  end
end