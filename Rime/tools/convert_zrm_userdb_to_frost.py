#!/usr/bin/env python3
"""Convert old zrm2000 userdb export entries to rime_frost pinyin codes.

The converter keeps learned text/frequency, discards old zrm2000 shape codes,
and re-encodes entries with pinyin codes from the current rime_frost dictionaries.
It only writes an importable text file and a review file; it never imports data.
"""

from __future__ import annotations

import argparse
import collections
import re
from pathlib import Path


CJK_RE = re.compile(r"[\u3400-\u9fff\U00020000-\U0002ebef]")
PINYIN_CODE_RE = re.compile(r"^[a-z]+(?: [a-z]+)*$")


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser()
    parser.add_argument("--source", required=True, help="zrm2000 userdb export txt")
    parser.add_argument("--output", required=True, help="converted rime_frost import txt")
    parser.add_argument("--review", required=True, help="entries that need manual review")
    parser.add_argument("--dict-root", default=".", help="Rime config directory")
    parser.add_argument("--min-count", type=int, default=1, help="drop entries below this count")
    return parser.parse_args()


def read_import_tables(dict_root: Path) -> list[Path]:
    root_dict = dict_root / "rime_frost.dict.yaml"
    tables: list[Path] = []
    in_imports = False

    for raw_line in root_dict.read_text(encoding="utf-8-sig").splitlines():
        line = raw_line.strip()
        if line == "import_tables:":
            in_imports = True
            continue
        if in_imports:
            if not line or line.startswith("#"):
                continue
            if not line.startswith("- "):
                if raw_line and not raw_line.startswith((" ", "\t")):
                    break
                continue
            table = line[2:].split("#", 1)[0].strip()
            if table:
                tables.append(dict_root / f"{table}.dict.yaml")

    tables.append(root_dict)
    return tables


def parse_weight(fields: list[str]) -> int:
    if len(fields) < 3:
        return 0
    try:
        return int(float(fields[2]))
    except ValueError:
        return 0


def is_pinyin_code(code: str) -> bool:
    return bool(PINYIN_CODE_RE.fullmatch(code))


def build_frost_index(dict_root: Path) -> tuple[dict[str, tuple[str, int]], dict[str, str]]:
    word_index: dict[str, tuple[str, int]] = {}
    char_index: dict[str, tuple[str, int]] = {}

    for table in read_import_tables(dict_root):
        if not table.exists():
            continue

        in_data = False
        for raw_line in table.read_text(encoding="utf-8-sig").splitlines():
            line = raw_line.strip()
            if not in_data:
                if line == "...":
                    in_data = True
                continue
            if not line or line.startswith("#"):
                continue

            fields = raw_line.split("\t")
            if len(fields) < 2:
                continue
            text = fields[0].strip()
            code = fields[1].strip()
            if not text or not code or not is_pinyin_code(code):
                continue

            weight = parse_weight(fields)
            old = word_index.get(text)
            if old is None or weight > old[1]:
                word_index[text] = (code, weight)

            if len(text) == 1:
                old_char = char_index.get(text)
                if old_char is None or weight > old_char[1]:
                    char_index[text] = (code, weight)

    return word_index, {char: code for char, (code, _weight) in char_index.items()}


def read_userdb_export(path: Path) -> list[tuple[str, str, int]]:
    entries: list[tuple[str, str, int]] = []
    for raw_line in path.read_text(encoding="utf-8-sig").splitlines():
        if not raw_line or raw_line.startswith("#"):
            continue
        fields = raw_line.split("\t")
        if len(fields) < 3:
            continue
        text = fields[0].strip()
        old_code = fields[1].strip()
        try:
            count = int(float(fields[2]))
        except ValueError:
            continue
        if text:
            entries.append((text, old_code, count))
    return entries


def fallback_code(text: str, char_index: dict[str, str]) -> str | None:
    codes: list[str] = []
    for char in text:
        if CJK_RE.match(char):
            code = char_index.get(char)
            if code is None:
                return None
            codes.append(code)
        elif char.isascii() and char.isalnum():
            # Keep mixed tokens review-only unless exact word lookup already handled them.
            return None
        else:
            return None
    return " ".join(codes) if codes else None


def write_import(path: Path, entries: dict[tuple[str, str], int]) -> None:
    lines = [
        "# Rime user dictionary export",
        "#@/db_name\trime_frost",
        "#@/db_type\tuserdb",
        "#@/source\tconverted from zrm2000 userdb",
    ]
    for (text, code), count in sorted(entries.items(), key=lambda item: (-item[1], item[0][0])):
        lines.append(f"{text}\t{code}\t{count}")
    path.write_text("\n".join(lines) + "\n", encoding="utf-8")


def write_review(path: Path, rows: list[tuple[str, str, int, str]]) -> None:
    lines = [
        "# text\told_code\tcount\treason",
        "# no_* rows were skipped; converted_by_single_char_fallback rows were imported but need review.",
    ]
    for text, old_code, count, reason in rows:
        lines.append(f"{text}\t{old_code}\t{count}\t{reason}")
    path.write_text("\n".join(lines) + "\n", encoding="utf-8")


def main() -> None:
    args = parse_args()
    dict_root = Path(args.dict_root).resolve()
    source = Path(args.source).resolve()
    output = Path(args.output).resolve()
    review = Path(args.review).resolve()

    word_index, char_index = build_frost_index(dict_root)
    converted: collections.Counter[tuple[str, str]] = collections.Counter()
    review_rows: list[tuple[str, str, int, str]] = []
    stats: collections.Counter[str] = collections.Counter()

    for text, old_code, count in read_userdb_export(source):
        if count < args.min_count:
            stats["dropped_low_count"] += 1
            continue
        if not CJK_RE.search(text):
            review_rows.append((text, old_code, count, "no_cjk_text"))
            stats["review_no_cjk_text"] += 1
            continue

        indexed = word_index.get(text)
        if indexed is not None:
            converted[(text, indexed[0])] += count
            stats["converted_exact_word"] += 1
            continue

        fallback = fallback_code(text, char_index)
        if fallback is not None:
            converted[(text, fallback)] += count
            review_rows.append((text, old_code, count, "converted_by_single_char_fallback"))
            stats["converted_single_char_fallback"] += 1
            continue

        review_rows.append((text, old_code, count, "no_frost_code"))
        stats["review_no_frost_code"] += 1

    output.parent.mkdir(parents=True, exist_ok=True)
    review.parent.mkdir(parents=True, exist_ok=True)
    write_import(output, dict(converted))
    write_review(review, review_rows)

    print(f"frost_words={len(word_index)}")
    print(f"frost_chars={len(char_index)}")
    print(f"source_entries={sum(stats.values())}")
    print(f"converted_entries={len(converted)}")
    print(f"review_entries={len(review_rows)}")
    for key in sorted(stats):
        print(f"{key}={stats[key]}")
    print(f"output={output}")
    print(f"review={review}")


if __name__ == "__main__":
    main()
