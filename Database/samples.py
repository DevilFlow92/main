import pymysql
import pandas as pd
from jobs.fromsecret import get_db_secret

HOST, USER, PASSWORD, DB = get_db_secret('devilflow_main')

def mysqlconnection() -> tuple:
    conn = pymysql.connect(
        host=HOST,
        user=USER,
        password=PASSWORD,
        db=DB,
        charset='utf8mb4',
        cursorclass=pymysql.cursors.DictCursor
    )
    cursor = conn.cursor()
    return conn, cursor

def insert_actors(filepath):
    try:
        conn, cursor = mysqlconnection()
        data = pd.read_csv(filepath)
        df = pd.DataFrame(data=data, columns=['first_name', 'last_name','last_update'])

        for row in df.itertuples():
            cursor.execute("INSERT INTO actor (first_name, last_name, last_update) VALUES(%s,%s,%s)",
                (
                    row.first_name,
                    row.last_name,
                    row.last_update,
                )
            )

        conn.commit()
    finally:
        conn.close()

def insert_film_actor(filepath):
    try:
        conn, cursor = mysqlconnection()
        data = pd.read_csv(filepath)
        df = pd.DataFrame(data=data, columns=['actor_id', 'film_id','last_update'])

        for row in df.itertuples():
            cursor.execute("INSERT INTO film_actor(actor_id,film_id,last_update) VALUES(%s,%s,%s)",
                           (row.actor_id, row.film_id, row.last_update)
                           )
        conn.commit()

    finally:
        conn.close()

def insert_valute(filepath):
    try:
        conn,cursor = mysqlconnection()
        data = pd.read_csv(filepath)
        df = pd.DataFrame(data=data, columns=['Sigla', 'Etichetta'])

        for row in df.itertuples():
            query = "INSERT INTO D_Valuta (Etichetta, Sigla) values(%s,%s)"
            val = (row.Etichetta, row.Sigla)
            cursor.execute(query,val)

        conn.commit()

    finally:
        conn.close()

def truncatetable(table:str):
    try:
        conn, cursor = mysqlconnection()
        query = f'TRUNCATE TABLE {table}'
        cursor.execute(query)
        conn.commit()
    finally:
        conn.close()



#insert_valute(filepath="C:\ScriptAdminRoot\Execute\main\ReadDB\\valute.csv")