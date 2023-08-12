import json
from datetime import timedelta
from typing import Any, Callable, Optional, TypedDict
from types_db import DataRow, TaskData

Rule = dict[str, list[tuple[int, int, str]]]
RH: Rule = {
    "RH": [
        (1, 1, "filler1"),
        (2, 3, "tipo_record"),
        (4, 8, "mittente"),
        (9, 13, "ricevente"),
        (14, 19, "data_creazione"),
        (20, 39, "nome_supporto"),
        (40, 115, "filler2"),
        (116, 120, "campo_non_disponibile"),
    ],
    "61": [
        (1, 1, "filler1"),
        (2, 3, "tipo_record"),
        (4, 10, "numero_progressivo"),
        (11, 23, "filler"),
        (24, 28, "codice_abi_originario_banca"),
        (29, 33, "causale"),
        (34, 49, "descrizione"),
        (50, 51, "tipo_conto"),
        (52, 52, "cin"),
        (53, 57, "codice_abi_banca"),
        (58, 62, "cab_banca"),
        (63, 74, "conto_corrente"),
        (75, 77, "codice_divisa"),
        (78, 83, "data_contabile"),
        (84, 84, "segno"),
        (85, 99, "saldo_iniziale_quadratura"),
        (100, 101, "codice_paese"),
        (102, 103, "check_digit"),
        (104, 120, "filler"),
    ],
    "62": [
        (1, 1, "filler1"),
        (2, 3, "tipo_record"),
        (4, 10, "numero_progressivo"),
        (11, 13, "progressivo_movimento"),
        (14, 19, "data_valuta"),
        (20, 25, "data_registrazione_eo_contabile"),
        (26, 26, "segno_movimento"),
        (27, 41, "importo_movimento"),
        (42, 43, "causale cbi"),
        (44, 45, "causale_interna"),
        (46, 61, "numero_assegno"),
        (62, 77, "riferimento_banca"),
        (78, 86, "tipo_riferimento_cliente"),
        (87, 120, "riferimento_cliente_descrizione_movimento"),
    ],
    "63_34Z1": [
        (1, 1, "filler1"),
        (2, 3, "tipo_record"),
        (4, 10, "numero_progressivo"),
        (11, 13, "progressivo_movimento"),
        (14, 16, "flag_struttura"),
        (17, 39, "identificativo_rapporto"),
        (40, 120, "filler"),
    ],
    "63_48_1": [
        (1, 1, "filler1"),
        (2, 3, "tipo_record"),
        (4, 10, "numero_progressivo"),
        (11, 13, "progressivo_movimento"),
        (14, 16, "flag_struttura"),
        (17, 24, "data_ordine"),
        (25, 40, "codifica_fiscale_ordinante"),
        (41, 80, "cliente_ordinante"),
        (81, 120, "localita"),
    ],
    "63_48_2": [
        (1, 1, "filler"),
        (2, 3, "tipo_record"),
        (4, 10, "numero progressivo"),
        (11, 13, "progressivo movimento"),
        (14, 16, "flag struttura"),
        (17, 66, "Indirizzo ordinante"),
        (67, 100, "iban_ordinante"),
        (101, 120, "filler"),
    ],
    "63_ZIZL_1": [
        (1, 1, "filler"),
        (2, 3, "tipo_record"),
        (4, 10, "numero progressivo"),
        (11, 13, "progressivo movimento"),
        (14, 16, "flag struttura"),
        (17, 34, "importo originario"),
        (35, 37, "codice divisa importo"),
        (38, 55, "importo regolato"),
        (56, 58, "codice divisa"),
        (59, 76, "importo negoziato"),
        (77, 79, "codice divisa importo"),
        (80, 91, "cambio applicato"),
        (92, 104, "importo commissioni"),
        (105, 117, "importo spese"),
        (118, 120, "Codice Paese"),
    ],
    "63_ZIZL_2": [
        (1, 1, "filler"),
        (2, 3, "tipo_record"),
        (4, 10, "numero progressivo"),
        (11, 13, "progressivo movimento"),
        (14, 16, "flag struttura"),
        (17, 120, "ordinante del pagamento"),
    ],
    "63_ZIZL_3": [
        (1, 1, "filler"),
        (2, 3, "tipo_record"),
        (4, 10, "numero progressivo"),
        (11, 13, "progressivo movimento"),
        (14, 16, "flag struttura"),
        (17, 66, "beneficiario"),
        (67, 120, "motivazione del pagamento"),
    ],
    "63_other": [
        (1, 1, "filler"),
        (2, 3, "tipo_record"),
        (4, 10, "numero progressivo"),
        (11, 13, "progressivo movimento"),
        (14, 120, "descrizione"),
    ],
    "63_other_ID1": [
        (14, 16, "flag struttura"),
        (17, 51, "identificativo univoco messaggio"),
        (52, 86, "identificativo end to end"),
        (87, 120, "filler"),
    ],
    "63_other_RI1": [
        (14, 16, "flag struttura"),
        (17, 20, "informazioni riconciliazione"),
    ],
    "63_other_RI2": [
        (14, 16, "flag struttura"),
        (17, 52, "informazioni riconciliazione"),
        (53, 120, "filler"),
    ],
    "64": [
        (1, 1, "filler1"),
        (2, 3, "tipo_record"),
        (4, 10, "numero_progressivo"),
        (11, 13, "codice_divisa"),
        (14, 19, "data_contabile"),
        (20, 20, "segno_saldo_contabile"),
        (21, 35, "saldo_contabile"),
        (36, 36, "segno saldo liquido"),
        (37, 51, "saldo_liquido"),
        (52, 105, "filler"),
        (106, 120, "filler"),
    ],
    "65": [
        (1, 1, "filler1"),
        (2, 3, "tipo_record"),
        (4, 10, "numero_progressivo"),
        (11, 16, "data_liquidita_1"),
        (17, 17, "segno_1"),
        (18, 32, "saldo_liquido_1"),
        (33, 38, "data_liquidita_2"),
        (39, 39, "segno_2"),
        (40, 54, "saldo_liquido_2"),
        (55, 60, "data_liquidita_3"),
        (61, 61, "segno_3"),
        (62, 76, "saldo_liquido_3"),
        (77, 82, "data_liquidita_4"),
        (83, 83, "segno_4"),
        (84, 98, "saldo_liquido_4"),
        (99, 104, "data_liquidita_5"),
        (105, 105, "segno_5"),
        (106, 120, "saldo_liquido_5"),
    ],
}


