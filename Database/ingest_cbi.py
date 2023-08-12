from jobs import authdb, ReadCBI, TaskData

FILEPATH = 'E:\\bkp scripts\CBI\\20230624_014734_MIFENDPN.PROD.SALDOCC.IA3893CC.BNPAZI'

def readCBI(filepath:str) -> TaskData:
    task_dati = {
        "data":[
            {"path": filepath},
        ],
    }

    cbi = ReadCBI()
    dati = cbi.run(task_dati["data"][0])
    return dati

