# FluentD Output & Formatter Plugins: Syslog RFC5424

[![Build Status](https://travis-ci.org/cloudfoundry/fluent-plugin-syslog_rfc5424.svg?branch=master)](https://travis-ci.org/cloudfoundry/fluent-plugin-syslog_rfc5424)


Formatter plugin adheres to [RFC5424](https://tools.ietf.org/html/rfc5424). 

Output plugin adheres to [RFC6587](https://tools.ietf.org/html/rfc6587) and [RFC5424](https://tools.ietf.org/html/rfc5424).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'fluentd_syslog_rfc5424'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install fluentd_syslog_rfc5424

## Output Usage

```
<match **>
  @type syslog_rfc5424
  host SYSLOG-HOST
  port SYSLOG-PORT
  <buffer>
    @type memory
    flush_interval 10s
  </buffer>
</match>
```

### Configuration

| name              | type       | description                               |
| --------------    | -------    | ---------------------------------         |
| host              | string     | syslog target host                        |
| port              | integer    | syslog target port                        |
| transport         | string     | transport protocol (tls [default], udp, or tcp) |
| insecure          | boolean    | skip ssl validation |
| trusted_ca_path   | string     | file path to ca to trust |

#### Format Section

Defaults to `syslog_rfc5424`

| name                      |type     | description |
| --------------            | ------- | -------     |
| rfc6587_message_size      | boolean | prepends message length for syslog transmission (true by default)  |
| hostname_field            | string  | sets host name in syslog from field in fluentd, delimited by '.' (default hostname) |
| app_name_field            | string  | sets app name in syslog from field in fluentd, delimited by '.' (default app_name) |
| proc_id_field             | string  | sets proc id in syslog from field in fluentd, delimited by '.' (default proc_id) |
| message_id_field          | string  | sets msg id in syslog from field in fluentd, delimited by '.' (default message_id) |
| structured_data_field     | string  | sets structured data in syslog from field in fluentd, delimited by '.' (default structured_data) |
| log_field                 | string  | sets log in syslog from field in fluentd, delimited by '.' (default log) |


## Formatter Usage

```
<match **>
  @type syslog_rfc5424
  <format>
    @type syslog_rfc5424
    app_name_field example.custom_field_1
    proc_id_field example.custom_field_2
  </format>
</match>
```


## Development

After checking out the repo, run `bundle install` to install dependencies. Then, run `bundle exec rake` to run the tests. You can also run `bundle console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `fluentd_syslog_rfc5424.gemspec`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/cloudfoundry/fluentd_syslog_rfc5424.

## Publishing

1. Run tests `bundle exec rake`
1. Push changes
1. Create & push git tag with version
1. Change version in `.gemspec`
1. Build gem `gem build fluent-plugin-syslog_rfc5424`
1. Push `.gem` file to rubygems
