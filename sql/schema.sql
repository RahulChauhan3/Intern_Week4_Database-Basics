-- PostgreSQL-compatible blog schema
CREATE TABLE users (
 id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
 username VARCHAR(40) NOT NULL UNIQUE,
 email VARCHAR(255) NOT NULL UNIQUE,
 password_hash VARCHAR(255) NOT NULL,
 display_name VARCHAR(80) NOT NULL,
 created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE posts (
 id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
 author_id BIGINT NOT NULL REFERENCES users(id) ON DELETE RESTRICT,
 title VARCHAR(180) NOT NULL,
 slug VARCHAR(200) NOT NULL UNIQUE,
 body TEXT NOT NULL,
 status VARCHAR(16) NOT NULL DEFAULT 'draft' CHECK(status IN ('draft','published','archived')),
 published_at TIMESTAMP NULL,
 created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
 updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE comments (
 id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
 post_id BIGINT NOT NULL REFERENCES posts(id) ON DELETE CASCADE,
 user_id BIGINT NOT NULL REFERENCES users(id) ON DELETE RESTRICT,
 body TEXT NOT NULL,
 status VARCHAR(16) NOT NULL DEFAULT 'visible' CHECK(status IN ('visible','hidden')),
 created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);
CREATE INDEX idx_posts_author ON posts(author_id);
CREATE INDEX idx_posts_status_date ON posts(status,published_at DESC);
CREATE INDEX idx_comments_post_date ON comments(post_id,created_at ASC);
CREATE INDEX idx_comments_user ON comments(user_id);
