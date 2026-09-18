# Configuración Base Recomendada para Dominios en Cloudflare

> Script automatizado para aplicar las mejores prácticas de producción a cualquier dominio en Cloudflare: Full Strict SSL, HSTS, redirección 301 de www, Cache Rules y protección antibot.

[English](README.md) | [中文说明](README.zh-CN.md) | [Русский](README.ru.md) | [Deutsch](README.de.md) | [Español](README.es.md) | [Français](README.fr.md)

---

## Uso

```bash
# Modo prueba (Dry Run)
bash setup-zone.sh -d example.com -t "API_TOKEN"

# Aplicar cambios
bash setup-zone.sh -d example.com -t "API_TOKEN" --apply
```

---

## Licencia

MIT © [ITTinker](https://ittinker.com)
