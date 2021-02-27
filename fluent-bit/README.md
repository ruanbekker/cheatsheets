# Fluent Bit

## Resources

- [Official Docker Image](https://hub.docker.com/r/fluent/fluent-bit/)
- [Docker Metadata in Docker Logs using Fluent Bit](https://github.com/fluent/fluent-bit/issues/1499)
- [Command line examples for fluent-bit and stdout/es](https://github.com/fluent/fluent-bit/issues/185#issuecomment-279114301)
- [Fluent Bit Guide by coralogix.com](https://coralogix.com/log-analytics-blog/fluent-bit-guide/)


## Basic Example

Run fluent-bit:

```
$ docker run -p 127.0.0.1:24224:24224 fluent/fluent-bit:1.5 /fluent-bit/bin/fluent-bit -i forward -o stdout -p format=json_lines -f 1
```

Run a container and specify the log driver:

```
$ docker run --log-driver=fluentd -t ubuntu echo "Testing a log message"
Testing a log message
```

Stdout from fluent-bit:

```
{
  "date":1601638488,
  "container_id":"45eccdf719dc28629bded52c8b409d0b10d0efb6d4b72452fc369a256e31be97",
  "container_name":"/epic_tharp",
  "source":"stdout",
  "log":"Testing a log message\r"
}
```
