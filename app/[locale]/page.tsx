import { redirect } from "@/i18n/navigation";

export default async function Home({
  params,
}: {
  params: Promise<{ locale: string }>;
}) {
  const { locale } = await params;
  // Vstupní obrazovka je feed hádání — hádat lze neomezeně a zdarma
  redirect({ href: "/guess", locale });
}
