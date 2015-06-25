# Setup serwera:

https://gist.github.com/ChuckJHardy/f44dda5f94c6bbdba9a4

apt-get install memcached
apt-get install nodejs

Postgresql potrzebuje extension PostGis: http://www.saintsjd.com/2014/08/13/howto-install-postgis-on-ubuntu-trusty.html

# Dokumentacja API

API przeswietl.pl: http://api.przeswietl.pl/doc/classes/Api_Client_Full.html

# Import danych

UWAGA: Proszę nie odpalać dodatkowych importerów z MojepanstwoPL
MojepanstwoPL ma tylko utworzyc osoby Entity z person = true.
Relacje powinny być zaciągane tylko z przeswietla.pl (by uniknać duplikatów)

Utworz wewnętrzen dane importera: MojepanstwoPlDeputy, MojepanstwoPLPerson, MojepanstwoPlKrsPerson:

    rake mp:deputies:import

Utworz Entities (persons) z Mojepanstwo**:

    rake mp:people:setup

Utworz Entities (persons) z vendor/100richest.txt:

    rake mp:krs_people:import_if_connected

Zaimportruj pesele dla istniejących Entities:

    rake przeswietl:import_missing_pesels

Zaimportruj relacje dla istniejących Entities:

    rake przeswietl:import_current_relations
    rake przeswietl:import_historic_relations
