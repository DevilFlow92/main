import json
import os
from datetime import datetime, timedelta
from pathlib import PosixPath
from typing import Any, List, Tuple
import sys
sys.path.append('../')

from ext.fromsecret import get_db_secret
from jobs import ReadCBI, ReadDB
from validation import Coerce, Schema
from validation.coerce import to_date, to_stripped_string
from types.jobs import TaskData
import pymysql


def check_condition(errors:List[str]) -> bool:
    return True if errors else False

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

def get_file() -> Tuple[Any, str, TaskData]:
    try:
        localpath = 'E:\\bkp scripts\CBI\\20230624_014734_MIFENDPN.PROD.SALDOCC.IA3893CC.BNPAZI'
        FileName = '20230624_014734_MIFENDPN.PROD.SALDOCC.IA3893CC.BNPAZI'
        output = {"path":PosixPath(localpath)}
        return {"path": str(localpath)}, FileName, {"data": [output], "errors": [], "meta":{}}
    
    except Exception as ex:
        raise ex

def ChooseIngest(secretdb: str, data: TaskData, max_id: TaskData) -> TaskData:
    conn, cursor = authdb(secretdb)
    id_rendicontazione = max_id["data"][0]["IdRendicontazione"]
    path_origine = data["meta"]["path"]
    filename = os.path.basename(path_origine)
    datafile = '2023-06-24'
    id_etl = 1
    fornitore = 'BNP'
    Pull_ts = '2023-06-24'
    ingest_ts = datetime.now().strftime("%y-%m-%d %H-%M-%S")

    try:
        insert_metaid = '''insert into e_meta (FileSorgente,DataFile,Ingest_ts,Pull_ts,Fornitore,IdETL)
        values (%s,%s,%s,%s,%s,%s)
        '''
        val_metaid = (filename, datafile, ingest_ts, Pull_ts, fornitore, id_etl)
        cursor.execute(insert_metaid,val_metaid)
        #cursor.commit()

        cursor.execute("SELECT LAST_INSERT_ID()")
        meta_id = cursor.fetchone()

        for row in data["data"]:
            id_rendicontazione += 1
            payload = json.loads(row["payload"])
            
            #inserisci record di testa RH
            data_creazione = datetime.strptime(payload["testa"]["data_creazione"], "%d%m%y")
            insert_head_flussocbi = '''INSERT INTO E_flussocbi_liquid (meta_id, IdRendicontazione, TipoMessaggio,Mittente_RH, Ricevente_RH, DataCreazione_RH, NomeSupporto_RH)
            VALUES (%s, %s, %s, %s, %s, %s, %s)")
            '''
            val_head_flussocbi = (meta_id,
                            id_rendicontazione,
                            payload["testa"]["tipo_record"],
                            payload["testa"]["mittente"],
                            data_creazione,
                            payload["testa"]["nome_supporto"],

            )
            cursor.execute(insert_head_flussocbi,val_head_flussocbi)
            #cursor.commit()

            for record in payload["records"]:
                if record["tipo_record"] =="61":
                    saldo_iniziale_quadratura = float(record["saldo_iniziale_quadratura"].replace(",", "."))
                    data_contabile = datetime.strptime(record["data_contabile"], "%d%m%y")
                    insert_flussocbi = '''INSERT INTO E_flussocbi_liquid (meta_id, IdRendicontazione, TipoMessaggio,
                                Progressivo_61, ABIOriginarioBanca_61, Causale_61, Descrizione_61,
                                TipoConto_61, CIN_61, ABI_61, CAB_61, NumeroConto_61, CodiceDivisa_61,
                                DataContabile_61, Segno_61, SaldoInizialeQuadratura_61, CodicePaese_61,
                                CheckDigit_61)
                    VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)
                    '''
                    val_flussocbi = (
                        meta_id,
                        id_rendicontazione,
                        record["tipo_record"],
                                record["codice_abi_originario_banca"],
                                record["causale"],
                                record["descrizione"],
                                record["tipo_conto"],
                                record["cin"],
                                record["codice_abi_banca"],
                                record["cab_banca"],
                                record["conto_corrente"],
                                record["codice_divisa"],
                                data_contabile,
                                record["segno"],
                                saldo_iniziale_quadratura,
                                record["codice_paese"],
                                record["check_digit"],   
                    )
                   
                if record["tipo_record"] == "62":
                    importo_movimento = float(record["importo_movimento"].replace(",", "."))
                    data_valuta = datetime.strptime(record["data_valuta"], "%d%m%y")
                    data_registrazione_eo_contabile = datetime.strptime(
                        record["data_registrazione_eo_contabile"], "%d%m%y"
                    )
                    insert_flussocbi = '''INSERT INTO orga.L_MIKONO_FlussoCBI_SaldiLiquid
                                (meta_id, IdRendicontazione, TipoMessaggio,
                                NumeroProgressivo_62, ProgressivoMovimento_62, DataValuta_62,
                                DataRegistrazione_Contabile_62, SegnoMovimento_62, ImportoMovimento_62,
                                CausaleCBI_62, CausaleInterna_62, NumeroAssegno_62, RiferimentoBanca_62,
                                TipoRiferimentoCliente_62, RiferimentoCliente_62)
                                VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)
                                '''
                    val_flussocbi = (
                        meta_id,
                        id_rendicontazione,
                        record["numero_progressivo"],
                        record["progressivo_movimento"],
                        data_valuta,
                        data_registrazione_eo_contabile,
                        record["segno_movimento"],
                        importo_movimento,
                        record["causale cbi"],
                        record["causale_interna"],
                        record["numero_assegno"],
                        record["riferimento_banca"],
                        record["tipo_riferimento_cliente"],
                        record["riferimento_cliente_descrizione_movimento"],         
                    )
                
                if record["tipo_record"] == "63":
                    insert_flussocbi = '''INSERT INTO E_FlussoCBI_SaldiLiquid (meta_id, IdRendicontazione, TipoMessaggio)
                    values(%s,%s,%s)
                    '''
                    val_flussocbi = (
                        meta_id,
                        id_rendicontazione,
                        record["tipo_record"]
                    )

                if record["tipo_record"] == "64":
                    insert_flussocbi = ''''''
                    val_flussocbi = ()
                
                if record["tipo_record"] == "65":
                    insert_flussocbi = ''''''
                    val_flussocbi = ()
                
                cursor.execute(insert_flussocbi, val_flussocbi)
                #cursor.commit()

            #inserisci record di coda EF
            data_creazione = datetime.strptime(payload["coda"]["data_creazione"], "%d%m%y")
            insert_tail_flussocbi = '''INSERT INTO orga.L_MIKONO_FlussoCBI_SaldiLiquid
            (meta_id, IdRendicontazione, TipoMessaggio, EF_Mittente, EF_Ricevente, EF_DataCreazione
            EF_NomeSupporto, EF_NumeroRendicontazioni, EF_NumeroRecord)
            VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s)
            '''
            val_tail_flussocbi = (
                meta_id,
                id_rendicontazione,
                payload["coda"]["tipo_record"],
                payload["coda"]["mittente"],
                payload["coda"]["ricevente"],
                data_creazione,
                payload["coda"]["nome_supporto"],
                payload["coda"]["numero_disposizioni"],
                payload["coda"]["numero_record"],
            )
            cursor.execute(insert_tail_flussocbi, val_tail_flussocbi)
        
        cursor.commit()               
    except Exception as ex:
        conn.rollback()
        raise ex
    finally:
        conn.close()

