CREATE TABLE IF NOT EXISTS kpi_events_by_screen (
  screen TEXT PRIMARY KEY,
  event_count BIGINT NOT NULL,
  updated_at TIMESTAMP DEFAULT NOW()
);
