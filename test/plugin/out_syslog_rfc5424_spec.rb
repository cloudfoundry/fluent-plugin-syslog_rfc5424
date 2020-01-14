require "test_helper"
require "fluent/plugin/out_syslog_rfc5424"

class OutSyslogRFC5424Test < Test::Unit::TestCase
  def setup
    Fluent::Test.setup
    @time = Fluent::EventTime.new(0, 123456)
    @formatted_log = "51 <14>1 1970-01-01T00:00:00.000123+00:00 - - - - - hi"
  end

  def create_driver(conf = CONFIG)
    Fluent::Test::Driver::Output.new(Fluent::Plugin::OutSyslogRFC5424).configure(conf)
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

    socket = Minitest::Mock.new
    mock(socket).puts(@formatted_log)
    stub(socket).close

    any_instance_of(Fluent::Plugin::OutSyslogRFC5424) do |fluent_plugin|
      mock(fluent_plugin).socket_create(:tls, "example.com", 123, {:insecure=>false, :verify_fqdn=>true, :cert_paths=>nil}).returns(socket)
    end

    output_driver.run do
      output_driver.feed("tag", @time, {"log" => "hi"})
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
    mock(socket).puts(@formatted_log)
    stub(socket).close

    any_instance_of(Fluent::Plugin::OutSyslogRFC5424) do |fluent_plugin|
      mock(fluent_plugin).socket_create(:tcp, "example.com", 123, {}).returns(socket)
    end

    output_driver.run do
      output_driver.feed("tag", @time, {"log" => "hi"})
    end
  end

  def test_insecure_tls
    output_driver = create_driver %(
      @type syslog_rfc5424
      host example.com
      port 123
      transport tls
      insecure true
    )

    socket = Minitest::Mock.new
    mock(socket).puts(@formatted_log)
    stub(socket).close

    any_instance_of(Fluent::Plugin::OutSyslogRFC5424) do |fluent_plugin|
      mock(fluent_plugin).socket_create(:tls, "example.com", 123, {:insecure=>true, :verify_fqdn=>false, :cert_paths=>nil}).returns(socket)
    end

    output_driver.run do
      output_driver.feed("tag", @time, {"log" => "hi"})
    end
  end

  def test_secure_tls
    output_driver = create_driver %(
      @type syslog_rfc5424
      host example.com
      port 123
      transport tls
      trusted_ca_path supertrustworthy
    )

    socket = Minitest::Mock.new
    mock(socket).puts(@formatted_log)
    stub(socket).close

    any_instance_of(Fluent::Plugin::OutSyslogRFC5424) do |fluent_plugin|
      mock(fluent_plugin).socket_create(:tls, "example.com", 123, {:insecure=>false, :verify_fqdn=>true, :cert_paths=>"supertrustworthy"}).returns(socket)
    end

    output_driver.run do
      output_driver.feed("tag", @time, {"log" => "hi"})
    end
  end

  def test_close_is_called_on_sockets
    output_driver = create_driver %(
      @type syslog_rfc5424
      host example.com
      port 123
    )

    socket = Minitest::Mock.new
    stub(socket).puts(@formatted_log)

    any_instance_of(Fluent::Plugin::OutSyslogRFC5424) do |fluent_plugin|
      mock(fluent_plugin).socket_create(:tls, "example.com", 123, {:insecure=>false, :verify_fqdn=>true, :cert_paths=>nil}).returns(socket)
    end

    mock(socket).close
    output_driver.run do
      output_driver.feed("tag", @time , {"log" => "hi"})
    end
  end
end