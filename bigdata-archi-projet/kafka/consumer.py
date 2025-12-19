from kafka import KafkaConsumer

TOPIC = "mobile-events"
BOOTSTRAP_SERVERS = "localhost:9092"

def main():
    consumer = KafkaConsumer(
        TOPIC,
        bootstrap_servers=BOOTSTRAP_SERVERS,
        auto_offset_reset="earliest",   # relit depuis le début si nouveau group
        enable_auto_commit=True,
        group_id="demo-consumer-group",
        value_deserializer=lambda v: v.decode("utf-8"),
    )

    print("✅ Consumer démarré. En attente d'événements...\n")

    for msg in consumer:
        print(f"📩 {msg.value}")

if __name__ == "__main__":
    main()
