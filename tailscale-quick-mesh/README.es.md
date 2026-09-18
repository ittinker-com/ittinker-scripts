# Configuración Rápida de Red Mesh y Subred con Tailscale

> Script para instalar Tailscale, habilitar el reenvío de IP del kernel de Linux y configurar redes privadas seguras y rutas de subred.

[English](README.md) | [中文说明](README.zh-CN.md) | [Русский](README.ru.md) | [Deutsch](README.de.md) | [Español](README.es.md) | [Français](README.fr.md)

---

## Uso

```bash
# Instalación normal
sudo bash mesh.sh

# Desatendida con Auth Key y subred
sudo bash mesh.sh --authkey "tskey-auth-xxx" --advertise-routes "192.168.1.0/24"
```

---

## Licencia

MIT © [ITTinker](https://ittinker.com)
