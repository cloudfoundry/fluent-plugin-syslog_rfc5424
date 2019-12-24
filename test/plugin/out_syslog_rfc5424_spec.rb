require "test_helper"
require "fluent/plugin/out_syslog_rfc5424"

class SyslogRFC5424Test < Test::Unit::TestCase
  def setup
    Fluent::Test.setup
  end

  def create_driver(conf = CONFIG)
    Fluent::Test::Driver::Output.new(Fluent::Plugin::SyslogRFC5424).configure(conf)
  end

  def test_configure
    output_driver = create_driver %(
      @type syslog_rfc5424
      host example.com
      port 123
    )

    assert_equal "example.com", output_driver.instance.instance_variable_get(:@host)
    assert_equal 123, output_driver.instance.instance_variable_get(:@port)
  end

  def test_sends_a_message
    output_driver = create_driver %(
      @type syslog_rfc5424
      host example.com
      port 123
    )

    socket = Object.new
    mock(socket).puts("1 l")
    mock(socket).close

    n = Fluent::EventTime.now
    mock(RFC5424::Formatter).format(timestamp: n, log: "hi") { "l" }

    any_instance_of(Fluent::Plugin::SyslogRFC5424) do |fluent_plugin|
      mock(fluent_plugin).socket_create(:tls, "example.com", 123).returns(socket)
    end

    output_driver.run do
      output_driver.feed("tag", n , {"log" => "hi"})
    end
  end

  def test_non_tls
    output_driver = create_driver %(
      @type syslog_rfc5424
      host example.com
      port 123
      transport tcp
    )

    socket = Minitest::Mock.new
    mock(socket).puts("1 l")
    mock(socket).close

    n = Fluent::EventTime.now
    mock(RFC5424::Formatter).format(timestamp: n, log: "hi") { "l" }

    any_instance_of(Fluent::Plugin::SyslogRFC5424) do |fluent_plugin|
      mock(fluent_plugin).socket_create(:tcp, "example.com", 123).returns(socket)
    end

    output_driver.run do
      output_driver.feed("tag", n , {"log" => "hi"})
    end
  end

  def test_close
    plugin = Fluent::Plugin::SyslogRFC5424.new
    plugin.configure(Fluent::Config::Element.new("no", "no", {"host" => 'example.com', "port" => 123}, []))

    socket = Minitest::Mock.new
    mock(socket).puts("1 l")
    mock(socket).close

    n = Fluent::EventTime.now
    mock(RFC5424::Formatter).format(timestamp: n, log: nil) { "l" }

    mock(plugin).socket_create(:tls, "example.com", 123).returns(socket)
    plugin.write([[n, {}]])

    plugin.close
  end
end