def OrganizeIngest(secretdb:str, data:TaskData, max_id: TaskData, IdImport: TaskData) -> TaskData:
    conn, cursor = authdb(secretdb)
    id_rendicontazione = max_id["data"][0]["IdRendicontazione"]
    id_import = IdImport["data"][0]["IdRendicontazione"]
    id_import += 1
    path_origine = data["meta"]["path"]
    filename = os.path.basename(path_origine)
    merge_row: List[Any] = []
    for row in data["data"]:
        id_rendicontazione +=1
        payload = json.loads(row["payload"])
        for record in payload["records"]:
            if record["tipo_record"] == "61":
                merge_row.append(record["conto_corrente"])
                data_contabile = datetime.strptime(record["data_contabile"], "%d%m%y")
                merge_row.append(data_contabile)

            if record["tipo_record"] == "64":
                merge_row.append(record["codice_divisa"])
                merge_row.append(record["segno_saldo_contabile"])
                merge_row.append(float(record["saldo_contabile"].replace(",", ".")))
                merge_row.append(record["segno saldo liquido"])
                merge_row.append(float(record["saldo_liquido"].replace(",", ".")))

            if len(merge_row) == 7:
                try:
                    insert_saldiLiquid = '''INSERT INTO orga.MIKONO_FlussoCBI_SaldiLiquid
                                (NomeFileOrigine, IdImport, IdRendicontazione, NumeroConto_61,
                                DataContabile_61, CodiceDivisa_64, SegnoSaldoContabile_64,
                                SaldoContabile_64, SegnoSaldoLiquido_64, SaldoLiquido_64)
                                VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)'''
                    val_saldiLiquid = ()

                except Exception as ex:
                    if conn:
                        conn.rollback()
                finally:
                    merge_row = []
    return {
        "data": [data_contabile],
        "errors": [],
        "meta": {"isEmpty": False},
    }
    
