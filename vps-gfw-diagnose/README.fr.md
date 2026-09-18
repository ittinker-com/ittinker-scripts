# Outil de Diagnostic de Connectivité VPS et de Blocage GFW

> Outil de diagnostic multirégional permettant d'identifier immédiatement si un VPS est en panne, bloqué par un pare-feu ou ciblé par la censure réseau (GFW).

[English](README.md) | [中文说明](README.zh-CN.md) | [Русский](README.ru.md) | [Deutsch](README.de.md) | [Español](README.es.md) | [Français](README.fr.md)

---

## Utilisation

```bash
# 1. Tester une IP (Port par défaut : 22)
bash diagnose.sh 1.2.3.4

# 2. Tester un port spécifique (ex. HTTPS 443)
bash diagnose.sh myvps.example.com -p 443
```

---

## Licence

MIT © [ITTinker](https://ittinker.com)
