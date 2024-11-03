CREATE TABLE books (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(50) NOT NULL,
    author VARCHAR(50) NOT NULL,
    year NUMERIC(4) NOT NULL,
    isbn10 VARCHAR(10) NOT NULL,
    synopsis TEXT NOT NULL
);

--  do this at the end after all the objects have been created

GRANT pg_read_all_data TO books;
GRANT pg_write_all_data TO books;
