from dataclasses import dataclass
from validation.coerce import Coerce

@dataclass(frozen=True)
class FieldRule:
    type_: type | Coerce  # tipo base contro cui validare i dati letti dal feed
    ingest_column: str | None = None  # nome della colonna di ingest se diversa da quello nel feed
    external: bool = False  # campo inferito e non presente esplicitamente nelle colonne del feed


SheetRules = dict[str, dict[str, FieldRule]]
RuleDict = dict[str, SheetRules]
"""
rule = {
    r"feed_file_regex": {
        "sheet_name": {  # "-" if csv
            "field_name": FieldRule(type_, ingest_column),
            ...
        },
        ...
    },
    ...
}
"""
