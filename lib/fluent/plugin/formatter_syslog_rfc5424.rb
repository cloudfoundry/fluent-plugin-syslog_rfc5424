require 'rfc5424/formatter'

module Fluent
  module Plugin
    class FormatterSyslogRFC5424 < Formatter
      Fluent::Plugin.register_formatter("syslog_rfc5424", self)

      config_param :rfc6587_message_size, :bool, default: false

      def format(tag, time, record)
        msg = RFC5424::Formatter.format(log: record["log"], timestamp: time)
        return msg unless @rfc6587_message_size

        msg.length.to_s + " " + msg
      end
    end
  end
end