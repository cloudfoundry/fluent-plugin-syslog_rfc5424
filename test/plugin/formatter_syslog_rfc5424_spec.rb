require "test_helper"
require "fluent/plugin/formatter_syslog_rfc5424"

class FormatterSyslogRFC5424Test < Test::Unit::TestCase
  def setup
    Fluent::Test.setup
  end

  def create_driver(conf = CONFIG)
    Fluent::Test::Driver::Formatter.new(Fluent::Plugin::FormatterSyslogRFC5424).configure(conf)
  end

  def test_format_default
    formatter_driver = create_driver %(
      @type syslog_rfc5424
    )
    tag = "test-formatter"
    time = Fluent::EventTime.new(0, 123456000)
    record = {"log" => "test-log"}
    assert_equal "<14>1 1970-01-01T00:00:00.123456+00:00 - app-name instance-id - - test-log",
                 formatter_driver.instance.format(tag, time, record)
  end

  def test_format_without_message_size
    formatter_driver = create_driver %(
      @type syslog_rfc5424
      rfc6587_message_size false
    )
    tag = "test-formatter"
    time = Fluent::EventTime.new(0, 123456000)
    record = {"log" => "test-log"}
    assert_equal "<14>1 1970-01-01T00:00:00.123456+00:00 - app-name instance-id - - test-log",
                 formatter_driver.instance.format(tag, time, record)
  end

  def test_format_with_message_size
    formatter_driver = create_driver %(
      @type syslog_rfc5424
      rfc6587_message_size true
    )
    tag = "test-formatter"
    time = Fluent::EventTime.new(0, 123456000)
    record = {"log" => "test-log"}

    formatted_message = "<14>1 1970-01-01T00:00:00.123456+00:00 - app-name instance-id - - test-log"
    message_size = formatted_message.length
    assert_equal "#{message_size} #{formatted_message}",
                 formatter_driver.instance.format(tag, time, record)
  end
end