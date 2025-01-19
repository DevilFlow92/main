import requests, json
from fromsecret import authdb

URLBASE = 'https://api.webapp.prod.blv.foodcase-services.com/BLV_WebApp_WS/webresources/BLV-api/'
ENDPOINT = 'components?lang=it'

DB = "devilflow_bodybuilding"
TABLE = 'component'

def fetch_data(endpoint):
    url = f'{URLBASE}{endpoint}'
    res = requests.get(url)
    res_json = json.dumps(res.json())
    data = json.loads(res_json)
    return data

def insert_data(data,table):
    conn, cursor = authdb(DB)
    for row in data:
        col_names = f"({','.join(row.keys())})"
        placeholders = f"VALUES ({','.join(['%s' for _ in row.values()])})"
        _values = [row[c] for c in row]
        insert_statement = f"INSERT INTO {table} {col_names} {placeholders}"
        print(insert_statement)
        print(_values)
        #cursor.execute(insert_statement,_values)
    #conn.commit()
    #cursor.close()
    #conn.close()

data = fetch_data(ENDPOINT)

insert_data(data,TABLE)


