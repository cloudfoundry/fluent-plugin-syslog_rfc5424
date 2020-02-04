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

    socket = Object.new
    mock(socket).write_nonblock(@formatted_log)
    stub(socket).close

    stub(IO).select(nil, [socket], nil, 1) { ["not an error"] }
    
    any_instance_of(Fluent::Plugin::OutSyslogRFC5424) do |fluent_plugin|
      mock(fluent_plugin).socket_create(:tls, "example.com", 123, {:insecure=>false, :verify_fqdn=>true, :cert_paths=>nil}).returns(socket)
    end

    output_driver.run do
      output_driver.feed("tag", @time, {"log" => "hi"})
    end
  end

  def test_reconnects
    puts "test reconnects"
    output_driver = create_driver %(
      @type syslog_rfc5424
      host example.com
      port 123
    )

    bad_socket = Object.new
    mock(bad_socket).write_nonblock(@formatted_log)
    stub(bad_socket).close
    
    good_socket = Object.new
    mock(good_socket).write_nonblock(@formatted_log)
    stub(good_socket).close

    mock(IO).select(nil, [bad_socket], nil, 1)
    mock(IO).select(nil, [good_socket], nil, 1) { ["not an error"] }

    any_instance_of(Fluent::Plugin::OutSyslogRFC5424) do |fluent_plugin|
      mock(fluent_plugin).socket_create(:tls, "example.com", 123, {:insecure=>false, :verify_fqdn=>true, :cert_paths=>nil}).returns(bad_socket)
      mock(fluent_plugin).socket_create(:tls, "example.com", 123, {:insecure=>false, :verify_fqdn=>true, :cert_paths=>nil}).returns(good_socket)
    end

    output_driver.run(shutdown: false, force_flush_retry: true) do
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

    socket = Object.new
    mock(socket).write_nonblock(@formatted_log)
    stub(socket).close

    stub(IO).select(nil, [socket], nil, 1) { ["not an error"] }

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

    socket = Object.new
    mock(socket).write_nonblock(@formatted_log)
    stub(socket).close

    stub(IO).select(nil, [socket], nil, 1) { ["not an error"] }

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

    socket = Object.new
    mock(socket).write_nonblock(@formatted_log)
    stub(socket).close

    stub(IO).select(nil, [socket], nil, 1) { ["not an error"] }

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

    socket = Object.new
    stub(socket).write_nonblock(@formatted_log)
    mock(socket).close

    stub(IO).select(nil, [socket], nil, 1) { ["not an error"] }

    any_instance_of(Fluent::Plugin::OutSyslogRFC5424) do |fluent_plugin|
      mock(fluent_plugin).socket_create(:tls, "example.com", 123, {:insecure=>false, :verify_fqdn=>true, :cert_paths=>nil}).returns(socket)
    end

    output_driver.run do
      output_driver.feed("tag", @time , {"log" => "hi"})
    end
  end
end