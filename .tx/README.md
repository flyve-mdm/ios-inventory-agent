# Transifex configuration

This is a required file to work with transfix:

```
[main]
host = https://www.transifex.com
minimum_perc = 80
```

````
[flyve-mdm-ios-inventory-agent.localizableplist-ios]
file_filter = flyve-mdm-ios/<lang>.lproj/Localizable.plist
lang_map = en_GB: Base, pt_BR: pt-BR, es_MX: es-MX, es_ES: es, fr_FR: fr, ru_RU: ru, ko_KR: ko
source_file = flyve-mdm-ios/Base.lproj/Localizable.strings
source_lang = en
type = PLIST
```
