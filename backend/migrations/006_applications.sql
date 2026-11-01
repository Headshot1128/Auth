CREATE TABLE IF NOT EXISTS applications (
  id TEXT PRIMARY KEY NOT NULL,
  name TEXT NOT NULL,
  status TEXT DEFAULT 'active' NOT NULL,
  created_at INTEGER NOT NULL
);

INSERT OR IGNORE INTO applications(id, name, status, created_at)
VALUES('00000000-0000-4000-8000-000000000001', 'Default application', 'active', 1700000000);

CREATE TABLE IF NOT EXISTS reseller_profiles (
  user_id TEXT PRIMARY KEY NOT NULL REFERENCES users(id),
  max_days INTEGER NOT NULL DEFAULT 30
);

INSERT INTO schema_migrations(version) VALUES(6);
