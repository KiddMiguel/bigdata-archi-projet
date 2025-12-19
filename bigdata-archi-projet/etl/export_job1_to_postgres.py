import subprocess
import psycopg2

HDFS_PATH = "/output/job1_events_by_screen/part-00000"

DB_HOST = "localhost"
DB_PORT = 5432
DB_NAME = "analytics"
DB_USER = "bigdata"
DB_PASS = "bigdata"

def hdfs_cat(path: str) -> str:
    # Lit le fichier HDFS via docker exec namenode
    cmd = ["docker", "exec", "namenode", "hdfs", "dfs", "-cat", path]
    return subprocess.check_output(cmd, text=True)

def main():
    data = hdfs_cat(HDFS_PATH).strip().splitlines()
    rows = []
    for line in data:
        # format: SCREEN\tCOUNT
        parts = line.split("\t")
        if len(parts) != 2:
            continue
        screen, count = parts[0].strip(), int(parts[1].strip())
        rows.append((screen, count))

    conn = psycopg2.connect(
        host=DB_HOST, port=DB_PORT, dbname=DB_NAME, user=DB_USER, password=DB_PASS
    )
    cur = conn.cursor()

    cur.execute("TRUNCATE TABLE kpi_events_by_screen;")
    cur.executemany(
        "INSERT INTO kpi_events_by_screen(screen, event_count) VALUES (%s, %s);",
        rows
    )

    conn.commit()
    cur.close()
    conn.close()

    print(f"✅ Export terminé : {len(rows)} lignes insérées dans kpi_events_by_screen")

if __name__ == "__main__":
    main()