-- SkyLink core schema, v0.1
-- Postgres 15+. Indicative, not migration-ready: review types and constraints
-- against the ORM before generating migrations.

CREATE TYPE tier            AS ENUM ('free', 'garage', 'industry');
CREATE TYPE difficulty      AS ENUM ('green', 'yellow', 'orange', 'red');
CREATE TYPE dtc_severity    AS ENUM ('safe', 'soon', 'limited', 'stop');
CREATE TYPE diagram_source  AS ENUM ('library', 'generic', 'web', 'ai_generated');
CREATE TYPE data_state      AS ENUM ('live', 'manual', 'stale', 'demo');

-- ── Accounts ────────────────────────────────────────────────────────────────

CREATE TABLE users (
  id            uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  email         citext UNIQUE NOT NULL,
  auth_provider text NOT NULL,
  display_name  text,
  timezone      text NOT NULL DEFAULT 'UTC',
  created_at    timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE subscriptions (
  user_id      uuid PRIMARY KEY REFERENCES users(id) ON DELETE CASCADE,
  tier         tier NOT NULL DEFAULT 'free',
  status       text NOT NULL,
  period_end   timestamptz,
  store_txn_id text,
  updated_at   timestamptz NOT NULL DEFAULT now()
);

-- Server-side source of truth for the AI search meter. The client never decides.
CREATE TABLE usage_meter (
  user_id          uuid REFERENCES users(id) ON DELETE CASCADE,
  period_start     date NOT NULL,
  ai_searches_used int  NOT NULL DEFAULT 0,
  resets_at        timestamptz,
  PRIMARY KEY (user_id, period_start)
);

-- ── Garage ──────────────────────────────────────────────────────────────────

CREATE TABLE vehicles (
  id         uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id    uuid NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  vin        text,
  year       int  NOT NULL,
  make       text NOT NULL,
  model      text NOT NULL,
  engine     text,
  mileage    int,
  nickname   text,
  created_at timestamptz NOT NULL DEFAULT now()
);
CREATE INDEX ON vehicles (user_id);

CREATE TABLE service_records (
  id           uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  vehicle_id   uuid NOT NULL REFERENCES vehicles(id) ON DELETE CASCADE,
  job_slug     text,
  performed_at date NOT NULL,
  mileage      int,
  cost_cents   int,
  notes        text
);
CREATE INDEX ON service_records (vehicle_id, performed_at DESC);

-- ── Content ─────────────────────────────────────────────────────────────────

CREATE TABLE categories (
  id         uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  parent_id  uuid REFERENCES categories(id) ON DELETE CASCADE,
  slug       text UNIQUE NOT NULL,
  title      text NOT NULL,
  icon       text,
  sort_order int NOT NULL DEFAULT 0
);

CREATE TABLE diagrams (
  id           uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  slug         text UNIQUE NOT NULL,
  svg_url      text NOT NULL,
  layers       jsonb NOT NULL DEFAULT '{}',   -- named layers: parts, labels, highlights
  hotspots     jsonb NOT NULL DEFAULT '[]',   -- tappable regions -> part descriptions
  long_desc    text NOT NULL,                 -- accessibility text AND agent-readable
  source       diagram_source NOT NULL,
  source_url   text,
  license      text,
  created_at   timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE guides (
  id           uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  category_id  uuid NOT NULL REFERENCES categories(id),
  slug         text UNIQUE NOT NULL,
  title        text NOT NULL,
  difficulty   difficulty NOT NULL,
  minutes      int,
  tools        text[] NOT NULL DEFAULT '{}',
  parts        text[] NOT NULL DEFAULT '{}',
  safety_level text NOT NULL,                 -- 'normal' | 'gated' | 'pro_only'
  diy_cost_cents  int,
  shop_cost_low   int,
  shop_cost_high  int
);

CREATE TABLE guide_steps (
  id         uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  guide_id   uuid NOT NULL REFERENCES guides(id) ON DELETE CASCADE,
  index      int  NOT NULL,
  body       text NOT NULL,                   -- one sentence, < 20 words
  plain_note text,
  diagram_id uuid REFERENCES diagrams(id),
  warning    text,
  checkpoint text,
  UNIQUE (guide_id, index)
);

-- Which vehicles a guide actually applies to. Showing the wrong guide is worse
-- than showing none.
CREATE TABLE vehicle_fitment (
  guide_id   uuid REFERENCES guides(id) ON DELETE CASCADE,
  year_from  int,
  year_to    int,
  make       text,
  model      text,
  engine     text
);
CREATE INDEX ON vehicle_fitment (make, model, year_from, year_to);

-- ── Diagnostics ─────────────────────────────────────────────────────────────

CREATE TABLE dtc_codes (
  code          text PRIMARY KEY,             -- 'P0301'
  system        text NOT NULL,
  plain_title   text NOT NULL,                -- 'Cylinder 1 is misfiring.'
  plain_meaning text NOT NULL,
  severity      dtc_severity NOT NULL,
  common_causes text[] NOT NULL DEFAULT '{}'  -- cheapest first
);

CREATE TABLE obd_sessions (
  id         uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  vehicle_id uuid NOT NULL REFERENCES vehicles(id) ON DELETE CASCADE,
  started_at timestamptz NOT NULL DEFAULT now(),
  codes      jsonb NOT NULL DEFAULT '[]',
  live_pids  jsonb NOT NULL DEFAULT '{}'
);

-- ── Roadside ────────────────────────────────────────────────────────────────

CREATE TABLE sos_incidents (
  id           uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id      uuid NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  vehicle_id   uuid REFERENCES vehicles(id) ON DELETE SET NULL,
  lat          double precision,
  lng          double precision,
  triage_path  text[],
  outcome      text,
  dispatch_ref text,
  occurred_at  timestamptz NOT NULL DEFAULT now(),
  resolved_at  timestamptz
);

-- ── Agent audit + billing ───────────────────────────────────────────────────

CREATE TABLE agent_turns (
  id          uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id     uuid NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  product     text NOT NULL,                  -- 'auto' | 'companion' | 'mindflow'
  agent       text NOT NULL,
  thread_id   uuid NOT NULL,
  tokens_in   int,
  tokens_out  int,
  tools_used  text[] NOT NULL DEFAULT '{}',
  metered     boolean NOT NULL DEFAULT false, -- source of truth for the meter
  created_at  timestamptz NOT NULL DEFAULT now()
);
CREATE INDEX ON agent_turns (user_id, created_at DESC);
