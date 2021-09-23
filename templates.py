TABLE_TEMPLATE = 'CREATE TABLE "{table_name}" (\n{fields}\n);\n'

ID_FIELD_TEMPLATE = '    id SERIAL PRIMARY KEY'
CREATED_FIELD_TEMPLATE = '    created_at TIMESTAMP NOT NULL DEFAULT NOW()'
UPDATED_FIELD_TEMPLATE = '    updated_at TIMESTAMP'

TRIGGER_TEMPLATE = (
    'CREATE OR REPLACE FUNCTION update_timestamp_col()\n'
    'RETURNS TRIGGER AS $$\n'
    'BEGIN\n'
    '    NEW.updated_at = NOW();\n'
    '    RETURN NEW;\n'
    'END\n'
    '$$ language \'plpgsql\';\n'
)

UPDATED_AT_TRIGGER_TEMPLATE = (
    'CREATE TRIGGER update_{table_name}_timestamp_col BEFORE UPDATE '
    'ON "{table_name}" FOR EACH ROW EXECUTE PROCEDURE update_timestamp_col();'
)
