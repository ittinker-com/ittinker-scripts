# ITTinker Скрипты и Инструменты Автоматизации

> Открытые скрипты автоматизации, рабочие процессы DevOps и системные утилиты для платформы ITTinker.

[English](README.md) | [简体中文](README.zh-CN.md) | [繁體中文](README.zh-TW.md) | [日本語](README.ja.md) | [Русский](README.ru.md) | [Deutsch](README.de.md) | [Español](README.es.md) | [Français](README.fr.md)

---

## Каталог Инструментов

| Директория | Название | Описание |
| :--- | :--- | :--- |
| [`newapi-sync-channel-models/`](./newapi-sync-channel-models/) | **New API Channel Models Sync** | Автоматическая синхронизация моделей каналов с анализом различий и резервным копированием. |
| [`vps-init/`](./vps-init/) | **VPS Инициализация в 1 клик** | Комплексная настройка чистого VPS: обновление, создание пользователя, безопасность SSH, UFW, BBR, fail2ban. |
| [`vps-bench/`](./vps-bench/) | **VPS Тестирование и Бенчмарки** | Интерактивное меню из 15+ скриптов: бенчмаркинг, трассировка маршрутов, проверка IP, разблокировка медиа, скорость сети. |
| [`ssh-key-setup/`](./ssh-key-setup/) | **Мастер Настройки SSH-ключей** | Пошаговая настройка ключей Ed25519: генерация, экспорт на сервер, конфигурация SSH Config и SSH Agent. |
| [`cloudflare-ufw/`](./cloudflare-ufw/) | **Cloudflare UFW Файрвол** | Настройка UFW для разрешения доступа к портам 80/443 только через официальные IP Cloudflare (с поддержкой Cron). |
| [`cloudflare-domain-baseline/`](./cloudflare-domain-baseline/) | **Базовая Оптимизация Cloudflare** | Применение лучших практик для домена: Full Strict SSL, HSTS, 301-редирект с www, Cache Rules, защита от ботов. |
| [`vps-gfw-diagnose/`](./vps-gfw-diagnose/) | **Диагностика Доступности VPS** | Многорегиональная диагностика для определения падения сервера, блокировки портов или блокировки IP цензурой (GFW). |
| [`docker-quick-deploy/`](./docker-quick-deploy/) | **Установка Docker для Production** | Установка Docker CE и Compose V2 с лучшими практиками: ротация логов (защита диска), live-restore и права без sudo. |
| [`vps-health-monitor/`](./vps-health-monitor/) | **Легковесный Мониторинг VPS** | Мониторинг без зависимостей по Cron с уведомлениями в Telegram, Discord или Feishu при превышении нагрузки CPU/RAM/диска. |
| [`cloudflare-tunnel-setup/`](./cloudflare-tunnel-setup/) | **Установка Cloudflare Tunnel** | Быстрое развертывание службы cloudflared systemd для безопасного доступа без открытия публичных портов. |
| [`tailscale-quick-mesh/`](./tailscale-quick-mesh/) | **Быстрая Настройка Tailscale Mesh** | Мгновенное объединение нескольких VPS в защищенную сеть WireGuard с поддержкой Subnet Router и Exit Node. |
| [`supabase-usage-guard/`](./supabase-usage-guard/) | **Supabase Health & Egress Guard** | 360° health diagnostic suite: audits slow queries, missing indexes, table bloat, and top egress consumer SQL. |

---

## Стандарты Репозитория

- Все автономные инструменты организованы в отдельных каталогах (формат kebab-case).
- Каждый инструмент содержит скрипты автоматизации и мультиязычную документацию.

