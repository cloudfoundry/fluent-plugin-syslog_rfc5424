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
      rfc6587_message_size false
    )
    tag = "test-formatter"
    time = Fluent::EventTime.new(0, 123456000)
    record = {"log" => "test-log"}
    assert_equal "<14>1 1970-01-01T00:00:00.123456+00:00 - - - - [] test-log\n",
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
    assert_equal "<14>1 1970-01-01T00:00:00.123456+00:00 - - - - [] test-log\n",
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

    formatted_message = "<14>1 1970-01-01T00:00:00.123456+00:00 - - - - [] test-log"
    message_size = formatted_message.length
    assert_equal "#{message_size} #{formatted_message}",
                 formatter_driver.instance.format(tag, time, record)
  end

  def test_format_with_app_name
    formatter_driver = create_driver %(
      @type syslog_rfc5424
      app_name_field example.custom_field
      rfc6587_message_size false
    )
    tag = "test-formatter"
    time = Fluent::EventTime.new(0, 123456000)
    record = {"log" => "test-log", "example" => {"custom_field" => "custom-value"}}

    formatted_message = "<14>1 1970-01-01T00:00:00.123456+00:00 - custom-value - - [] test-log\n"
    message_size = formatted_message.length
    assert_equal "#{formatted_message}",
                 formatter_driver.instance.format(tag, time, record)
  end

  def test_format_with_log_field
    formatter_driver = create_driver %(
      @type syslog_rfc5424
      rfc6587_message_size false
      log_field example.custom_field
    )
    tag = "test-formatter"
    time = Fluent::EventTime.new(0, 123456000)
    record = {"log" => "test-log", "example" => {"custom_field" => "custom-value"}}

    formatted_message = "<14>1 1970-01-01T00:00:00.123456+00:00 - - - - [] custom-value\n"
    message_size = formatted_message.length
    assert_equal "#{formatted_message}",
                 formatter_driver.instance.format(tag, time, record)
  end

  def test_format_with_structured_data
    formatter_driver = create_driver %(
      @type syslog_rfc5424
      rfc6587_message_size false
      structured_data_field example.custom_field
    )
    tag = "test-formatter"
    time = Fluent::EventTime.new(0, 123456000)
    record = {"log" => "test-log", "example" => {"custom_field" => "custom-value"}}

    formatted_message = "<14>1 1970-01-01T00:00:00.123456+00:00 - - - - [custom-value] test-log\n"
    message_size = formatted_message.length
    assert_equal "#{formatted_message}",
                 formatter_driver.instance.format(tag, time, record)
  end

  def test_format_with_hostname
    formatter_driver = create_driver %(
      @type syslog_rfc5424
      rfc6587_message_size false
      hostname_field example.custom_field
    )
    tag = "test-formatter"
    time = Fluent::EventTime.new(0, 123456000)
    record = {"log" => "test-log", "example" => {"custom_field" => "custom-value"}}

    formatted_message = "<14>1 1970-01-01T00:00:00.123456+00:00 custom-value - - - [] test-log\n"
    message_size = formatted_message.length
    assert_equal "#{formatted_message}",
                 formatter_driver.instance.format(tag, time, record)
  end

  def test_format_with_proc_id
    formatter_driver = create_driver %(
      @type syslog_rfc5424
      proc_id_field example.custom_field
      rfc6587_message_size false
    )
    tag = "test-formatter"
    time = Fluent::EventTime.new(0, 123456000)
    record = {"log" => "test-log", "example" => {"custom_field" => "custom-value"}}

    formatted_message = "<14>1 1970-01-01T00:00:00.123456+00:00 - - custom-value - [] test-log\n"
    message_size = formatted_message.length
    assert_equal "#{formatted_message}",
                 formatter_driver.instance.format(tag, time, record)
  end

  def test_format_with_message_id
    formatter_driver = create_driver %(
      @type syslog_rfc5424
      rfc6587_message_size false
      message_id_field example.custom_field
    )
    tag = "test-formatter"
    time = Fluent::EventTime.new(0, 123456000)
    record = {"log" => "test-log", "example" => {"custom_field" => "custom-value"}}

    formatted_message = "<14>1 1970-01-01T00:00:00.123456+00:00 - - - custom-value [] test-log\n"
    message_size = formatted_message.length
    assert_equal "#{formatted_message}",
                 formatter_driver.instance.format(tag, time, record)
  end

end
