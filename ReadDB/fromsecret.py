import json

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

#get_db_secret('devilflow_sakila')