def IngestMovimentoContoBancario(secretdb:str, data:TaskData, FileName: str, DataFlusso:Any) -> TaskData:
    conn, cursor = authdb(secretdb)

def process():
    local_path, FileName, source_file = get_file()

    cbi = ReadCBI()
    Dati = cbi(data=local_path)
    breakpoint()

    query_id = "SELECT MAX(IdRendicontaione) as IdRendicontazione from e_flussocbi_liquid"
    schema_id = Schema({"IdRendicontazione": int})
    max_id_ = ReadDB(db='devilflow_main', schema=schema_id, query=query_id)
    max_id = max_id_(params=())
        
    IngestCBI = ChooseIngest(secretdb='devilflow_main', data=Dati, max_id=max_id)

    #query_import_id = "SELECT MAX(IdImport) AS IdImport FROM E_SaldoCBI_Liquid"
    #schema_id = Schema({"IdImport": int})
    #IdImport_ = ReadDB(db='devilflow_main', schema=schema_id, query=query_import_id)
    #IdImport = IdImport_(params=())

    #new_data = OrganizeIngest(
    #    secrectdb='devilflow_main',
    #    data=Dati,
    #    max_id=max_id,
    #    IdImport=IdImport,
    #)

    #if new_data:
    #    query_ingest = "select * from v_ingest_FlussoCBI_SaldiLiquid"
    #    schema_ingest = Schema(
    #        {
    #            "NomeFileOrigine": Coerce(
    #                to_stripped_string(),
    #                nones=[
    #                    "",
    #                ],
    #            ),
    #            "NumeroConto_61": Coerce(
    #                to_stripped_string(),
    #                nones=[
    #                    "",
    #                ],
    #            ),
    #            "DataContabile_61": Coerce(
    #                to_date(["%Y%m%d", "%Y-%m-%d", "%Y/%m/%d"]),
    #                nones=[
    #                    "",
    #                ],
    #            ),
    #            "CodiceDivisa_64": Coerce(
    #                to_stripped_string(),
    #                nones=[
    #                    "",
    #                ],
    #            ),
    #            "SegnoSaldoContabile_64": Coerce(
    #                to_stripped_string(),
    #                nones=[
    #                    "",
    #                ],
    #            ),
    #            "SaldoContabile_64": Coerce(
    #                float,
    #                nones=[
    #                    "",
    #                ],
    #            ),
    #            "SegnoSaldoLiquido_64": Coerce(
    #                to_stripped_string(),
    #                nones=[
    #                    "",
    #                ],
    #            ),
    #            "SaldoLiquido_64": Coerce(
    #                float,
    #                nones=[
    #                    "",
    #                ],
    #            ),
    #        }
    #    )

    #    data_to_ingest_ = ReadDB(
    #        db='devilflow_main',
    #        schema=schema_ingest,
    #        query= query_ingest,
    #    )
    #    readed_ = data_to_ingest_(params=())

    #    ingest_data = IngestMovimentoContoBancario(
    #        secretdb='devilflow_main',
    #        FileName=FileName,
    #        data=readed_,
    #        DataFlusso=new_data["data"][0],
    #    )
        
    #    check_ingest_data = check_condition(ingest_data["errors"])

    #    if check_ingest_data is True:
    #        print('error')
    #    else:
    #        print('ok')


process()