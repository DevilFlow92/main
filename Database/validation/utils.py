from datetime import date
from typing import Callable, Optional, Union

from Levenshtein import distance
from schema import SchemaError


def split_fullname(fullname: str, cod_fiscale: str) -> tuple[str, str]:
    nome_cf = cod_fiscale[3:6].lower()
    name: list[str] = []
    surname: list[str] = []

    for token in reversed([token.lower() for token in fullname.split()]):
        if not all((c in "".join(name) for c in nome_cf)):
            name.append(token)
        else:
            surname.append(token)

    return " ".join([o.title() for o in reversed(name)]), " ".join([o.title() for o in reversed(surname)])


def is_similar(term_compare: str, dist: int) -> Callable[[str, int], str]:
    def _validate(term: str) -> Optional[str]:
        if distance(term.strip().lower(), term_compare.strip().lower()) <= dist:
            return term
        raise SchemaError(f"Distance between {term} and {term_compare} is more than {dist}")

    return _validate  # type: ignore


def cf_extract(cf: str) -> dict[str, Union[str, date]]:
    """Estrae sesso e data di nascita da un codice fiscale in un dizionario."""
    # Calcolo data di nascita:
    # - le ultime due cifre dell'anno di nascita (da 00 a 99)
    # - una lettera per il mese (A = Gennaio, B, C, D, E, H, L, M, P, R, S, T = Dicembre)
    # - il giorno di nascita: in caso di sesso femminile si aggiunge 40 per cui se si trova scritto,
    #    ad esempio, 62, non può che trattarsi di una donna nata il 22 del mese.

    # Calcolo sesso:
    # - se il valore presenti nel decimo e undicesimo carattere è compreso da 01 a 31 (Maschio) o da 41 a 71 (Femmina).
    s = "M" if int(cf[9:11]) <= 31 else "F"
    y = 1900 + int(cf[6:8]) if int(cf[6:8]) <= date.today().year else 2000 + int(cf[6:8])
    m = ord(cf[8].upper()) - ord("A") + 1
    d = int(cf[9:11]) if s == "M" else int(cf[9:11]) - 40
    return {"data_nascita": date(y, m, d), "sesso": s}
