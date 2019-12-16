require "test_helper"
require "fluent/plugin/syslog_rcf5424"

class SyslogRFC5424Test < Test::Unit::TestCase
  def setup
    Fluent::Test.setup
  end

  def create_driver(conf = CONFIG)
    Fluent::Test::Driver::Output.new(Fluent::Plugin::SyslogRFC5424).configure(conf)
  end

  def create_socket_mock()

  end

  def test_configure
    d = create_driver %[
      @type syslog_rfc5424
      host example.com
      port 123
    ]

    assert_equal "example.com", d.instance.instance_variable_get(:@host)
    assert_equal 123, d.instance.instance_variable_get(:@port)
  end

  def test_sends_a_message
    output_driver = create_driver %[
      @type syslog_rfc5424
      host example.com
      port 123
    ]

    n = Fluent::EventTime.now
    mock(RFC5424::Formatter).format(timestamp: n, log: "hi") { "l" }
    any_instance_of(Fluent::Plugin::SyslogRFC5424) do |fluent_plugin|
      mock(fluent_plugin).socket_create(:tls, "example.com", 123) do
        socket = Object.new
        mock(socket).puts("1 l")
        socket
      end
    end


    output_driver.run do
      output_driver.feed("tag", n , {"log" => "hi"})
    end
  end

  def test_non_tls
      output_driver = create_driver %[
      @type syslog_rfc5424
      host example.com
      port 123
      transport tcp
    ]

      n = Fluent::EventTime.now
      mock(RFC5424::Formatter).format(timestamp: n, log: "hi") { "l" }
      any_instance_of(Fluent::Plugin::SyslogRFC5424) do |fluent_plugin|
        mock(fluent_plugin).socket_create(:tcp, "example.com", 123) do
          socket = Object.new
          mock(socket).puts("1 l")
          socket
        end
      end


      output_driver.run do
        output_driver.feed("tag", n , {"log" => "hi"})
      end
    end

end