EC: Rule = {
    "EC": [
        (1, 1, "filler1"),
        (2, 3, "tipo_record"),
        (4, 8, "mittente"),
        (9, 13, "ricevente"),
        (14, 19, "data_creazione"),
        (20, 39, "nome_supporto"),
        (40, 115, "filler"),
        (116, 120, "campo_non_disponibile"),
    ],
    "61": [
        (1, 1, "filler1"),
        (2, 3, "tipo_record"),
        (4, 10, "numero_progressivo"),
        (11, 23, "filler2"),
        (24, 28, "codice_abi_originario_banca"),
        (29, 33, "causale"),
        (34, 49, "descrizione"),
        (50, 51, "tipo_conto"),
        (52, 52, "cin"),
        (53, 57, "codice_abi_banca"),
        (58, 62, "cab_banca"),
        (63, 74, "conto_corrente"),
        (75, 77, "codice_divisa"),
        (78, 83, "data_inizio_periodo"),
        (84, 84, "segno"),
        (85, 99, "saldo_iniziale"),
        (100, 101, "codice_paese"),
        (102, 103, "check_digit"),
        (104, 120, "filler3"),
    ],
    "62": [
        (1, 1, "filler1"),
        (2, 3, "tipo_record"),
        (4, 10, "numero_progressivo"),
        (11, 13, "progressivo_movimento"),
        (14, 19, "data_valuta"),
        (20, 25, "data_registrazione_eo_contabile"),
        (26, 26, "segno_movimento"),
        (27, 41, "importo_movimento"),
        (42, 43, "causale cbi"),
        (44, 45, "causale_interna"),
        (46, 61, "numero_assegno"),
        (62, 77, "riferimento_banca"),
        (78, 86, "tipo_riferimento_cliente"),
        (87, 120, "riferimento_cliente_descrizione_movimento"),
    ],
    "63_34Z1": [
        (1, 1, "filler1"),
        (2, 3, "tipo_record"),
        (4, 10, "numero_progressivo"),
        (11, 13, "progressivo_movimento"),
        (14, 16, "flag struttura"),
        (17, 39, "identificativo_rapporto"),
        (40, 120, "filler2"),
    ],
    "63_48": [
        (1, 1, "filler"),
        (2, 3, "tipo_record"),
        (4, 10, "numero_progressivo"),
        (11, 13, "progressivo_movimento"),
        (14, 16, "flag struttura"),
        (17, 24, "data_ordine"),
        (25, 40, "codifica_fiscale_ordinante"),
        (41, 120, "descrizione_ordinante"),
    ],
    "63_ZIZL_1": [
        (1, 1, "filler"),
        (2, 3, "tipo_record"),
        (4, 10, "numero progressivo"),
        (11, 13, "progressivo movimento"),
        (14, 16, "flag struttura"),
        (17, 34, "importo originario pagamento"),
        (35, 37, "codice divisa importo originario"),
        (38, 55, "importo regolato"),
        (56, 58, "codice divisa regolamento"),
        (59, 76, "importo negoziato"),
        (77, 79, "codice divisa importo negoziato"),
        (80, 91, "cambio applicato"),
        (92, 104, "importo commissioni"),
        (105, 117, "importo spese"),
        (118, 120, "filler2"),
    ],
    "63_ZIZL_2": [
        (1, 1, "filler"),
        (2, 3, "tipo_record"),
        (4, 10, "numero progressivo"),
        (11, 13, "progressivo movimento"),
        (14, 16, "flag struttura"),
        (17, 120, "ordinante del pagamento"),
    ],
    "63_ZIZL_3": [
        (1, 1, "filler"),
        (2, 3, "tipo_record"),
        (4, 10, "numero progressivo"),
        (11, 13, "progressivo movimento"),
        (14, 16, "flag struttura"),
        (17, 66, "beneficiario del pagamento"),
        (67, 120, "motivazione del pagamento"),
    ],
    "63_other": [
        (1, 1, "filler"),
        (2, 3, "tipo_record"),
        (4, 10, "numero progressivo"),
        (11, 13, "progressivo movimento"),
        (14, 120, "descrizione"),
    ],
    "63_other_ID1": [
        (1, 1, "filler"),
        (2, 3, "tipo_record"),
        (4, 10, "numero progressivo"),
        (11, 13, "progressivo movimento"),
        (14, 16, "flag struttura"),
        (17, 51, "identificativo univoco messaggio"),
        (52, 86, "identificativo end to end"),
        (87, 120, "filler"),
    ],
    "63_other_RI1": [
        (1, 1, "filler"),
        (2, 3, "tipo_record"),
        (4, 10, "numero progressivo"),
        (11, 13, "progressivo movimento"),
        (14, 16, "flag struttura"),
        (17, 120, "informazioni riconciliazione"),
    ],
    "63_other_RI2": [
        (1, 1, "filler"),
        (2, 3, "tipo_record"),
        (4, 10, "numero progressivo"),
        (11, 13, "progressivo movimento"),
        (14, 16, "flag struttura"),
        (17, 52, "informazioni riconciliazione"),
        (53, 120, "filler"),
    ],
    "64": [
        (1, 1, "filler1"),
        (2, 3, "tipo_record"),
        (4, 10, "numero_progressivo"),
        (11, 13, "codice_divisa"),
        (14, 19, "data fine periodo"),
        (20, 20, "segno_saldo_contabile"),
        (21, 35, "saldo_contabile"),
        (36, 105, "filler2"),
        (106, 120, "filler3"),
    ],
}

