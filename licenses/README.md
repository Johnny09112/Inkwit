# Licence písem

Inkwit **self-hostuje** všechna svá písma. `next/font/google` je stáhne při buildu
a Next.js je servíruje z vlastní domény (`/_next/static/media/*.woff2`) — za běhu
nejde ani jeden request na Google. To má dva důsledky, oba záměrné:

1. **GDPR.** Návštěvníkova IP adresa se nikdy nedostane k třetí straně. Servírování
   Google Fonts z Google CDN je právě to, co v Německu skončilo u soudu
   (LG München I, 20.01.2022, sp. zn. 3 O 17493/20 — přiznaná náhrada za předání
   IP adresy bez souhlasu). Tenhle vektor u nás neexistuje.
2. **Redistribuce.** Servírovat font z vlastní domény znamená ho šířit. OFL to
   výslovně dovoluje, ale žádá, aby licence a copyright šly s písmem — proto tahle
   složka.

*Ověřeno 2026-08-18 v prohlížeči: všechny síťové requesty produkčního buildu míří
na vlastní origin, žádný na `fonts.googleapis.com` ani `fonts.gstatic.com`.*

## Použitá písma

| Písmo | Role | Copyright | Licence |
|---|---|---|---|
| **Bricolage Grotesque** | nadpisy | Copyright 2022 The Bricolage Grotesque Project Authors ([repo](https://github.com/ateliertriay/bricolage)) | [SIL OFL 1.1](Bricolage-Grotesque-OFL.txt) |
| **IBM Plex Sans** | běžný text | Copyright © 2017 IBM Corp. | [SIL OFL 1.1](IBM-Plex-OFL.txt) |
| **IBM Plex Mono** | štítky a metadata | Copyright © 2017 IBM Corp. | [SIL OFL 1.1](IBM-Plex-OFL.txt) |

Načítané řezy a subsety jsou v `app/[locale]/layout.tsx`. Všechny tři rodiny se
načítají se subsety `latin` + `latin-ext`, protože bez `latin-ext` by chyběla
česká diakritika (ě š č ř ž ů ď ť ň).

## Co z OFL plyne pro nás

- **Písma smíme používat, upravovat i šířit**, komerčně i nekomerčně, včetně
  vložení do aplikace. Žádný poplatek, žádná registrace.
- **Nesmí se prodávat samostatně.** Prodávat produkt, který je obsahuje, se smí.
- **Licence a copyright musí jít s písmem** při redistribuci — proto jsou tyhle
  soubory v repu. Když se v budoucnu přidá další písmo, přidá se i sem.
- **IBM Plex má vyhrazený název „Plex".** Kdybychom písmo upravili, **upravená
  verze se nesmí jmenovat Plex**. Momentálně nic neupravujeme, takže se to netýká —
  ale netýká se to jen do chvíle, než někdo sáhne po subsetting nástroji.
- Bricolage Grotesque vyhrazený název nemá.

## Kdy tohle znovu otevřít

- **Přidání dalšího písma.** Do systému nesmí vstoupit písmo, které nepokrývá
  Latin Extended (pravidlo dvojjazyčnosti) nebo nemá licenci umožňující self-host.
- **Vlastní subsetting.** Kdyby se řezy ořezávaly ručně kvůli velikosti, vzniká
  „modified version" a nastupuje pravidlo vyhrazeného názvu u Plexu.
- **Přechod na `next/font/local`.** Legálně stejné, technicky ruční správa woff2.
  Není důvod, dokud `next/font/google` dělá totéž automaticky.
