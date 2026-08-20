"use client";

import { Lock } from "lucide-react";
import { useTranslations } from "next-intl";
import { Link } from "@/i18n/navigation";
import { Button } from "@/components/ui";

/**
 * Vysvětlení zamčené funkce.
 *
 * Do 2026-08-20 bylo zamčené tlačítko jen `disabled` se zámečkem — nedalo se
 * na něj klepnout a nikde nestálo, co ho odemkne. Zámek bez vysvětlení je
 * horší než skrytá funkce: vidíš ji, nemůžeš ji použít a nevíš proč.
 *
 * Odkaz míří do profilu, kde je vidět postup. Cílem není prodat level, ale
 * říct, kde se dá zjistit, jak daleko člověk je.
 */

interface LockedDialogProps {
  /** Název funkce, která je zamčená (už přeložený). */
  feature: string;
  level: number;
  onClose: () => void;
}

export function LockedDialog({ feature, level, onClose }: LockedDialogProps) {
  const t = useTranslations("locked");

  return (
    <div className="modal-backdrop" onClick={onClose}>
      <div
        className="modal locked-modal"
        role="dialog"
        aria-modal="true"
        aria-label={`${t("title")} — ${feature}`}
        onClick={(e) => e.stopPropagation()}
      >
        <span className="locked-badge" aria-hidden="true">
          <Lock size={26} />
        </span>
        {/* Název funkce stojí na vlastním řádku schválně. Ve větě „{feature}
            je zamčené" by se musel shodovat v rodě a čísle — „Tvary je zatím
            zamčené" je špatně česky a šablona to neuhlídá. */}
        <h2 className="locked-title">{t("title")}</h2>
        <p className="locked-feature">{feature}</p>
        <p className="locked-lede">{t("lede", { level })}</p>
        <p className="t-secondary">{t("how")}</p>
        <div className="locked-actions">
          <Link href="/profile" className="btn btn-secondary" onClick={onClose}>
            {t("progress")}
          </Link>
          <Button onClick={onClose}>{t("ok")}</Button>
        </div>
      </div>
    </div>
  );
}
