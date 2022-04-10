CREATE TABLE poll
(
    id           SERIAL,
    topic        TEXT    NOT NULL,
    description  TEXT,
    "end"        BIGINT  NOT NULL,
    emoji        TEXT    NOT NULL,
    is_permanent BOOLEAN NOT NULL DEFAULT FALSE
);

CREATE TABLE comment
(
    id          SERIAL,
    poll_id     INTEGER NOT NULL,
    parent_id   INTEGER,
    user_id     INTEGER,
    comment     TEXT    NOT NULL,
    timestamp   BIGINT  NOT NULL,
    is_approved BOOLEAN NOT NULL DEFAULT FALSE
);

CREATE TABLE pending_login
(
    id         SERIAL,
    token      TEXT   NOT NULL,
    code       TEXT   NOT NULL,
    expiration BIGINT NOT NULL
);

CREATE TABLE "user"
(
    id       SERIAL,
    token    TEXT    NOT NULL,
    is_admin BOOLEAN NOT NULL DEFAULT FALSE
);

CREATE TABLE vote
(
    id         SERIAL,
    user_id    INTEGER,
    comment_id INTEGER NOT NULL,
    score      INTEGER NOT NULL,
    reason     TEXT DEFAULT NULL,
    timestamp  BIGINT  NOT NULL
);

CREATE TABLE announcement
(
    id          SERIAL,
    poll_id     INT  DEFAULT NULL,
    title       TEXT   NOT NULL,
    description TEXT   NOT NULL,
    posted_time BIGINT NOT NULL,
    emoji       TEXT DEFAULT NULL
);
