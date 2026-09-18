# ITTinker Scripts y Herramientas de Automatización

> Scripts de automatización públicos, flujos de trabajo DevOps y herramientas del sistema para la plataforma ITTinker.

[English](README.md) | [简体中文](README.zh-CN.md) | [繁體中文](README.zh-TW.md) | [日本語](README.ja.md) | [Русский](README.ru.md) | [Deutsch](README.de.md) | [Español](README.es.md) | [Français](README.fr.md)

---

## Índice de Herramientas

| Directorio | Nombre | Descripción |
| :--- | :--- | :--- |
| [`newapi-sync-channel-models/`](./newapi-sync-channel-models/) | **New API Channel Models Sync** | Sincronización automática de modelos de canales con cálculo de diferencias y copias de seguridad. |
| [`vps-init/`](./vps-init/) | **Inicialización de VPS en 1 Clic** | Configuración completa de VPS desde cero: actualización, nuevo usuario, seguridad SSH, firewall, BBR, fail2ban. |
| [`vps-bench/`](./vps-bench/) | **Kit de Benchmarks para VPS** | Menú interactivo con más de 15 pruebas: rendimiento, trazado de rutas, calidad de IP, streaming y velocidad. |
| [`ssh-key-setup/`](./ssh-key-setup/) | **Asistente de Claves SSH** | Configuración guiada de claves Ed25519: generación, subida al servidor, gestión de SSH Config y SSH Agent. |
| [`cloudflare-ufw/`](./cloudflare-ufw/) | **Firewall UFW para Cloudflare** | Configuración de UFW para permitir solo IPs oficiales de Cloudflare en puertos 80/443 con actualización semanal. |
| [`cloudflare-domain-baseline/`](./cloudflare-domain-baseline/) | **Configuración Base para Cloudflare** | Configuración recomendada para dominios: Full Strict SSL, HSTS, redirección 301 de www, Cache Rules y antibot. |
| [`vps-gfw-diagnose/`](./vps-gfw-diagnose/) | **Diagnóstico de Conectividad VPS** | Diagnóstico multirregional para identificar caídas del servidor, puertos cerrados o bloqueos de IP por censura (GFW). |
| [`docker-quick-deploy/`](./docker-quick-deploy/) | **Instalador de Docker para Producción** | Instalador de Docker CE y Compose V2 con rotación de logs (evita llenar el disco), live-restore y permisos no-root. |
| [`vps-health-monitor/`](./vps-health-monitor/) | **Monitor Ligero de Salud del VPS** | Monitor ligero por cron con alertas por Webhook (Telegram, Discord, Feishu) si se superan límites de CPU/RAM/Disco. |
| [`cloudflare-tunnel-setup/`](./cloudflare-tunnel-setup/) | **Configuración de Cloudflare Tunnel** | Despliegue rápido del servicio cloudflared systemd sin necesidad de abrir puertos públicos entrantes. |
| [`tailscale-quick-mesh/`](./tailscale-quick-mesh/) | **Red Mesh Rápida con Tailscale** | Red privada WireGuard cifrada entre múltiples servidores con soporte para reenvío de IP y Subnet Router. |
| [`supabase-usage-guard/`](./supabase-usage-guard/) | **Supabase Health & Egress Guard** | 360° health diagnostic suite: audits slow queries, missing indexes, table bloat, and top egress consumer SQL. |

---

## Guías del Repositorio

- Cada herramienta está organizada en su propio directorio dedicado en formato kebab-case.
- Cada directorio incluye scripts ejecutables y documentación multilingüe.

