---
name: kodovani-bodu-tahu
description: Souřadnice se zaokrouhlují na 4 desetinná místa už při záznamu, body se ukládají jako ploché pole [x,y,t,…]; zaokrouhlení je 2,8× úspora, ploché pole jen 1,1× na drátě
type: decision
status: active
created: 2026-08-18
updated: 2026-08-18
related: [supabase-free-plan-a-region]
---

# Kódování bodů tahu

Majitel 2026-08-18: „kódování bodů neumím posoudit" → rozhodnuto za něj, na základě
měření, ne odhadu.

## Měření (realistická kresba, 25 tahů × 60 bodů = 1 500 bodů)

| Varianta | JSON | gzip | brotli |
|---|---|---|---|
| A — objekty, plná přesnost *(co dělal kód)* | 85,1 kB | 31,0 kB | 23,8 kB |
| B — objekty, zaokrouhleno na 4 des. místa | 48,7 kB | 11,2 kB | 6,6 kB |
| C — ploché pole, zaokrouhleno | 28,2 kB | 10,0 kB | 6,3 kB |

## Oprava dřívějšího tvrzení

Dřív jsem uvedl, že ploché pole je „zhruba 3× menší". **To platí jen pro nekomprimovaný
JSON a je to zavádějící.** Po gzipu je ploché pole proti objektům lepší jen o ~11 %,
protože gzip opakované klíče `x`/`y`/`t` odstraní sám.

**Skutečná úspora je jinde: v zaokrouhlení.** Kód počítal `(e.clientX - rect.left) /
rect.width` a ukládal plnou plovoucí přesnost, tedy hodnoty jako `0.4327485380116959` —
18 znaků na souřadnici. Samotné zaokrouhlení dá **2,76×** na drátě, ploché pole už jen
1,13× navíc.

## Rozhodnutí

1. **Zaokrouhlovat na 4 desetinná místa už při záznamu bodu.** Souřadnice jsou
   normalizované 0–1, takže 1/10 000 plátna je i na 4K displeji ~0,2 px — pod pixel.
   Vyšší přesnost nenese žádnou informaci, jen bajty. *Implementováno 2026-08-18.*
2. **Ukládat ploché pole `[x,y,t,x,y,t,…]`.** Na drátě je to drobnost, ale
   **na disku ne**: jeden tah (~60 bodů) je jako objekty ~2 kB, což je přesně kolem
   prahu, od kterého Postgres teprve začne TOAST komprimovat. Řádky pod prahem se
   neukládají komprimovaně vůbec, takže tam se počítá syrová velikost — a ta je
   u plochého pole 1,7× menší. Zavést s krokem C2, spolu s encode/decode helperem
   v `lib/strokes.ts`, ať konvence nežije jen v hlavě.

## Co tím NEbylo vyřešeno

**Pro fázi 0 by stačila i varianta A.** Padesát lidí × 20 hádání denně × 30 dnů je
~30 000 stažení kresby, zatímco 5 GB egress unese i v nejhorší variantě ~169 000.
Důvod rozhodnout to teď není kapacita, ale to, že **změna zpětně znamená migraci dat**
a zaokrouhlení musí proběhnout při záznamu, kde se ztracená přesnost nedá dohnat.