RA: Rule = {
    "RA": [
        (1, 1, "filler1"),
        (2, 3, "tipo_record"),
        (4, 8, "mittente"),
        (9, 13, "ricevente"),
        (14, 19, "data_creazione"),
        (20, 39, "nome_supporto"),
        (40, 115, "filler2"),
        (116, 120, "campo_non_disponibile"),
    ]
}

DT: Rule = {
    "DT": [
        (1, 1, "filler1"),
        (2, 3, "tipo_record"),
        (4, 8, "mittente"),
        (9, 13, "ricevente"),
        (14, 19, "data_creazione"),
        (20, 39, "nome_supporto"),
        (40, 45, "campo_a_disposizione"),
        (46, 115, "filler"),
        (116, 120, "campo_non_disponibile"),
    ]
}

RP: Rule = {
    "RP": [
        (1, 1, "filler"),
        (2, 3, "tipo_record"),
        (4, 8, "mittente"),
        (9, 13, "ricevente"),
        (14, 19, "data_creazione"),
        (20, 39, "nome_supporto"),
        (40, 115, "filler"),
        (116, 120, "campo_non_disponibile"),
    ]
}

EF = [
    (1, 1, "filler1"),
    (2, 3, "tipo_record"),
    (4, 8, "mittente"),
    (9, 13, "ricevente"),
    (14, 19, "data_creazione"),
    (20, 39, "nome_supporto"),
    (40, 45, "campo_a_disposizione"),
    (46, 52, "numero_disposizioni"),
    (53, 82, "filler2"),
    (83, 89, "numero_record"),
    (90, 114, "filler3"),
    (115, 120, "campo_non_disponibile"),
]


