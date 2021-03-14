CREATE DATABASE native_plants;

CREATE TABLE plants (
    id SERIAL PRIMARY KEY,
    name TEXT,
    latin_name TEXT,
    description TEXT,
    family TEXT,
    color TEXT,
    petal_shape TEXT,
    leaf_shape TEXT,
    leaf_margin TEXT,
    location TEXT,
    plant_status TEXT,
    image_url TEXT,
    image_timestamp TEXT,
    user_id INTEGER
);

CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    username TEXT,
    email TEXT,
    password_digest TEXT
);


