CREATE TABLE IF NOT EXISTS flow(
  run_id varchar NOT NULL,
  event_uuid varchar NOT NULL,
  state smallint NOT NULL,
  last_updated bigint NOT NULL,
  timeout bigint NOT NULL,
);

CREATE UNIQUE INDEX IF NOT EXISTS ON flow(run_id);
CREATE INDEX IF NOT EXISTS ON flow(state);
CREATE INDEX IF NOT EXISTS ON flow(timeout);

CREATE EXTENSION IF NOT EXISTS pgcrypto;

DELETE FROM flow;

INSERT INTO flow
    SELECT
      gen_random_uuid()::varchar,
      md5(random()::text) AS event_uuid,
      0,
      round(extract('epoch' FROM now() - random() * (now() - timestamp '07-10-2017')) * 1000),
      round(extract('epoch' FROM now() + random() * (timestamp '07-24-2017' - now())) * 1000)
    FROM generate_series(1,1240184) AS run_id;

INSERT INTO flow
    SELECT
      gen_random_uuid()::varchar,
      md5(random()::text) AS event_uuid,
      1,
      round(extract('epoch' FROM now() - random() * (now() - timestamp '07-10-2017')) * 1000),
      round(extract('epoch' FROM now() + random() * (timestamp '07-24-2017' - now())) * 1000)
    FROM generate_series(1,2028429) AS run_id;

INSERT INTO flow
    SELECT
      gen_random_uuid()::varchar,
      md5(random()::text) AS event_uuid,
      3 + round(random()),
      -1,
      -1
    FROM generate_series(1,3028429) AS run_id;
