require "test_helper"
require "rfc5424/formatter"

class RFC5424::FormatterTest < Test::Unit::TestCase
  def test_only_log
    log = RFC5424::Formatter.format( log: "test-log")
    assert_equal log, "<14>1 - - - - - - test-log"
  end

  # RFC 3339
  # Adding fractional seconds: https://github.com/fluent/fluentd/issues/1862
  def test_with_timestamp
    log = RFC5424::Formatter.format(timestamp: 0, log: "test-log")
    assert_equal log, "<14>1 1970-01-01T00:00:00.000000+00:00 - - - - - test-log"
  end

  def test_with_timestamp_nano
    log = RFC5424::Formatter.format(timestamp: Fluent::EventTime.new(0, 123456000), log: "test-log")

    assert_equal log, "<14>1 1970-01-01T00:00:00.123456+00:00 - - - - - test-log"
  end

  def test_with_priority
    log = RFC5424::Formatter.format( priority: 1, log: "test-log")
    assert_equal log, "<1>1 - - - - - - test-log"
  end

  def test_with_hostname
    log = RFC5424::Formatter.format( hostname: "host", log: "test-log")
    assert_equal log, "<14>1 - host - - - - test-log"
  end

  def test_with_overly_long_hostname
    log = RFC5424::Formatter.format( hostname: "a"*300, log: "test-log")
    assert_equal log, "<14>1 - #{"a"*255} - - - - test-log"
  end

  def test_with_app_name
    log = RFC5424::Formatter.format( app_name: "app-name", log: "test-log")
    assert_equal log, "<14>1 - - app-name - - - test-log"
  end

  def test_with_overly_long_app_name
    log = RFC5424::Formatter.format( app_name: "a"*300, log: "test-log")
    assert_equal log, "<14>1 - - #{"a"*48} - - - test-log"
  end

  def test_with_proc_id
    log = RFC5424::Formatter.format( proc_id: "proc-id", log: "test-log")
    assert_equal log, "<14>1 - - - proc-id - - test-log"
  end

  def test_with_overly_long_proc_id
    log = RFC5424::Formatter.format( proc_id: "a"*300, log: "test-log")
    assert_equal log, "<14>1 - - - #{"a"*128} - - test-log"
  end

  def test_with_msg_id
    log = RFC5424::Formatter.format( msg_id: "msg-id", log: "test-log")
    assert_equal log, "<14>1 - - - - msg-id - test-log"
  end

  def test_with_overly_long_msg_id
    log = RFC5424::Formatter.format( msg_id: "a"*300, log: "test-log")
    assert_equal log, "<14>1 - - - - #{"a"*32} - test-log"
  end

  def test_structured_data
    structured_data = RFC5424::StructuredData.new(sd_id: "test@123", sd_elements: {"a" => "a-value", "b" => "b-value"})
    assert_equal structured_data.to_s, '[test@123 a="a-value" b="b-value"]'
  end

  def test_with_structured_data
    structured_data_1 = RFC5424::StructuredData.new(sd_id: "test@123", sd_elements: {"a" => "a-value"})
    structured_data_2 = RFC5424::StructuredData.new(sd_id: "test2@123", sd_elements: {"b" => "b-value"})
    log = RFC5424::Formatter.format( sd: structured_data_1.to_s + structured_data_2.to_s, log: "test-log")
    assert_equal log, '<14>1 - - - - - [test@123 a="a-value"][test2@123 b="b-value"] test-log'
  end
end