# kafka cheatsheet

Kafka is a distributed system consisting of servers and clients that communicate via a high-performance TCP network protocol.

## List Topics

```bash
kafka-topics --list --zookeeper zookeeper.kafka.instance:2181
```

## Produce Messages

```bash
echo "hello" | kafka-console-producer --bootstrap-server kafka-ops:9092 --topic system-logs
```

## Consume Messages

Read messages as they arrive:

```bash
kafka-console-consumer --bootstrap-server kafka-ops:9092 --topic system-logs
```

Reading messages from the beginning:

```bash
kafka-console-consumer --bootstrap-server kafka-ops:9092 --topic system-logs --from-beginning
```
