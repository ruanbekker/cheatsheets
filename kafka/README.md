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

Produce JSON Messages:

```
cat > file.json << EOF
{ "id": 1, "first_name": "John"}
{ "id": 2, "first_name": "Peter"}
{ "id": 3, "first_name": "Nate"}
{ "id": 4, "first_name": "Frank"}
EOF

kafka-console-producer --bootstrap-server kafka-broker:9092 --topic test-topic < file.json
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

## Count Messages in Topic

```bash
kafka-run-class kafka.tools.GetOffsetShell --bootstrap-server kafka-broker:9092 --topic test-topic | awk -F  ":" '{sum += $3} END {print "Result: "sum}'
```