MAPPING: dict[str, Rule] = {
    "RH": RH,
    "EC": EC,
    "RA": RA,
    "DT": DT,
    "RP": RP,
}


def _record_rule_ec(row: str, last_record: str, last_message: dict[str, Any]) -> list[tuple[int, int, str]]:  # noqa
    tipo_record = row[1:3]
    if tipo_record == "61":
        if last_record == "EC":
            return EC["61"]
    if tipo_record == "62":
        if last_record in ("61", "62", "63"):
            return EC["62"]
    if tipo_record == "63":
        if last_record in ("62", "63"):
            if last_message["62"]["causale cbi"] in ("34", "Z1"):
                return EC["63_34Z1"]
            elif last_message["62"]["causale cbi"] == "48":
                if last_message["63"] == {}:
                    return EC["63_48"]
            elif last_message["62"]["causale cbi"] in ("ZI", "ZL"):
                if last_message["63"] == {}:
                    return EC["63_ZIZL_1"]
                if last_message["63"]["flag struttura"] == "ZZ1":
                    return EC["63_ZIZL_2"]
                if last_message["63"]["flag struttura"] == "ZZ2":
                    return EC["63_ZIZL_3"]
            else:
                return EC["63_other"]
    if tipo_record == "64":
        if last_record in ("62", "63"):
            return EC["64"]

    raise ValueError(f"message {row} follows no knows rule")


def _record_rule_rh(row: str, last_record: str, last_message: dict[str, Any]) -> list[tuple[int, int, str]]:  # noqa
    tipo_record = row[1:3]
    if tipo_record == "61":
        if last_record in ("RH", "64", "65"):
            return RH["61"]
    if tipo_record == "62":
        if last_record in ("61", "62", "63", "64"):
            return RH["62"]
    if tipo_record == "63":
        if last_record in ("62", "63"):
            if last_message["62"]["causale cbi"] in ("34", "Z1"):
                return RH["63_48_1"]
                # if last_message["63"]["flag struttura"] == " YYY":
                # return RH["63_48_2"]
            elif last_message["62"]["causale cbi"] in ("ZI", "ZL"):
                if "63" not in last_message:
                    return RH["63_ZIZL_1"]
                if "flag struttura" not in last_message:
                    return RH["63_ZIZL_1"]
                if last_message["63"]["flag struttura"] == "ZZ1":
                    return RH["63_ZIZL_2"]
                if last_message["63"]["flag struttura"] == "ZZ2":
                    return RH["63_ZIZL_3"]
            else:
                return RH["63_other"]
    if tipo_record == "64":
        if last_record in ("61", "63", "62"):
            return RH["64"]
    if tipo_record == "65":
        if last_record == "64":
            return RH["65"]

    raise ValueError(f"message {row} follows no knows rule")

