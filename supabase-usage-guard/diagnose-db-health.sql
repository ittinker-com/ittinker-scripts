-- ==============================================================================
-- Supabase / PostgreSQL 360° Database Health, Performance & Egress Diagnostic Suite
-- Supabase / PostgreSQL 数据库健康、慢查询、缺失索引与流量体检脚本
-- Repository: https://github.com/ittinker-com/ittinker-scripts
-- ==============================================================================

-- ------------------------------------------------------------------------------
-- 1. 流量大户与高频拉取 Top 10（直接导致 Egress 爆满与账单超限的元凶）
-- ------------------------------------------------------------------------------
SELECT 
    calls,                               -- 总执行调用次数
    rows,                                -- 总返回行数（行数越大，走连接池的网络传输量越大）
    round(rows::numeric / nullif(calls, 0), 2) AS avg_rows_per_call, -- 平均每次返回多少行
    round((total_exec_time / 1000)::numeric, 2) AS total_seconds,    -- 累计执行总时间 (秒)
    round((mean_exec_time)::numeric, 2) AS avg_ms,                   -- 平均单次耗时 (毫秒)
    substr(query, 1, 150) AS query_snippet                           -- SQL 摘要
FROM pg_stat_statements
WHERE query NOT LIKE '%pg_stat_statements%' 
  AND query NOT LIKE '%BEGIN%'
  AND query NOT LIKE '%COMMIT%'
ORDER BY rows DESC
LIMIT 10;

-- ------------------------------------------------------------------------------
-- 2. 慢查询 Top 10（最耗时的低效 SQL，往往是缺索引或在大表做全量排序）
-- ------------------------------------------------------------------------------
SELECT 
    calls,
    round((total_exec_time / 1000)::numeric, 2) AS total_seconds,
    round((mean_exec_time)::numeric, 2) AS avg_ms,
    round((max_exec_time)::numeric, 2) AS max_ms,
    rows,
    substr(query, 1, 150) AS query_snippet
FROM pg_stat_statements
WHERE query NOT LIKE '%pg_stat_statements%'
ORDER BY total_exec_time DESC
LIMIT 10;

-- ------------------------------------------------------------------------------
-- 3. 严重缺失索引的表（全表扫描次数最多的表 Top 10）
-- 命中率低说明大量查询在逐行硬扫磁盘，既慢又吃 CPU 和内存！
-- ------------------------------------------------------------------------------
SELECT 
    schemaname,
    relname AS table_name,
    seq_scan,                            -- 全表扫描次数（如果很大，说明缺少索引）
    seq_tup_read,                        -- 全表扫描读取的行数
    idx_scan,                            -- 走索引扫描的次数
    round(100.0 * idx_scan / nullif(seq_scan + idx_scan, 0), 2) AS index_hit_percent, -- 索引命中百分比
    n_live_tup AS estimated_rows         -- 估算当前存活总行数
FROM pg_stat_user_tables
WHERE seq_scan + idx_scan > 50           -- 排除冷门小表
ORDER BY seq_scan DESC
LIMIT 10;

-- ------------------------------------------------------------------------------
-- 4. 冗余/无用索引排查（占了磁盘还拖慢插入更新速度）
-- 长期 idx_scan = 0 的索引建议考虑评估后删除
-- ------------------------------------------------------------------------------
SELECT 
    schemaname,
    relname AS table_name,
    indexrelname AS index_name,
    idx_scan,                            -- 索引被查询使用的次数
    pg_size_pretty(pg_relation_size(indexrelid)) AS index_size -- 占用的存储空间
FROM pg_stat_user_indexes
WHERE idx_scan = 0 
  AND indexrelname NOT LIKE '%_pkey'     -- 排除主键约束
ORDER BY pg_relation_size(indexrelid) DESC
LIMIT 10;

-- ------------------------------------------------------------------------------
-- 5. 存储空间占用 Top 10（大表排查）
-- ------------------------------------------------------------------------------
SELECT 
    relname AS table_name,
    pg_size_pretty(pg_total_relation_size(relid)) AS total_size,  -- 表 + 索引总空间
    pg_size_pretty(pg_relation_size(relid)) AS data_size,        -- 数据本体大小
    pg_size_pretty(pg_total_relation_size(relid) - pg_relation_size(relid)) AS index_size, -- 索引开销
    n_live_tup AS estimated_rows
FROM pg_stat_user_tables
ORDER BY pg_total_relation_size(relid) DESC
LIMIT 10;

-- ------------------------------------------------------------------------------
-- 6. 表膨胀与死元组排行（Dead Tuples - 频繁 UPDATE/DELETE 产生的垃圾数据）
-- dead_tuple_percent 过高说明 AutoVacuum 没跟上，需要排查或手动 VACUUM
-- ------------------------------------------------------------------------------
SELECT 
    relname AS table_name,
    n_live_tup AS live_rows,
    n_dead_tup AS dead_rows,
    round(100.0 * n_dead_tup / nullif(n_live_tup + n_dead_tup, 0), 2) AS dead_tuple_percent,
    last_vacuum,
    last_autovacuum
FROM pg_stat_user_tables
WHERE n_dead_tup > 500
ORDER BY n_dead_tup DESC
LIMIT 10;
