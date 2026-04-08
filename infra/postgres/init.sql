CREATE TABLE IF NOT EXISTS users (
    id          SERIAL PRIMARY KEY,
    name        VARCHAR(255) NOT NULL,
    email       VARCHAR(255) UNIQUE NOT NULL,
    created_at  TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at  TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS items (
    id          SERIAL PRIMARY KEY,
    title       VARCHAR(255) NOT NULL,
    description TEXT,
    user_id     INTEGER REFERENCES users(id) ON DELETE SET NULL,
    created_at  TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at  TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS events (
    id          SERIAL PRIMARY KEY,
    service     VARCHAR(64) NOT NULL,
    event_type  VARCHAR(64) NOT NULL,
    payload     JSONB,
    created_at  TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_items_user_id    ON items(user_id);
CREATE INDEX IF NOT EXISTS idx_events_service   ON events(service);
CREATE INDEX IF NOT EXISTS idx_events_type      ON events(event_type);
CREATE INDEX IF NOT EXISTS idx_events_created   ON events(created_at DESC);

INSERT INTO users (name, email) VALUES
    ('Alice',     'alice@example.com'),
    ('Bob',       'bob@example.com'),
    ('Hirotoshi', 'hirotoshi@example.com')
ON CONFLICT (email) DO NOTHING;

INSERT INTO items (title, description, user_id) VALUES
    ('Actix Demo',    'Created by Rust Actix-web service',    1),
    ('FastAPI Demo',  'Created by Python FastAPI service',    2),
    ('Laravel Demo',  'Created by PHP Laravel service',       3),
    ('ASP.NET Demo',  'Created by C# ASP.NET Core service',   1),
    ('Drogon Demo',   'Created by C++ Drogon service',        2)
ON CONFLICT DO NOTHING;
