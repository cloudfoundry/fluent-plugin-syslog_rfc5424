require "fluentd_cf_syslog/version"

module FluentdCfSyslog
  class Error < StandardError; end
  # Your code goes here...
end



require 'fluent/plugin/output'

module Fluent::Plugin
  class BestLoggin < Output

    # Register the name of your plugin (Choose a name which
    # is not used by any other output plugins).
    Fluent::Plugin.register_output('some', self)

    # Enable threads if you are writing an async buffered plugin
    helpers :thread

    # Define parameters for your plugin
    config_param :path, :string


    #### Sync Buffered Output ##############################
    # Implement write() if your plugin uses a normal buffer.
    # Read "Sync Buffered Output" for details.
    ########################################################
    def write(chunk)
      real_path = extract_placeholders(@path, chunk)

      log.debug "writing data to file", chunk

      # For standard chunk format (without #format() method)
      chunk.each do |time, record|
        log.debug time, record
      end
    end
  end
end