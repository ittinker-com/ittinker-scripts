#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Google Search QRG SEO Audit Agent
==================================
Based on Google's Search Quality Rater Guidelines (QRG).
Performs dual-track evaluation:
1. Deterministic Layer: DOM parsing, MC/SC ratio, Trust anchors, schema detection.
2. Cognitive Layer: LLM-powered QRG evaluation (Purpose, Effort, E-E-A-T, Needs Met).

Author: The IT Explorer (https://blog.ittinker.com)
License: MIT
"""

import os
import sys
import json
import re
import argparse
from urllib.parse import urlparse
import urllib.request
from html.parser import HTMLParser

class SimpleDOMParser(HTMLParser):
    def __init__(self):
        super().__init__()
        self.title = ""
        self.meta_desc = ""
        self.h1 = []
        self.h2 = []
        self.links = []
        self.buttons = []
        self.has_viewport = False
        self.has_canonical = False
        self.text_chunks = []
        self._current_tag = None
        self._capture_title = False

    def handle_starttag(self, tag, attrs):
        self._current_tag = tag
        attr_dict = dict(attrs)
        
        if tag == "title":
            self._capture_title = True
        elif tag == "meta":
            if attr_dict.get("name", "").lower() == "description":
                self.meta_desc = attr_dict.get("content", "")
            elif attr_dict.get("name", "").lower() == "viewport":
                self.has_viewport = True
        elif tag == "link":
            if attr_dict.get("rel", "").lower() == "canonical":
                self.has_canonical = True
        elif tag == "a" and "href" in attr_dict:
            self.links.append((attr_dict.get("href"), ""))
        elif tag == "button":
            self.buttons.append("")

    def handle_endtag(self, tag):
        if tag == "title":
            self._capture_title = False
        self._current_tag = None

    def handle_data(self, data):
        cleaned = data.strip()
        if not cleaned:
            return
        if self._capture_title:
            self.title += cleaned
        elif self._current_tag == "h1":
            self.h1.append(cleaned)
        elif self._current_tag == "h2":
            self.h2.append(cleaned)
        elif self._current_tag not in ["script", "style", "noscript"]:
            self.text_chunks.append(cleaned)

def fetch_page_data(url: str) -> dict:
    req = urllib.request.Request(
        url,
        headers={"User-Agent": "Mozilla/5.0 (compatible; ITTinker-QRGAuditAgent/1.0; +https://blog.ittinker.com)"}
    )
    try:
        with urllib.request.urlopen(req, timeout=15) as resp:
            status_code = resp.status
            content_type = resp.headers.get("Content-Type", "")
            charset = "utf-8"
            if "charset=" in content_type:
                charset = content_type.split("charset=")[-1].strip()
            html = resp.read().decode(charset, errors="ignore")
    except Exception as e:
        print(f"[ERROR] Failed to fetch {url}: {e}", file=sys.stderr)
        sys.exit(1)

    parser = SimpleDOMParser()
    parser.feed(html)
    
    full_text = " ".join(parser.text_chunks)
    words = full_text.split()
    word_count = len(words)
    cjk_count = len(re.findall(r'[\u4e00-\u9fff]', full_text))
    effective_length = cjk_count if cjk_count > word_count else word_count

    # Check trust signals
    html_lower = html.lower()
    trust_signals = {
        "has_about": bool(re.search(r'about|关于我们|关于', html_lower)),
        "has_contact": bool(re.search(r'contact|联系我们|联系', html_lower)),
        "has_privacy": bool(re.search(r'privacy|隐私政策|隐私', html_lower)),
        "has_terms": bool(re.search(r'terms|服务条款|服务协议', html_lower)),
        "has_schema": bool(re.search(r'application/ld\+json', html_lower)),
        "has_viewport": parser.has_viewport,
        "has_canonical": parser.has_canonical,
    }

    return {
        "url": url,
        "status_code": status_code,
        "title": parser.title,
        "meta_desc": parser.meta_desc,
        "h1": parser.h1,
        "h2_count": len(parser.h2),
        "link_count": len(parser.links),
        "button_count": len(parser.buttons),
        "effective_length": effective_length,
        "trust_signals": trust_signals,
        "content_sample": full_text[:2000]
    }

def run_deterministic_checks(data: dict) -> list:
    findings = []
    
    # 1. Title & Meta
    if not data["title"]:
        findings.append({"level": "CRITICAL", "item": "Missing Title", "desc": "Page has no <title> tag."})
    elif len(data["title"]) > 70:
        findings.append({"level": "WARNING", "item": "Long Title", "desc": f"Title is {len(data['title'])} chars; risk of truncation in SERP."})
    else:
        findings.append({"level": "PASS", "item": "Title Structure", "desc": f"Title ({len(data['title'])} chars) is clean."})

    # 2. Viewport & Mobile-First (QRG 14.0)
    if not data["trust_signals"]["has_viewport"]:
        findings.append({"level": "CRITICAL", "item": "Mobile Viewport", "desc": "Missing viewport meta tag; violates Mobile-First indexing."})
    else:
        findings.append({"level": "PASS", "item": "Mobile Viewport", "desc": "Mobile viewport meta tag configured."})

    # 3. Main Content Effort (QRG 3.2)
    if data["effective_length"] < 150:
        findings.append({"level": "WARNING", "item": "Thin Content Risk", "desc": f"Text volume is only {data['effective_length']} units; verify if tool interactivity compensates."})
    else:
        findings.append({"level": "PASS", "item": "Content Volume", "desc": f"Substantial text/content volume ({data['effective_length']} units)."})

    # 4. Trust & Accountability (QRG 2.5)
    t = data["trust_signals"]
    if not (t["has_about"] and t["has_contact"]):
        findings.append({"level": "WARNING", "item": "Trust Anchors", "desc": "Missing clear About/Contact anchors in DOM."})
    else:
        findings.append({"level": "PASS", "item": "Trust Anchors", "desc": "Found About and Contact reference points."})

    return findings

def mock_or_call_llm_qrg_eval(data: dict, api_key: str = None) -> dict:
    """
    QRG Cognitive Evaluation Layer
    Evaluates Page Quality (PQ) and Needs Met (NM) across QRG dimensions.
    """
    if not api_key:
        # Fallback to rule-based QRG heuristic assessment
        eff = "Medium" if data["effective_length"] > 300 else "Low"
        return {
            "page_purpose": "Identified from Title & Structure (Rule-based estimate)",
            "page_quality_score": 78 if data["trust_signals"]["has_about"] else 65,
            "pq_tier": "Medium PQ (Needs empirical testing or LLM API key for full audit)",
            "dominant_intent": "Informational / Actionable Do",
            "needs_met_rating": "Moderately Meets",
            "recommendations": [
                "Deploy explicit first-hand testing data or benchmark tables to elevate Effort score to High PQ.",
                "Ensure About and Contact pages contain verified legal entity or developer background.",
                "Verify Above-the-fold viewport prioritizes primary task completion over introductory filler."
            ]
        }

    # Call OpenAI-compatible LLM endpoint
    import urllib.request
    prompt = f"""You are a senior Google Search Quality Rater inspecting a webpage.
Webpage Data:
- URL: {data['url']}
- Title: {data['title']}
- Meta Description: {data['meta_desc']}
- Word/Char Count: {data['effective_length']}
- Trust Signals: {json.dumps(data['trust_signals'])}
- Content Excerpt: {data['content_sample']}

Perform a strict QRG assessment. Return ONLY a valid JSON object with keys:
"page_purpose": string,
"page_quality_score": integer (0-100),
"pq_tier": one of ["Lowest", "Low", "Medium", "High", "Highest"],
"dominant_intent": string,
"needs_met_rating": one of ["FailsM", "SlightlyM", "ModeratelyM", "HighlyM", "FullyM"],
"recommendations": list of 3 strings (actionable engineering suggestions)
"""
    headers = {
        "Content-Type": "application/json",
        "Authorization": f"Bearer {api_key}"
    }
    payload = json.dumps({
        "model": os.getenv("LLM_MODEL", "gpt-4o-mini"),
        "response_format": {"type": "json_object"},
        "messages": [
            {"role": "system", "content": "You evaluate websites strictly following Google QRG standards."},
            {"role": "user", "content": prompt}
        ]
    }).encode("utf-8")

    req = urllib.request.Request("https://api.openai.com/v1/chat/completions", data=payload, headers=headers)
    with urllib.request.urlopen(req, timeout=30) as resp:
        res_json = json.loads(resp.read().decode("utf-8"))
        return json.loads(res_json["choices"][0]["message"]["content"])

def generate_report(data: dict, checks: list, qrg: dict) -> str:
    lines = []
    lines.append("# 🛡️ Google Search QRG SEO Audit Report")
    lines.append(f"**Target URL**: `{data['url']}`  ")
    lines.append(f"**Status**: HTTP {data['status_code']} | **Title**: {data['title']}\n")
    lines.append("---")
    lines.append("## 1. 确定性工程合规巡检 (Deterministic Checks)")
    lines.append("| 检查项 | 判定级别 | 说明 |")
    lines.append("| :--- | :--- | :--- |")
    for c in checks:
        icon = "✅" if c["level"] == "PASS" else ("⚠️" if c["level"] == "WARNING" else "🚨")
        lines.append(f"| {c['item']} | {icon} {c['level']} | {c['desc']} |")
    
    lines.append("\n---")
    lines.append("## 2. QRG 认知质量评估 (Cognitive Layer)")
    lines.append(f"- **Page Purpose (页面目的)**: {qrg['page_purpose']}")
    lines.append(f"- **PQ Rating (页面质量档位)**: **{qrg['pq_tier']}** (综合分: {qrg['page_quality_score']}/100)")
    lines.append(f"- **Dominant Intent (核心主导意图)**: {qrg['dominant_intent']}")
    lines.append(f"- **Needs Met (需求满足度)**: **{qrg['needs_met_rating']}**")
    
    lines.append("\n### 🛠️ 核心整改与工程行动建议:")
    for i, rec in enumerate(qrg["recommendations"], 1):
        lines.append(f"{i}. {rec}")
    
    lines.append("\n---\n*Generated by ITTinker QRG Audit Agent · 读懂 Google Search 实战系列*")
    return "\n".join(lines)

def main():
    parser = argparse.ArgumentParser(description="Google QRG SEO Audit Agent CLI")
    parser.add_argument("url", help="Target URL to audit")
    parser.add_argument("--api-key", default=os.getenv("OPENAI_API_KEY"), help="LLM API key for cognitive scoring")
    parser.add_argument("--output", help="Save markdown report to file")
    args = parser.parse_args()

    print(f"[*] Crawling and parsing: {args.url} ...")
    data = fetch_page_data(args.url)
    
    print("[*] Running deterministic QRG compliance rules ...")
    checks = run_deterministic_checks(data)
    
    print("[*] Executing cognitive QRG quality evaluation ...")
    qrg_eval = mock_or_call_llm_qrg_eval(data, args.api_key)
    
    report = generate_report(data, checks, qrg_eval)
    
    if args.output:
        with open(args.output, "w", encoding="utf-8") as f:
            f.write(report)
        print(f"[+] Report saved to {args.output}")
    else:
        print("\n" + report)

if __name__ == "__main__":
    main()
