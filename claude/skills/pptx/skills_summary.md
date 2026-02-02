功能概述  
pptx 技能为 Claude 提供了一套端到端的 PowerPoint 操作能力，覆盖新建、编辑、解析与视觉化验证四大场景。它既能从零生成符合品牌调性的演示文稿，也能在保留母版设计的前提下批量替换内容，还可直接读写底层 OOXML 以微调注释、动画、母版等高级元素，解决传统脚本无法兼顾“快速成稿”与“精细调整”的痛点。

使用方法

1. 环境准备：确认已安装 markitdown、pptxgenjs、playwright、sharp、LibreOffice、Poppler 等依赖。
2. 新建无模板文件：  
   a. 先完整阅读 html2pptx.md 掌握语法；  
   b. 按 720×405 pt 画布写 HTML，仅用 p、h1-h6、ul、ol 标签；图表/表格区域用 class="placeholder" 并临时填灰色背景；  
   c. 用 Sharp 预渲染渐变与图标成 PNG 再引用；  
   d. 运行 html2pptx.js 将 HTML 数组转为 pptx，并调用 thumbnail.py 生成 4-5 列缩略图网格，逐页检查文字是否溢出、重叠或对比度不足，循环调整至通过。
3. 新建基于模板文件：  
   a. thumbnail.py 生成模板缩略图，markitdown 提取文本，人工填写 template-inventory.md 记录每页版式；  
   b. 依据实际内容块数量选择版式（两栏仅放两项，三栏仅放三项，不硬凑），保存 outline.md 并给出 0-based 模板映射表；  
   c. rearrange.py 按映射复制、排序、删页得 working.pptx；  
   d. inventory.py 导出 text-inventory.json，按真实 shape 结构写 replacement-text.json（含 paragraphs、bullet、alignment、color 等属性，未列出的 shape 将被清空）；  
   e. replace.py 校验 shape 存在性与溢出问题，通过后生成 output.pptx。
4. 编辑现有文件：  
   a. 完整阅读 ooxml.md；  
   b. unpack.py 解压，直接修改 ppt/slides/slideN.xml、notesSlides、comments 等；  
   c. 每改一次即用 validate.py 对照原文件校验，消除 XML 错误；  
   d. pack.py 重新打包。
5. 文字抽取：仅阅读内容时，执行 python -m markitdown file.pptx 即可得 Markdown。

预期输出

- 新建场景：可直接交付的 .pptx 文件，附带缩略图与可选 PDF/图片序列，支持 16:9、文本层级、母版配色、图表占位完整，且通过视觉校验无溢框。
- 模板替换场景：版式、字体、配色与原母版保持一致，所有占位符被精准填充，未使用形状自动清空，脚本一次性回滚错误。
- 编辑场景：保留原文件媒体与关系的有效 OOXML，validate.py 报告无错误，可继续二次开发。
- 解析场景：Markdown 或 JSON inventories 提供结构化文本、坐标、样式、层级，便于后续 NLP 分析或数据迁移。

