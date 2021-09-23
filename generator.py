from yaml import load, Loader

from templates import (
    TABLE_TEMPLATE,
    ID_FIELD_TEMPLATE,
    UPDATED_FIELD_TEMPLATE,
    CREATED_FIELD_TEMPLATE,
    TRIGGER_TEMPLATE,
    UPDATED_AT_TRIGGER_TEMPLATE
)


with open('schema.yaml', 'r') as source:
    schema = load(source, Loader=Loader)

sql_data = {}
triggers = []

for table_name, table_data in schema.items():
    table = table_name.lower()

    if table not in sql_data:
        sql_data[table] = [ID_FIELD_TEMPLATE]
        triggers.append(UPDATED_AT_TRIGGER_TEMPLATE.format(table_name=table))

    for field_name, field_type in schema[table_name]['fields'].items():
        sql_data[table].append(f'    {field_name} {field_type.upper()}')

    sql_data[table] += [CREATED_FIELD_TEMPLATE, UPDATED_FIELD_TEMPLATE]

tables = []

for table, fields in sql_data.items():
    tables.append(TABLE_TEMPLATE.format(
        table_name=table,
        fields=',\n'.join(fields)
    ))

sql_dump = tables + [TRIGGER_TEMPLATE] + triggers

with open('schema.sql', 'w') as source:
    source.write('\n'.join(sql_dump))
    source.write('\n')
