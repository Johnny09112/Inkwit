import type {
  ButtonHTMLAttributes,
  HTMLAttributes,
  InputHTMLAttributes,
  ReactNode,
} from "react";

/* Tenké obálky nad třídami z globals.css — API kopíruje components/core
   z design projektu (Button, Card, Badge, Input). */

type ButtonVariant = "primary" | "secondary" | "ghost" | "danger";
type ButtonSize = "sm" | "md" | "lg";

interface ButtonProps extends ButtonHTMLAttributes<HTMLButtonElement> {
  variant?: ButtonVariant;
  size?: ButtonSize;
}

export function Button({
  variant = "primary",
  size = "md",
  className,
  children,
  ...rest
}: ButtonProps) {
  const sizeClass = size === "md" ? "" : ` btn-${size}`;
  return (
    <button
      className={`btn btn-${variant}${sizeClass}${className ? ` ${className}` : ""}`}
      {...rest}
    >
      {children}
    </button>
  );
}

interface CardProps extends HTMLAttributes<HTMLDivElement> {
  elevated?: boolean;
  children: ReactNode;
}

export function Card({ elevated = true, className, children, ...rest }: CardProps) {
  return (
    <div
      className={`card${elevated ? "" : " card-flat"}${className ? ` ${className}` : ""}`}
      {...rest}
    >
      {children}
    </div>
  );
}

type BadgeTone = "accent" | "neutral" | "success" | "danger" | "bronze" | "silver" | "gold";

/**
 * Obtížnost jako kov: snadné bronz, střední stříbro, těžké zlato.
 * Do 2026-08-20 měly všechny tři stejný medový štítek, takže obtížnost šlo
 * poznat jen přečtením.
 */
export function difficultyTone(difficulty: number): BadgeTone {
  if (difficulty >= 3) return "gold";
  if (difficulty === 2) return "silver";
  return "bronze";
}

interface BadgeProps extends HTMLAttributes<HTMLSpanElement> {
  tone?: BadgeTone;
  children: ReactNode;
}

export function Badge({ tone = "accent", className, children, ...rest }: BadgeProps) {
  return (
    <span
      className={`badge badge-${tone}${className ? ` ${className}` : ""}`}
      {...rest}
    >
      {children}
    </span>
  );
}

interface InputProps extends InputHTMLAttributes<HTMLInputElement> {
  invalid?: boolean;
}

export function Input({ invalid, className, ...rest }: InputProps) {
  return (
    <input
      className={`input${invalid ? " input-invalid" : ""}${className ? ` ${className}` : ""}`}
      {...rest}
    />
  );
}
