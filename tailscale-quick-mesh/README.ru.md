# Быстрая Настройка Сети Tailscale Mesh и Подсетей

> Скрипт для установки Tailscale, включения IP Forwarding в ядре Linux и простой настройки защищенной внутренней сети.

[English](README.md) | [中文说明](README.zh-CN.md) | [Русский](README.ru.md) | [Deutsch](README.de.md) | [Español](README.es.md) | [Français](README.fr.md)

---

## Запуск

```bash
# Базовая установка
sudo bash mesh.sh

# Автоматическое подключение по Auth Key и анонс подсети
sudo bash mesh.sh --authkey "tskey-auth-xxx" --advertise-routes "192.168.1.0/24"
```

---

## Лицензия

MIT © [ITTinker](https://ittinker.com)