def _record_rule(
    row: str,
    msg_type: str,
    last_record: str,
    last_message: dict[str, Any],
    rules_ovverride: dict[str, Callable[[str, str, dict[str, Any]], list[tuple[int, int, str]]]] = {},
) -> list[tuple[int, int, str]]:
    if msg_type in rules_ovverride:
        return rules_ovverride[msg_type](row, last_record, last_message)
    if msg_type == "RH":
        return _record_rule_rh(row, last_record, last_message)
    if msg_type == "EC":
        return _record_rule_ec(row, last_record, last_message)
    raise ValueError("unknown message")

class Msg(TypedDict):
    msg_type: str
    testa: Optional[DataRow]
    coda: Optional[DataRow]
    records: list[DataRow]

class CBIParser:
    def __init__(
        self,
        head: str,
        rules_override: dict[str, Callable[[str, str, dict[str, Any]], list[tuple[int, int, str]]]] = {},
    ) -> None:
        self.msg_type = head[1:3]
        self.msg_reference = head.strip()
        self.last_record = self.msg_type
        self.rule = MAPPING[self.msg_type]
        msg = {
            key: head[start_index - 1 : end_index].rstrip() for start_index, end_index, key in self.rule[self.msg_type]
        }
        self.last_message = {self.msg_type: msg.copy()}
        self.store: Msg = {"msg_type": self.msg_type, "testa": msg.copy(), "coda": dict(), "records": []}
        self.rules_ovverride: dict[
            str, Callable[[str, str, dict[str, Any]], list[tuple[int, int, str]]]
        ] = rules_override

    def parse(self, row: str) -> dict[str, Any]:
        record_rule = _record_rule(
            row, self.store["msg_type"], self.last_record, self.last_message, self.rules_ovverride
        )

        msg = {key: row[start_index - 1 : end_index].rstrip() for start_index, end_index, key in record_rule}

        self.last_record = msg["tipo_record"]
        self.last_message[msg["tipo_record"]] = msg.copy()

        return msg.copy()

    def add(self, row: str) -> bool:
        if row[1:3] == "EF":
            self.store["coda"] = {l[2]: row[l[0] - 1 : l[1]] for l in EF}  # noqa
            return True
        msg = self.parse(row)
        self.store["records"].append(msg)
        return False

    def msg(self) -> DataRow:
        return {"msg_type": self.msg_type, "msg_reference": self.msg_reference, "payload": json.dumps(self.store)}


class ReadCBI():
    def __init__(
        self,
        path_label: str = "path",
        rules_override: dict[str, Callable[[str, str, dict[str, Any]], list[tuple[int, int, str]]]] = {},
        **kwargs: Any,
    ) -> None:  # noqa
        self.path_label = path_label
        self.rules_override = rules_override
        super().__init__(**kwargs)

    def run(self, data: DataRow) -> TaskData:  # type: ignore
        output: list[DataRow] = []
        heads = set()
        parser = None
        with open(data[self.path_label]) as file:
            for row in file.readlines():
                if row in heads:
                    raise ValueError("Record di testa duplicato")

                if row[1:3] in ("RH", "EC", "RA", "DT", "RP") + tuple(self.rules_override.keys()):
                    parser = CBIParser(row, self.rules_override)
                    heads.add(row)
                else:
                    if parser is None:
                        raise ValueError("Record di testa mancante")
                    done = parser.add(row)
                    if done:
                        output.append(parser.msg())

        meta_dict = {k: v for k, v in data.items()}
        meta_dict["isEmpty"] = len(output) == 0

        return {
            "data": output,
            "errors": [],
            "meta": meta_dict,
        }
