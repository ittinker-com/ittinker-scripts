# Production Docker & Docker Compose Schnellentwickler

> 1-Klick-Skript zur Installation von Docker CE und Docker Compose V2 mit Best Practices für den Produktivbetrieb (Log-Rotation, Live-Restore und Benutzerrechte).

[English](README.md) | [中文说明](README.zh-CN.md) | [Русский](README.ru.md) | [Deutsch](README.de.md) | [Español](README.es.md) | [Français](README.fr.md)

---

## Enthaltene Best Practices

- **Log-Begrenzung**: Automatische Konfiguration von `max-size: 50m` und `max-file: 3` in `/etc/docker/daemon.json` verhindert volllaufende Festplatten.
- **Live Restore**: Hält laufende Container während Daemon-Updates aktiv (`live-restore: true`).
- **Rechte-Verwaltung**: Fügt den aktuellen Benutzer zur `docker`-Gruppe hinzu.

## Schnellstart

```bash
sudo bash deploy.sh
```

---

## Lizenz

MIT © [ITTinker](https://ittinker.com)
