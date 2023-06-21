import pymysql
import pandas as pd
from datetime import datetime
from fromsecret import get_db_secret

HOST, USER, PASSWORD, DB = get_db_secret('devilflow_sakila')

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
        #conn.open()
        data = pd.read_csv(filepath)
        df = pd.DataFrame(data=data, columns=['first_name', 'last_name','last_update'])

        for row in df.itertuples():
            #ct = datetime.now()

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

def truncate_actor():
    try:
        conn, cursor = mysqlconnection()
        cursor.execute("TRUNCATE TABLE actor")
        conn.commit()
    finally:
        conn.close()

def truncate_film_actor():
    try:
        conn, cursor = mysqlconnection()
        cursor.execute("TRUNCATE TABLE film_actor")
        conn.commit()
    finally:
        conn.close()


#truncate_film_actor()
#truncate_actor()
#insert_actors(filepath='C:\ScriptAdminRoot\Execute\main\ReadDB\insert_actor_massivo.csv')
#insert_film_actor(filepath='C:\ScriptAdminRoot\Execute\main\ReadDB\insert_film_actor_massivo.csv')

insert_actors(filepath='C:\ScriptAdminRoot\Execute\main\ReadDB\insert.csv')