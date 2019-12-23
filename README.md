# SyslogRFC5424


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'fluentd_syslog_rfc5424'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install fluentd_syslog_rfc5424

## Usage

```
<match **>
  @type syslog_rfc5424
  host SYSLOG-HOST
  port SYSLOG-PORT
  # transport tls, udp, tcp (defaults to tls)
  <buffer>
    @type memory
    flush_interval 10s
  </buffer>
</match>
```

## Configuration

| name              | type       | placeholder support | description                               |
| --------------    | -------    | -----------         | ---------------------------------         |
| host              | string     |                     | syslog target host                        |
| port              | integer    |                     | syslog target port                        |
| transport         | string     |                     | transport protocol (tls, udp, or tcp)     |

### Common Configuration

#### Buffer Section

| name                        |
| --------------              |
| flush_mode                  |
| flush_interval              |
| flush_thread_interval       |
| flush_thread_burst_interval |

## Development

After checking out the repo, run `bundle install` to install dependencies. Then, run `bundle exec rake` to run the tests. You can also run `bundle console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `fluentd_syslog_rfc5424.gemspec`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/cloudfoundry/fluentd_syslog_rfc5424.
