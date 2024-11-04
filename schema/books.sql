CREATE TABLE users (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(50) NOT NULL,
    email VARCHAR(50) NOT NULL,
    password_hash BYTEA NOT NULL,
    date_added TIMESTAMP WITH TIME ZONE DEFAULT now(),
    UNIQUE (email)
);

CREATE TABLE books (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(50) NOT NULL,
    author VARCHAR(50) NOT NULL,
    year NUMERIC(4) NOT NULL,
    isbn10 VARCHAR(10) NOT NULL,
    synopsis TEXT NOT NULL,
    added_by UUID REFERENCES users (id),
    date_added TIMESTAMP WITH TIME ZONE DEFAULT now()
);

CREATE TYPE reading_status AS ENUM ('WANT_TO_READ', 'READING', 'READ');

CREATE TABLE users_books (
    user_id UUID REFERENCES users (id) NOT NULL,
    book_id UUID REFERENCES books (id) NOT NULL,
    status reading_status DEFAULT 'WANT_TO_READ',
    date_added TIMESTAMP WITH TIME ZONE DEFAULT now(),
    date_updated TIMESTAMP WITH TIME ZONE DEFAULT now()
);

CREATE TABLE books_ratings (
    book_id UUID REFERENCES books (id) NOT NULL,
    user_id UUID REFERENCES users (id) NOT NULL,
    rating NUMERIC(2, 1) 
);

--  do this at the end after all the objects have been created

GRANT pg_read_all_data TO books;
GRANT pg_write_all_data TO books;
