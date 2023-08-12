class BusinessValueError(ValueError):
    """Rappresenta una condizione dei dati di sistema che impedisce la gestione del messaggio in esame.

    Ad esempio un messaggio che rappresenta un acquisto di titolo, va in BusinessValueError
    se il messaggio è valido ma il titolo non è censito a qtask.
    """

    pass
