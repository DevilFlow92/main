import json
import pymysql

CONFIG = "C:\ScriptAdminRoot\Config"

def get_db_secret(secret) -> tuple:
    jsonpath = f'{CONFIG}\database.json'
    f = open(jsonpath)
    data = json.load(f)    
    host = data[secret]['host']
    user = data[secret]['user']
    password = data[secret]['password']
    db = data[secret]['db']
    
    return host, user, password, db  

def authdb(secret:str) -> tuple:
    host, user, password, db = get_db_secret(secret) 
    conn = pymysql.connect(
        host=host,
        user=user,
        password=password,
        db=db,
        charset='utf8mb4',
        cursorclass=pymysql.cursors.DictCursor
    )
    cursor = conn.cursor()
    return conn, cursor