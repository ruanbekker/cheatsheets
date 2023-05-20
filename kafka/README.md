# kafka cheatsheet

Kafka is a distributed system consisting of servers and clients that communicate via a high-performance TCP network protocol.

## List Topics

```bash
kafka-topics --list --bootstrap-server kafka-broker:9092
```

## Create Topic

```bash
kafka-topics --create --topic test-topic --bootstrap-server kafka-broker:9092
```

## Describe Topic

```bash
kafka-topics --describe --topic test-topic --bootstrap-server kafka-broker:9092
```

## Produce Messages

```bash
echo "hello" | kafka-console-producer --bootstrap-server kafka-broker:9092 --topic test-topic
```

## Consume Messages

Read messages as they arrive:

```bash
kafka-console-consumer --bootstrap-server kafka-broker:9092 --topic test-topic
```

Reading messages from the beginning:

```bash
kafka-console-consumer --bootstrap-server kafka-ops:9092 --topic test-topic --from-beginning
```
