DROP TABLE IF EXISTS "category" CASCADE;
CREATE TABLE "category" (
    id SERIAL PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMP
);


DROP TABLE IF EXISTS "item" CASCADE;
CREATE TABLE "item" (
    id SERIAL PRIMARY KEY,
    category_id INTEGER,
    title VARCHAR(255) NOT NULL,
    price NUMERIC(8, 2) NOT NULL CHECK (price > 0),
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMP
);


DROP TABLE IF EXISTS "tag" CASCADE;
CREATE TABLE "tag" (
    id SERIAL PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMP
);


DROP TABLE IF EXISTS "item_tag";
CREATE TABLE "item_tag" (
    item_id INTEGER NOT NULL,
    tag_id INTEGER NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMP
);


ALTER TABLE "item" ADD CONSTRAINT category_id_fk FOREIGN KEY (category_id) REFERENCES "category"(id) ON DELETE SET NULL;
ALTER TABLE "item_tag" ADD CONSTRAINT item_id_fk FOREIGN KEY (item_id) REFERENCES "item"(id) ON DELETE CASCADE;
ALTER TABLE "item_tag" ADD CONSTRAINT tag_id_fk FOREIGN KEY (tag_id) REFERENCES "tag"(id) ON DELETE CASCADE;


CREATE OR REPLACE FUNCTION update_timestamp_col()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END
$$ language 'plpgsql';

CREATE TRIGGER update_category_timestamp_col BEFORE UPDATE
ON "category" FOR EACH ROW EXECUTE PROCEDURE update_timestamp_col();

CREATE TRIGGER update_item_timestamp_col BEFORE UPDATE
ON "item" FOR EACH ROW EXECUTE PROCEDURE update_timestamp_col();

CREATE TRIGGER update_tag_timestamp_col BEFORE UPDATE
ON "tag" FOR EACH ROW EXECUTE PROCEDURE update_timestamp_col();

CREATE TRIGGER update_item_tag_timestamp_col BEFORE UPDATE
ON "item_tag" FOR EACH ROW EXECUTE PROCEDURE update_timestamp_col();


INSERT INTO "category" (title) VALUES ('cat_1'),('cat_2'),('cat_3');
INSERT INTO "item" (category_id, title, price) VALUES
(1, 'it_1', 19.99),
(1, 'it_2', 9.99),
(2, 'it_3', 99.99),
(2, 'it_4', 999.99),
(3, 'it_5', 1.99),
(3, 'it_6', 2.99);
INSERT INTO "tag" (title) VALUES ('tag_1'),('tag_2'),('tag_3');
INSERT INTO "item_tag" (item_id, tag_id) VALUES (1, 1), (1, 2), (2, 3), (4, 2);


DROP TABLE IF EXISTS "basket";
CREATE TABLE "basket" (
    id SERIAL PRIMARY KEY,
    title VARCHAR(50) NOT NULL
);


INSERT INTO "basket" (title) VALUES
('apple'), ('apple'),
('banana'), ('banana'), ('banana'),
('orange');

SELECT title, count(title) FROM "basket" GROUP BY title HAVING count(title) > 1;

-- way 1
EXPLAIN ANALYZE DELETE FROM
    basket AS a USING basket AS b
WHERE
    a.id < b.id AND a.title = b.title;

-- way 2
EXPLAIN ANALYZE DELETE FROM basket WHERE id IN (
    SELECT id FROM (
        SELECT
            id,
            ROW_NUMBER() OVER (PARTITION BY title ORDER BY id) AS num
        FROM "basket"
    ) AS tmp
    WHERE tmp.num > 1
);

-- way 3
CREATE TABLE "basket_temp" (LIKE "basket");
INSERT INTO "basket_temp" (title, id) SELECT DISTINCT ON (title) title, id FROM "basket";
DROP TABLE "basket";
ALTER TABLE "basket_temp" RENAME TO "basket";
CREATE SEQUENCE basket_id_sequnce;
ALTER TABLE "basket" ALTER COLUMN id SET DEFAULT nextval('basket_id_sequnce');
ALTER SEQUENCE basket_id_sequnce OWNED BY "basket".id;
SELECT setval('basket_id_sequnce', SELECT MAX(id) FROM "basket");

CREATE TABLE "basket_temp" (LIKE "basket" INCLUDING DEFAULTS INCLUDING CONSTRAINTS INCLUDING INDEXES);
