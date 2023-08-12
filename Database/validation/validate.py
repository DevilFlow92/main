import re

from schema import SchemaError


def is_iban(data: str) -> bool:
    IBAN_REGEX = r"[a-zA-Z]{2}[0-9]{2}[a-zA-Z0-9]{4}[0-9]{7}([a-zA-Z0-9]?){0,16}"
    if re.match(IBAN_REGEX, data, re.I):
        return True
    raise SchemaError("Invalid IBAN pattern")


def luhn_check(a: str) -> int:
    s = "".join(str(int(c, 36)) for c in a)
    return (sum(sum(divmod(2 * (ord(c) - 48), 10)) for c in s[-2::-2]) + sum(ord(c) - 48 for c in s[::-2])) % 10


def is_isin(data: str) -> bool:
    data_ = data.upper()
    ISIN_REGEX = r"^(?P<country_code>[A-Z]{2})(?P<security_identifier>\w{9})(?P<check_digit>\d{1})$"
    if re.match(ISIN_REGEX, data_, re.I):
        luhn_val = luhn_check(data_)
        if luhn_val == 0:
            return True
        raise SchemaError("Failed ISIN luhn check")
    raise SchemaError("Invalid ISIN pattern")


def is_email(data: str) -> bool:
    EMAIL_REGEX = r"^(\w|\.|\_|\-)+[@](\w|\_|\-|\.)+[.]\w{2,6}$"
    if re.match(EMAIL_REGEX, data, re.I):
        return True
    raise SchemaError("Invalid email pattern")


def is_partita_iva(data: str) -> bool:
    PI_REGEX = r"^[0-9]{11}$"
    if re.match(PI_REGEX, data, re.I):
        return True
    raise SchemaError("Invalid italian VAT pattern")


def is_sesso(data: str) -> bool:
    SEX_REGEX = r"^(m|f){1}$"
    if re.match(SEX_REGEX, data, re.I):
        return True
    raise SchemaError("Invalid sex pattern")


def is_provincia(data: str) -> bool:
    PROVINCIA_REGEX = r"^[A-Z]{2}$"
    if re.match(PROVINCIA_REGEX, data):
        return True
    raise SchemaError("Invalid italian province code pattern")


def is_cap(data: str) -> bool:
    CAP_REGEX = r"^[0-9]{5}$"
    if re.match(CAP_REGEX, data, re.I):
        return True
    raise SchemaError("Invalid italian municipality code CAP pattern")


def is_citta_ita(data: str) -> bool:
    CITTA_ITA_REGEX = r"^([a-zàèéìòù']{2,20})([\s-][a-zàèéòùì']{2,20}){0,5}$"
    if re.match(CITTA_ITA_REGEX, data, re.I):
        return True
    raise SchemaError("Invalid italian city pattern")


def is_civico(data: str) -> bool:
    CIVICO_REGEX = r"^[0-9].*[^\s]$"
    if re.match(CIVICO_REGEX, data, re.I):
        return True
    raise SchemaError("Invalid house number pattern")


def is_codice_fiscale(data: str) -> bool:
    CF_REGEX = r"^(?:[A-Z][AEIOU][AEIOUX]|[B-DF-HJ-NP-TV-Z]{2}[A-Z]){2}"
    CF_REGEX += r"(?:[\dLMNP-V]{2}(?:[A-EHLMPR-T](?:[04LQ][1-9MNP-V]|[15MR][\dLMNP-V]|[26NS][0-8LMNP-U])"
    CF_REGEX += r"|[DHPS][37PT][0L]|[ACELMRT][37PT][01LM]|[AC-EHLMPR-T][26NS][9V])"
    CF_REGEX += r"|(?:[02468LNQSU][048LQU]|[13579MPRTV][26NS])B[26NS][9V])"
    CF_REGEX += r"(?:[A-MZ][1-9MNP-V][\dLMNP-V]{2}|[A-M][0L](?:[1-9MNP-V][\dLMNP-V]|[0L][1-9MNP-V]))[A-Z]$"
    if re.match(CF_REGEX, data, re.I):
        return True
    raise SchemaError("Invalid italian fiscal code pattern")
