# Herramienta de Diagnóstico de Conectividad VPS y Bloqueos GFW

> Herramienta multirregional de diagnóstico para desarrolladores que permite diferenciar al instante caídas del servidor, bloqueos de firewall o bloqueos de IP por censura (GFW).

[English](README.md) | [中文说明](README.zh-CN.md) | [Русский](README.ru.md) | [Deutsch](README.de.md) | [Español](README.es.md) | [Français](README.fr.md)

---

## Uso

```bash
# 1. Probar por IP (Puerto por defecto: 22)
bash diagnose.sh 1.2.3.4

# 2. Probar puerto específico (ej. HTTPS 443)
bash diagnose.sh myvps.example.com -p 443
```

---

## Licencia

MIT © [ITTinker](https://ittinker.com)
