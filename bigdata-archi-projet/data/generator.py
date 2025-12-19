import random
from datetime import datetime, timedelta

SCREENS = ["HOME", "SEARCH", "PRODUCT", "CART", "CHECKOUT", "PROFILE"]
EVENTS = ["OPEN", "CLICK", "API_CALL"]
HTTP_CODES = [200, 200, 200, 200, 404, 500]  # + de 200 pour être réaliste

def random_response_time():
    # en secondes (float), avec quelques lenteurs
    base = random.uniform(0.05, 0.45)
    if random.random() < 0.08:  # 8% d’événements lents
        base = random.uniform(0.6, 1.2)
    return round(base, 3)

def main(out_path="data/mobile_events_sample.txt", n=10000):
    start = datetime(2025, 1, 1, 8, 0, 0)
    cur = start

    with open(out_path, "w", encoding="utf-8") as f:
        for i in range(n):
            cur += timedelta(seconds=random.randint(1, 10))
            date_str = cur.strftime("%Y-%m-%d")
            time_str = cur.strftime("%H:%M:%S")
            user = f"user{random.randint(1, 300)}"
            screen = random.choice(SCREENS)
            event = random.choice(EVENTS)
            code = random.choice(HTTP_CODES)
            rt = random_response_time()
            f.write(f"{date_str} {time_str} {user} {screen} {event} {code} {rt}\n")

    print(f"✅ Généré: {out_path} ({n} lignes)")

if __name__ == "__main__":
    main()