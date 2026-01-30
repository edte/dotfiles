功能概述  
skill-creator 是一套面向 Claude 的“技能脚手架”系统，用于把一次性提示升级为可复用、可分发、可演化的专用技能包。它解决的核心问题是：当用户反复让 Claude 完成同类复杂任务（如 PDF 旋转、BigQuery 写 SQL、前端项目初始化）时，无需每次都从零开始写提示或代码，而是把“怎么做”沉淀为带脚本、参考文档、模板资产的技能目录，Claude 在检测到相关意图时自动加载并执行，从而显著降低 token 消耗、提升一致性与可靠性。

使用方法  
1. 需求澄清：用对话方式收集至少 3–5 个真实用例，确认输入、输出、边界与触发句。  
2. 资源规划：把用例拆成“需脚本化的高频代码”“需参考的 schema/政策”“需复用的模板/图标”三类，列出清单。  
3. 初始化：运行 `python scripts/init_skill.py <skill-name> --path ./skills` 生成标准目录：  
   skill-name/  
   ├── SKILL.md          # 必填，含 YAML 头（name、description）与 Markdown 指令  
   ├── scripts/          # 可选，放 Python/Bash 等可执行文件  
   ├── references/       # 可选，放 schema、API 文档、政策等纯文本  
   └── assets/           # 可选，放模板、图片、字体等输出用二进制  
4. 编写资源：  
   - 脚本须本地测试通过，保证输出稳定；同类脚本只需抽检。  
   - 参考文件大于 100 行时顶部加目录，并给出 grep 模式。  
   - 资产文件保持原名，避免中文与特殊字符。  
5. 撰写 SKILL.md：  
   - 前端 YAML 仅保留 name、description；description 用 1–2 句话写明“做什么+何时触发”，方便 Claude 快速匹配。  
   - 正文用祈使句，按“快速开始→高级功能→资源引用”递进；超过 500 行即拆分 reference。  
6. 打包：执行 `python scripts/package_skill.py <skill-folder>`，自动完成 YAML 校验、命名检查、路径合规后生成 `<skill-name>.skill` 分发包。  
7. 迭代：上线后收集失败或冗余案例，回改脚本或参考文件，重新打包即可。

预期输出  
成功打包后得到 `<skill-name>.skill` 文件（实质是 zip），内含：  
- 经压缩的目录树，保持 scripts、references、assets 子目录不变；  
- 一份通过校验的 SKILL.md，其 description 字段已被 Claude 索引，可在后续对话中自动触发；  
- 脚本可直接被 Claude 调用执行，参考文件可按需加载，资产文件可在生成结果时复制或嵌入。  
用户后续在任何支持 skill-creator 的 Claude 环境中上传该 `.skill` 文件，即可通过自然语言触发对应能力，无需再次编写提示或配置环境。