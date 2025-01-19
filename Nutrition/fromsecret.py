import json
import pymysql
from typing import cast

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

def get_ftp_secret(secret):
    jsonpath = f'{CONFIG}/ftps.json'
    f = open(jsonpath)
    data = json.load(f)
    return data[secret]

def get_dbload_conf(secret) -> tuple:
    jsonpath = f'{CONFIG}/load_db.json'
    f = open(jsonpath)
    data = json.load(f)
    gdfolder = data[secret]['GDRIVEFOLDER']
    sourcepath = data[secret]['SOURCEPATH']
    db = data[secret]['DB']
    query = data[secret]['QUERY']
    fields = data[secret]['FIELDS']
    fields = fields.split(',')
    filename = data[secret]['FILENAME']

    return (gdfolder, sourcepath, db, query, fields, filename)