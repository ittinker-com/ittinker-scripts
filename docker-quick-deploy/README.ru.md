# Быстрый Установщик Docker & Docker Compose для Production

> Скрипт для установки Docker CE и Docker Compose V2 в 1 клик с лучшими практиками для production (ротация логов, live-restore и настройка прав).

[English](README.md) | [简体中文](README.zh-CN.md) | [繁體中文](README.zh-TW.md) | [日本語](README.ja.md) | [Русский](README.ru.md) | [Deutsch](README.de.md) | [Español](README.es.md) | [Français](README.fr.md)

---

## Преимущества Скрипта

1. **Защита от переполнения диска**: Автоматически настраивает ротацию логов контейнеров (`max-size: 50m`, `max-file: 3`) в `/etc/docker/daemon.json`.
2. **Перезапуск демона без падения контейнеров**: Включает параметр `"live-restore": true`.
3. **Безопасные права**: Автоматически добавляет текущего непривилегированного пользователя в группу `docker`.

## Запуск

```bash
sudo bash deploy.sh
```

---

## Лицензия

MIT © [ITTinker](https://ittinker.com)
