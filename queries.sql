DROP TABLE IF EXISTS "category" CASCADE;
CREATE TABLE "category" (
    id SERIAL PRIMARY KEY,
    title VARCHAR(255) NOT NULL
);


DROP TABLE IF EXISTS "item" CASCADE;
CREATE TABLE "item" (
    id SERIAL PRIMARY KEY,
    category_id INTEGER,
    title VARCHAR(255) NOT NULL,
    price NUMERIC(8, 2) NOT NULL CHECK (price > 0)
);


DROP TABLE IF EXISTS "tag" CASCADE;
CREATE TABLE "tag" (
    id SERIAL PRIMARY KEY,
    title VARCHAR(255) NOT NULL
);


DROP TABLE IF EXISTS "item_tag";
CREATE TABLE "item_tag" (
    item_id INTEGER NOT NULL,
    tag_id INTEGER NOT NULL
);


ALTER TABLE "item" ADD CONSTRAINT category_id_fk FOREIGN KEY (category_id) REFERENCES "category"(id) ON DELETE SET NULL;
ALTER TABLE "item_tag" ADD CONSTRAINT item_id_fk FOREIGN KEY (item_id) REFERENCES "item"(id) ON DELETE CASCADE;
ALTER TABLE "item_tag" ADD CONSTRAINT tag_id_fk FOREIGN KEY (tag_id) REFERENCES "tag"(id) ON DELETE CASCADE;



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



