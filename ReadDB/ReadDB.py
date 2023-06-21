import pymysql
import pandas as pd
from datetime import datetime
from fromsecret import get_db_secret

HOST, USER, PASSWORD, DB = get_db_secret('devilflow_sakila')

conn = pymysql.connect(
    host=HOST,
    user=USER,
    password=PASSWORD,
    db=DB,
    charset='utf8mb4',
    cursorclass=pymysql.cursors.DictCursor
)
cursor = conn.cursor()

EXAMPLESELECT =     ''' 
    with conn.cursor() as cur:
        sql = 'SELECT * FROM actor'
        cur.execute(sql)

        rows = cur.fetchall()

        for row in rows:
            print(row)
    '''

EXAMPLEINSERT = '''INSERT INTO `actor` (`first_name`, `last_name`, `last_update`) VALUES (%s, %s, %s)'''
try:
    data = pd.read_csv(r'C:\ScriptAdminRoot\\Execute\\main\\ReadDB\\insert.csv')
    df = pd.DataFrame(data=data, columns=['first_name', 'last_name','last_update'])

    for row in df.itertuples():
        ct = datetime.now()
        cursor.execute("INSERT INTO actor (first_name, last_name, last_update) VALUES(%s,%s,%s)",
            (
                row.first_name,
                row.last_name,
                ct,
            )
        )

    conn.commit()
finally:
    conn.close()


