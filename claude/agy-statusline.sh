#!/usr/bin/env bash
set -euo pipefail

INPUT=$(cat)

# 如需排查 agy 实际传入的 JSON 结构，可取消下面这行注释：
# printf '%s\n' "$INPUT" > /tmp/agy-statusline-debug.json

printf '%s' "$INPUT" | jq -r '
  def slugify:
    ascii_downcase
    | gsub("[[:space:]_]+"; "-")
    | gsub("-+"; "-")
    | sub("^-"; "")
    | sub("-$"; "");

  def fmt_model($m):
    ($m.display_name // $m.id // "unknown") as $raw
    | ($m.effort // "" | ascii_downcase) as $eff
    | ([try ($raw | capture("^(?<base>.+?)\\s*\\((?<tag>[^)]+)\\)\\s*$")) catch empty] | .[0]) as $cap
    | if $cap != null then
        ($cap.base | slugify) as $base
        | ($cap.tag | slugify) as $tag
        | "\($base)/\($tag)"
      else
        ($raw | slugify) as $base
        | if $eff != "" then "\($base)/\($eff)" else $base end
      end;

  def bucket_rank($k):
    ($k | ascii_downcase) as $lk
    | if ($lk | test("5h|5_h|5hour")) then 0
      elif ($lk | test("week|7d")) then 1
      else 2
      end;

  def bucket_label($k):
    ($k | ascii_downcase) as $lk
    | if $lk == "gemini-5h" then "5h"
      elif $lk == "gemini-weekly" then "weekly"
      else ($k | sub("^[Gg]emini[-_]"; ""))
      end;

  def fmt_reset($v):
    ($v.reset_time // "") as $rt
    | ($v.reset_in_seconds // 0) as $rs
    | (
        if ($rt | type) == "string" and $rt != "" then
          try ($rt | sub("\\.[0-9]+Z$"; "Z") | fromdateiso8601) catch null
        else
          null
        end
      ) as $ts
    | (
        if $ts != null then $ts
        elif ($rs | type) == "number" and $rs > 0 then (now + $rs | floor)
        else null
        end
      ) as $final_ts
    | if $final_ts != null then
        " \u001b[2m(\($final_ts | strflocaltime("%m-%d %H:%M")))\u001b[0m"
      else
        ""
      end;

  def fmt_bucket:
    bucket_label(.key) as $k
    | .value as $v
    | fmt_reset($v) as $rst
    | if ($v.remaining_fraction | type) == "number" then
        (($v.remaining_fraction * 100) + 0.5 | floor) as $p
        | "\($k):\u001b[1m\($p)%\u001b[0m\($rst)"
      elif ($v.remaining_amount | type) == "number" then
        "\($k):\u001b[1m\($v.remaining_amount)\u001b[0m\($rst)"
      else
        empty
      end;

  fmt_model(.model // {}) as $model
  | (.email // "") as $email
  | (
      (.quota // {})
      | to_entries
      | map(select(
          (.value | type) == "object"
          and ((.value.disabled // false) | not)
          and ((.key | ascii_downcase) | contains("gemini"))
        ))
      | sort_by([bucket_rank(.key), .key])
      | map(fmt_bucket)
    ) as $quotas

  | (
      ["\u001b[1m\($model)\u001b[0m"]
      + (if ($quotas | length) > 0 then $quotas else ["\u001b[2mlimit: --\u001b[0m"] end)
      + (if $email != "" then ["\u001b[2m\($email)\u001b[0m"] else [] end)
    )
  | join("  \u001b[2m·\u001b[0m  ")
'
