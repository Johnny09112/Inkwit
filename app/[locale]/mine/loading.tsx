import { ScreenSkeleton } from "@/components/shell/ScreenSkeleton";

/**
 * Hranice načítání. Bez ní App Router drží starou obrazovku, dokud nemá
 * payload té nové — přepnutí záložky pak 0,5 až 2 vteřiny nedělá nic.
 * Viz `components/shell/ScreenSkeleton.tsx`.
 */
export default function Loading() {
  return <ScreenSkeleton ns="mine" rows={6} />;
}
