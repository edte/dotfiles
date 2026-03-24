#!/usr/bin/env python3
"""
send_email.py - 腾讯企业邮 SMTP 邮件发送工具

用法:
    python3 send_email.py --to "a@example.com" --subject "主题" --body "正文"
    python3 send_email.py --to "a@example.com,b@example.com" --subject "主题" --html "<h1>Hello</h1>"
    python3 send_email.py --to "a@example.com" --subject "主题" --body "正文" --attachment "/path/to/file.pdf"
    python3 send_email.py --to "a@example.com" --subject "主题" --body "正文" --cc "c@example.com" --bcc "d@example.com"

环境变量 (必填):
    EMAIL_USER     - 发件人邮箱地址，如 yourname@your-company.com
    EMAIL_PASSWORD - 邮箱密码或授权码

环境变量 (可选):
    EMAIL_SMTP_HOST - SMTP 服务器，默认 smtp.exmail.qq.com
    EMAIL_SMTP_PORT - SMTP 端口，默认 465 (SSL)，也支持 587 (TLS)
    EMAIL_FROM_NAME - 发件人显示名称，默认使用邮箱地址
"""

import argparse
import os
import smtplib
import sys
from email.header import Header
from email.mime.base import MIMEBase
from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText
from email import encoders
from email.utils import formataddr
from pathlib import Path


def parse_args():
    parser = argparse.ArgumentParser(description="腾讯企业邮 SMTP 邮件发送工具")
    parser.add_argument("--to", required=True, help="收件人，多个用逗号分隔")
    parser.add_argument("--subject", required=True, help="邮件主题")
    parser.add_argument("--body", help="纯文本正文")
    parser.add_argument("--html", help="HTML 正文")
    parser.add_argument("--cc", help="抄送，多个用逗号分隔")
    parser.add_argument("--bcc", help="密送，多个用逗号分隔")
    parser.add_argument("--attachment", action="append", dest="attachments",
                        help="附件路径，可多次指定，支持中文文件名")
    parser.add_argument("--reply-to", help="回复地址")
    return parser.parse_args()


def encode_filename(filename: str) -> str:
    """对附件文件名进行 RFC 2231 编码，支持中文及特殊字符。"""
    try:
        filename.encode("ascii")
        return filename
    except UnicodeEncodeError:
        return Header(filename, "utf-8").encode()


def build_message(args, sender_email: str, sender_name: str):
    has_html = bool(args.html)
    has_body = bool(args.body)
    has_attachments = bool(args.attachments)

    if not has_html and not has_body:
        print("错误: 必须提供 --body 或 --html 之一", file=sys.stderr)
        sys.exit(1)

    if has_attachments:
        msg = MIMEMultipart("mixed")
    elif has_html and has_body:
        msg = MIMEMultipart("alternative")
    elif has_html:
        msg = MIMEMultipart("alternative")
    else:
        msg = MIMEMultipart()

    # 发件人（支持中文显示名）
    from_addr = formataddr((str(Header(sender_name, "utf-8")) if sender_name else sender_email, sender_email))
    msg["From"] = from_addr
    msg["To"] = args.to
    msg["Subject"] = Header(args.subject, "utf-8").encode()

    if args.cc:
        msg["Cc"] = args.cc
    if args.reply_to:
        msg["Reply-To"] = args.reply_to

    # 正文部分
    if has_html and has_body:
        alt_part = MIMEMultipart("alternative")
        alt_part.attach(MIMEText(args.body, "plain", "utf-8"))
        alt_part.attach(MIMEText(args.html, "html", "utf-8"))
        msg.attach(alt_part)
    elif has_html:
        msg.attach(MIMEText(args.html, "html", "utf-8"))
    else:
        msg.attach(MIMEText(args.body, "plain", "utf-8"))

    # 附件（支持中文文件名）
    if has_attachments:
        for filepath in args.attachments:
            path = Path(filepath)
            if not path.exists():
                print(f"错误: 附件不存在: {filepath}", file=sys.stderr)
                sys.exit(1)
            with open(path, "rb") as f:
                part = MIMEBase("application", "octet-stream")
                part.set_payload(f.read())
            encoders.encode_base64(part)
            encoded_name = encode_filename(path.name)
            part.add_header(
                "Content-Disposition",
                f"attachment",
                filename=("utf-8", "", path.name)
            )
            msg.attach(part)

    return msg


def get_all_recipients(args) -> list:
    recipients = [r.strip() for r in args.to.split(",") if r.strip()]
    if args.cc:
        recipients += [r.strip() for r in args.cc.split(",") if r.strip()]
    if args.bcc:
        recipients += [r.strip() for r in args.bcc.split(",") if r.strip()]
    return recipients


def main():
    args = parse_args()

    sender_email = os.environ.get("EMAIL_USER")
    password = os.environ.get("EMAIL_PASSWORD")
    smtp_host = os.environ.get("EMAIL_SMTP_HOST", "smtp.exmail.qq.com")
    smtp_port = int(os.environ.get("EMAIL_SMTP_PORT", "465"))
    sender_name = os.environ.get("EMAIL_FROM_NAME", "")

    if not sender_email or not password:
        print("错误: 请设置环境变量 EMAIL_USER 和 EMAIL_PASSWORD", file=sys.stderr)
        sys.exit(1)

    msg = build_message(args, sender_email, sender_name)
    recipients = get_all_recipients(args)

    try:
        if smtp_port == 465:
            with smtplib.SMTP_SSL(smtp_host, smtp_port) as server:
                server.login(sender_email, password)
                server.sendmail(sender_email, recipients, msg.as_string())
        else:
            with smtplib.SMTP(smtp_host, smtp_port) as server:
                server.ehlo()
                server.starttls()
                server.ehlo()
                server.login(sender_email, password)
                server.sendmail(sender_email, recipients, msg.as_string())

        print(f"✓ 邮件已发送至: {', '.join(recipients)}")

    except smtplib.SMTPAuthenticationError:
        print("错误: 认证失败，请检查 EMAIL_USER 和 EMAIL_PASSWORD", file=sys.stderr)
        sys.exit(1)
    except smtplib.SMTPRecipientsRefused as e:
        print(f"错误: 收件人被拒绝: {e}", file=sys.stderr)
        sys.exit(1)
    except smtplib.SMTPException as e:
        print(f"错误: SMTP 发送失败: {e}", file=sys.stderr)
        sys.exit(1)
    except Exception as e:
        print(f"错误: {e}", file=sys.stderr)
        sys.exit(1)


if __name__ == "__main__":
    main()
