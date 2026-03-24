---
name: send-email
description: 通过腾讯企业邮（exmail.qq.com）SMTP 发送邮件。支持纯文本、HTML、附件、抄送、密送等所有邮件类型。当用户要求发送邮件、写邮件并发出、给某人发邮件时使用此 skill。需要提前配置 EMAIL_USER 和 EMAIL_PASSWORD 环境变量。
---

# Send Email Skill

使用 `scripts/send_email.py` 通过腾讯企业邮 SMTP 发送邮件。

## 前置配置

运行前确认环境变量已设置：

```bash
export EMAIL_USER="yourname@company.com"
export EMAIL_PASSWORD="your-auth-code-or-password"
# 可选
export EMAIL_FROM_NAME="显示名称"
export EMAIL_SMTP_HOST="smtp.exmail.qq.com"   # 默认
export EMAIL_SMTP_PORT="465"                  # 默认，支持 465(SSL) 或 587(TLS)
```

如未设置，提示用户参考 `references/tencent-exmail-setup.md` 完成配置。

> ⚠️ 腾讯企业邮账号默认**不能往外域发信**（非同公司域名），如需发外域请联系邮箱管理员开通权限。

## 发送邮件

### 纯文本邮件

```bash
python3 scripts/send_email.py \
  --to "收件人@example.com" \
  --subject "邮件主题" \
  --body "纯文本正文"
```

### HTML 邮件

```bash
python3 scripts/send_email.py \
  --to "收件人@example.com" \
  --subject "邮件主题" \
  --html "<h1>标题</h1><p>正文内容</p>"
```

### 纯文本 + HTML 同时发送（兼容性最佳）

```bash
python3 scripts/send_email.py \
  --to "收件人@example.com" \
  --subject "邮件主题" \
  --body "纯文本备用版本" \
  --html "<h1>HTML 版本</h1><p>内容</p>"
```

### 带附件

```bash
python3 scripts/send_email.py \
  --to "收件人@example.com" \
  --subject "邮件主题" \
  --body "请查收附件" \
  --attachment "/path/to/file.pdf" \
  --attachment "/path/to/data.xlsx"
```

### 多收件人 + 抄送 + 密送

```bash
python3 scripts/send_email.py \
  --to "a@example.com,b@example.com" \
  --cc "c@example.com" \
  --bcc "d@example.com" \
  --subject "会议通知" \
  --body "请准时参加"
```

## 参数说明

| 参数 | 必填 | 说明 |
|------|------|------|
| `--to` | ✅ | 收件人，多个用逗号分隔 |
| `--subject` | ✅ | 邮件主题 |
| `--body` | 二选一 | 纯文本正文 |
| `--html` | 二选一 | HTML 正文（可与 --body 同时使用） |
| `--cc` | ❌ | 抄送，多个用逗号分隔 |
| `--bcc` | ❌ | 密送，多个用逗号分隔 |
| `--attachment` | ❌ | 附件路径，可多次指定，支持中文文件名 |
| `--reply-to` | ❌ | 回复地址 |

## 错误处理

| 错误信息 | 原因 | 解决方法 |
|----------|------|----------|
| 认证失败 (535) | 密码/授权码错误 | 检查 EMAIL_PASSWORD |
| 不能往外域发信 | 账号限制 | 联系邮箱管理员开通外域权限 |
| 连接超时 | 防火墙拦截 | 改用 587 端口，设置 EMAIL_SMTP_PORT=587 |
| 附件不存在 | 路径错误 | 确认附件文件路径正确 |

## 配置问题

如遇认证失败或连接问题，读取 `references/tencent-exmail-setup.md` 获取详细配置说明。
