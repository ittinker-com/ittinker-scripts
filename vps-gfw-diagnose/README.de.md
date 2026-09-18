# VPS-Konnektivitäts- & GFW-Sperrungs-Diagnosetool

> Multiregionales Diagnosetool für Entwickler zur schnellen Erkennung von Serverausfällen, geschlossenen Ports oder staatlicher IP-Zensur (GFW).

[English](README.md) | [简体中文](README.zh-CN.md) | [繁體中文](README.zh-TW.md) | [日本語](README.ja.md) | [Русский](README.ru.md) | [Deutsch](README.de.md) | [Español](README.es.md) | [Français](README.fr.md)

---

## Warum dieses Tool?

Wenn ein VPS unerwartet nicht mehr erreichbar ist, stellt sich oft die Frage nach der Ursache: Serverabsturz, Firewall-Fehlkonfiguration oder IP-Sperre durch die chinesische Firewall (GFW)?

`diagnose.sh` führt lokale Ping/TCP-Tests durch und gleicht sie mit weltweiten Messpunkten (China, USA, Deutschland, Japan) ab, um eine fundierte Fehleranalyse zu liefern.

---

## Verwendung

```bash
# 1. Standardtest (SSH-Port 22)
bash diagnose.sh 1.2.3.4

# 2. Bestimmten Port testen (z. B. HTTPS 443)
bash diagnose.sh myvps.example.com -p 443
```

---

## Lizenz

MIT © [ITTinker](https://ittinker.com)
