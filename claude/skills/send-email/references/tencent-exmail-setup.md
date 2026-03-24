# 腾讯企业邮配置说明

## SMTP 服务器信息

| 参数 | 值 |
|------|-----|
| SMTP 服务器 | smtp.exmail.qq.com |
| SSL 端口 | 465（推荐） |
| TLS 端口 | 587 |

## 环境变量配置

在使用前，需要设置以下环境变量（推荐写入 `.env` 文件或 shell 配置）：

```bash
export EMAIL_USER="yourname@your-company.com"   # 发件人企业邮箱
export EMAIL_PASSWORD="your-password-or-token"  # 邮箱密码或客户端专用密码
export EMAIL_FROM_NAME="你的名字"                # 可选，发件人显示名称
export EMAIL_SMTP_HOST="smtp.exmail.qq.com"     # 可选，默认已是腾讯企业邮
export EMAIL_SMTP_PORT="465"                    # 可选，默认 465
```

## 获取客户端密码

腾讯企业邮建议使用"客户端专用密码"而非登录密码：

1. 登录 [企业邮箱](https://exmail.qq.com)
2. 设置 → 账户 → 安全设置 → 客户端专用密码
3. 生成并复制密码，设置为 `EMAIL_PASSWORD`

## 常见错误

| 错误 | 原因 | 解决方法 |
|------|------|----------|
| 认证失败 (535) | 密码错误或未开启 SMTP | 检查密码，确认企业邮开启了 SMTP 服务 |
| 连接超时 | 防火墙拦截 465 端口 | 改用 587 端口并设置 `EMAIL_SMTP_PORT=587` |
| 发送频率限制 | 短时间大量发送 | 降低发送频率，避免触发反垃圾机制 |

## 附件说明

- 支持任意文件类型
- 单封邮件附件总大小建议不超过 50MB（企业邮限制）
- 通过 `--attachment` 参数多次指定多个附件
