import time
from kafka import KafkaProducer

TOPIC = "mobile-events"
BOOTSTRAP_SERVERS = "localhost:9092"
FILE_PATH = "data/mobile_events_sample.txt"

def main():
    producer = KafkaProducer(
        bootstrap_servers=BOOTSTRAP_SERVERS,
        value_serializer=lambda v: v.encode("utf-8"),
        linger_ms=10,
    )

    sent = 0
    with open(FILE_PATH, "r", encoding="utf-8") as f:
        for line in f:
            line = line.strip()
            if not line:
                continue

            producer.send(TOPIC, value=line)
            sent += 1

            # 👇 simulation "temps réel"
            time.sleep(0.2)

            if sent % 500 == 0:
                producer.flush()
                print(f"📤 Envoyés: {sent} événements")

    producer.flush()
    producer.close()
    print(f"✅ Terminé. Total envoyés: {sent}")

if __name__ == "__main__":
    main()
