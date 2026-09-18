# Supabase Database Health, Performance & Egress Guard

> Comprehensive diagnostic suite for Supabase and PostgreSQL to audit high-egress queries, slow SQL, missing indexes, table bloat, and unused indexes.

[English](README.md) | [简体中文](README.zh-CN.md) | [繁體中文](README.zh-TW.md) | [日本語](README.ja.md) | [Русский](README.ru.md) | [Deutsch](README.de.md) | [Español](README.es.md) | [Français](README.fr.md)

---

## Why This Tool?

Supabase Free Plan provides 5GB of monthly Egress. When a project experiences abnormal bandwidth spikes (e.g. `Shared Pooler Egress`), it is almost always caused by:
1. **Uncached frequent reads**: Repetitive queries pulling hundreds of configuration rows on every API request.
2. **Missing indexes**: Forcing full table scans (`Seq Scan`) across tens of thousands of rows.
3. **Unbounded bulk transfers**: Fetching full table payloads without `LIMIT`.

This toolkit provides an instant, zero-setup 360° health audit.

---

## What It Detects

1. **Top Egress & High-Volume Queries**: Identifies SQL statements returning the largest cumulative row counts.
2. **Slow Queries**: Pinpoints operations consuming the most total execution time.
3. **Missing Indexes (Table Scans)**: Ranks tables with high sequential scans and low index hit rates.
4. **Unused / Redundant Indexes**: Finds indexes occupying storage without ever being scanned.
5. **Storage Footprint**: Analyzes total table size, raw data size, and index overhead.
6. **Dead Tuples & Bloat**: Identifies tables suffering from un-vacuumed dead rows from frequent updates.

---

## How to Use

### Method 1: Web Dashboard (Fastest & Zero Setup)
1. Open your **Supabase Dashboard** -> **SQL Editor**.
2. Copy and paste the contents of [`diagnose-db-health.sql`](./diagnose-db-health.sql).
3. Click **Run** to view the diagnostic results directly in your browser.

### Method 2: Terminal Execution
```bash
# Provide connection URI from Project Settings -> Database -> Connection URI
bash audit.sh --db "postgresql://postgres.[ref]:[pass]@aws-0-[region].pooler.supabase.com:6543/postgres"
```

---

## License

MIT © [ITTinker](https://ittinker.com)
