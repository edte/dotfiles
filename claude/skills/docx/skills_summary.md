功能概述  
docx 技能为 Claude 提供对 Word 文档（.docx）的完整生命周期支持：从零创建、增量编辑、批注与修订管理，到深度结构分析。它把 .docx 视作 ZIP-XML 容器，通过“拆包-处理-打包”流水线，在保留版式、批注、修订痕迹、媒体资源的同时，实现可脚本化、可追踪、可审计的自动化操作。适用于合同、标书、论文、政府公文等正式场景，解决多人协作修订易丢失痕迹、手工排版易出错、批量替换难溯源等痛点。

使用方法

1. 环境准备  
   一次性安装 pandoc、LibreOffice、poppler-utils、defusedxml、npm 包 docx 即可；技能脚本已内置 python 拆包/打包工具。

2. 任务选型
   - 仅阅读或提取文本：pandoc --track-changes=all file.docx -o out.md
   - 创建新文档：必读 docx-js.md 全篇 → 用 TypeScript 组装 Document/Paragraph/TextRun → Packer.toBuffer() 输出 .docx
   - 自己文档的小改：走“Basic OOXML editing”——读完 ooxml.md → unpack → 单脚本改 XML → pack
   - 他人文档或正式文件：强制走 Redlining Workflow，保证所有变动带 <w:ins>/<w:del> 痕迹。

3. Redlining 详细步骤  
   a) pandoc 转 current.md，识别全部需改之处并按段/类型/页拆成 3–10 条一批；  
   b) unpack 得 word/document.xml，用 grep 精确定位原文与 <w:r> 边界；  
   c) 每批写一个 Python 脚本：Document 库 get_node 找节点 → 仅替换差异文本 → 复用原 rsid，保持“未变-删除-插入-未变”结构；  
   d) 逐批运行并即时 pack 生成中间文件，验证无误后继续下一批；  
   e) 全部完成后 pack 出终版，再用 pandoc 转 verification.md，grep 确认旧短语零出现、新短语全命中。

4. 辅助命令
   - 可视化比对：soffice --headless --convert-to pdf file.docx；pdftoppm -jpeg -r 150 pdf page，生成 page-1.jpg … 供人眼复核。

预期输出

- 创建场景：直接得到符合 Office 规范的 .docx，含目录、页眉页脚、编号、图片等复杂元素。
- 编辑场景：生成的新 .docx 与原文件字节级差异仅体现在被删/被插部分，Word 打开后可在“审阅”窗格看到作者、时间、批注等完整元数据；同时可导出含修订标记的 .md 或 .pdf 供外部审阅。
- 分析场景：可输出纯文本、带修订标记的 markdown、结构化 XML 节点列表或页面图片，方便后续做差异比对、全文检索、机器学习或归档。

