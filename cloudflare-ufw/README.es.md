# Configuración del Firewall UFW para Cloudflare

> Configura automáticamente UFW para permitir el tráfico HTTP/HTTPS únicamente desde las IPs oficiales de Cloudflare.

[English](README.md) | [中文说明](README.zh-CN.md) | [Русский](README.ru.md) | [Deutsch](README.de.md) | [Español](README.es.md) | [Français](README.fr.md)

---

## Uso

```bash
# Modo prueba
sudo bash setup.sh

# Aplicar e instalar tarea programada (cron)
sudo bash setup.sh --apply --install-cron
```

---

## Licencia

MIT © [ITTinker](https://ittinker.com)
