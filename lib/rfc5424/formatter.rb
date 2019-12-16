require 'date'

module RFC5424
  class Formatter
    Format = "<%d>1 %s %s %s %s %s %s %s"

    class << self
      def format(
        priority: 14,
        timestamp: nil,
        log: "",
        hostname: "-",
        app_name: "-",
        proc_id: "-",
        msg_id: "-",
        sd: "-"
      )
        if timestamp.nil?
          timestamp = "-"
        else
          timestamp = DateTime.strptime(timestamp.to_s,'%s').rfc3339(6)
        end

        Format % [priority, timestamp, hostname[0..254], app_name[0..47], proc_id[0..127], msg_id[0..31], sd, log]
      end
    end
  end

  class StructuredData
    attr_reader :sd_id, :sd_elements
    def initialize(sd_id:, sd_elements: {})
      @sd_id = sd_id
      @sd_elements = sd_elements
    end

    def to_s
      el = @sd_elements.inject("") do |elements, tuple|
        elements + %{ #{tuple.first}="#{tuple.last}"}
      end
      %{[#{sd_id}#{el}]}
    end
  end
end