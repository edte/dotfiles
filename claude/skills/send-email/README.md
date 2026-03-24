# send-email Skill 使用说明

> 通过腾讯企业邮（exmail.qq.com）SMTP 发送邮件的 OpenClaw Skill。  
> 支持纯文本、HTML、附件（含中文文件名）、抄送、密送等所有邮件类型。

---

## 目录结构

```
send-email/
├── SKILL.md                        # OpenClaw Skill 入口描述
├── README.md                       # 本说明文档
├── scripts/
│   └── send_email.py               # 核心发送脚本（Python 3）
└── references/
    └── tencent-exmail-setup.md     # 腾讯企业邮 SMTP 配置参考
```

---

## 环境要求

- Python 3.6+（标准库，无需额外安装依赖）
- 腾讯企业邮账号，并获取 **授权码**（客户端专用密码）

---

## 快速开始

### 第一步：配置环境变量

```bash
export EMAIL_USER="yourname@company.com"       # 发件人邮箱
export EMAIL_PASSWORD="your-auth-code"         # 授权码（非登录密码）
export EMAIL_FROM_NAME="张三"                  # 可选，发件人显示名
```

> 💡 建议写入 `~/.bashrc` 或 `~/.zshrc` 永久生效，或通过 OpenClaw 环境变量管理配置。

### 第二步：发送邮件

```bash
python3 scripts/send_email.py \
  --to "someone@company.com" \
  --subject "你好" \
  --body "这是一封测试邮件"
```

---

## 参数说明

| 参数 | 必填 | 说明 |
|------|:----:|------|
| `--to` | ✅ | 收件人邮箱，多个用英文逗号分隔 |
| `--subject` | ✅ | 邮件主题，支持中文 |
| `--body` | 二选一 | 纯文本正文 |
| `--html` | 二选一 | HTML 格式正文，可与 `--body` 同时使用 |
| `--cc` | ❌ | 抄送地址，多个用逗号分隔 |
| `--bcc` | ❌ | 密送地址，多个用逗号分隔 |
| `--attachment` | ❌ | 附件路径，可多次使用以发送多个附件 |
| `--reply-to` | ❌ | 指定回复地址 |

---

## 环境变量说明

| 变量名 | 必填 | 默认值 | 说明 |
|--------|:----:|--------|------|
| `EMAIL_USER` | ✅ | — | 发件人邮箱地址 |
| `EMAIL_PASSWORD` | ✅ | — | 邮箱授权码或密码 |
| `EMAIL_FROM_NAME` | ❌ | 空（使用邮箱地址） | 发件人显示名称 |
| `EMAIL_SMTP_HOST` | ❌ | `smtp.exmail.qq.com` | SMTP 服务器地址 |
| `EMAIL_SMTP_PORT` | ❌ | `465` | SMTP 端口（465=SSL，587=TLS） |

---

## 使用场景与示例

### 场景 1：发送普通通知邮件

**适用：** 日常工作通知、任务完成提醒

```bash
python3 scripts/send_email.py \
  --to "boss@company.com" \
  --subject "任务完成通知" \
  --body "你好，本周的数据统计任务已完成，请查收。"
```

---

### 场景 2：发送 HTML 格式邮件

**适用：** 报告、公告、需要格式排版的邮件

```bash
python3 scripts/send_email.py \
  --to "team@company.com" \
  --subject "每周技术周报" \
  --html "
<html>
<body>
  <h2>本周技术周报</h2>
  <h3>✅ 已完成</h3>
  <ul>
    <li>完成用户模块重构</li>
    <li>修复线上 3 个 Bug</li>
  </ul>
  <h3>🔧 进行中</h3>
  <ul>
    <li>性能优化专项</li>
  </ul>
  <p>如有问题请回复此邮件。</p>
</body>
</html>"
```

---

### 场景 3：发送带附件的邮件

**适用：** 发送报告文件、数据表格、图片等

```bash
python3 scripts/send_email.py \
  --to "manager@company.com" \
  --subject "月度报告" \
  --body "请查收本月数据报告，详见附件。" \
  --attachment "/home/user/reports/monthly_report.pdf" \
  --attachment "/home/user/data/sales_data.xlsx"
```

> 支持中文文件名，如 `--attachment "/home/user/文件/月度报告.pdf"`

---

### 场景 4：群发邮件 + 抄送

**适用：** 通知多人、需要留抄送记录

```bash
python3 scripts/send_email.py \
  --to "alice@company.com,bob@company.com" \
  --cc "supervisor@company.com" \
  --bcc "archive@company.com" \
  --subject "项目启动通知" \
  --body "各位，新项目将于下周一正式启动，请做好准备。"
```

---

### 场景 5：纯文本 + HTML 双版本（兼容性最佳）

**适用：** 确保不同邮件客户端都能正常显示

```bash
python3 scripts/send_email.py \
  --to "client@example.com" \
  --subject "服务更新通知" \
  --body "尊敬的用户，我们的服务将于本周五进行维护，预计影响时间 2 小时。" \
  --html "<p>尊敬的用户，</p><p>我们的服务将于<strong>本周五</strong>进行维护，预计影响时间 <strong>2 小时</strong>。</p>"
```

---

### 场景 6：指定回复地址

**适用：** 发件人与回复地址不同的情况

```bash
python3 scripts/send_email.py \
  --to "user@company.com" \
  --reply-to "support@company.com" \
  --subject "您的工单已受理" \
  --body "您的工单已受理，请回复此邮件联系客服。"
```

---

### 场景 7：使用 587 TLS 端口

**适用：** 465 端口被防火墙拦截的网络环境

```bash
EMAIL_SMTP_PORT=587 python3 scripts/send_email.py \
  --to "someone@company.com" \
  --subject "测试" \
  --body "TLS 端口测试"
```

---

## 常见问题

### Q: 认证失败（535 错误）

- 确认 `EMAIL_PASSWORD` 填写的是**授权码**，而非登录密码
- 腾讯企业邮授权码获取：登录网页邮箱 → 设置 → 账户 → 安全设置 → 客户端专用密码

### Q: 不能往外域发信

- 腾讯企业邮默认限制向外域（非本公司域名）发送邮件
- 解决方法：联系邮箱管理员开通"允许外域发送"权限

### Q: 连接超时

- 尝试换用 587 端口：`export EMAIL_SMTP_PORT=587`
- 检查网络环境是否屏蔽了 465/587 端口

### Q: 附件中文文件名乱码

- 已内置 RFC 2231 编码支持，主流邮件客户端（Outlook、企业邮、Gmail）均可正常显示

---

## 注意事项

1. **安全**：请勿将授权码硬编码在脚本或代码仓库中，建议使用环境变量管理
2. **频率**：避免短时间大量发送，否则可能触发腾讯企业邮反垃圾策略
3. **附件大小**：单封邮件附件总大小建议不超过 **50MB**（企业邮服务器限制）
4. **外域限制**：腾讯企业邮账号默认不可发外域邮件，如需发送请联系管理员

---

## 参考资料

- [腾讯企业邮 SMTP 配置](references/tencent-exmail-setup.md)
- [腾讯企业邮官网](https://exmail.qq.com)
- [RFC 2822 邮件格式标准](https://datatracker.ietf.org/doc/html/rfc2822)
