# MyDrawio Skill

Draw.io 图表创建、编辑和分析技能。

## 文件结构

```
mydrawio/
├── SKILL.md                         # 主技能文档（AI 参考）
├── README.md                        # 本文件（用户指南）
├── scripts/
│   └── check_drawio_syntax.py       # Draw.io 文件格式验证工具
└── references/
    ├── xml_guide.md                 # Draw.io XML 结构详细指南
    └── diagram-examples.md          # 完整图表示例集合
```

## 功能概述

### 支持的操作

1. **基于代码生成图表**
   - 分析代码结构和业务逻辑
   - 生成系统架构图、时序图、流程图等
   - 自动布局和美化

2. **编辑现有图表**
   - 读取和解析现有 .drawio 或 .xml 文件
   - 添加、删除或修改图表元素
   - 保持样式一致性

3. **验证图表格式**
   - 检查 XML 语法正确性
   - 验证 draw.io 文件结构完整性
   - 提供详细错误报告和修复建议
   - 支持压缩和非压缩格式

### 支持的图表类型

- 系统架构图 (System Architecture Diagram)
- 时序图 (Sequence Diagram)
- 流程图 (Flowchart)
- ER 图 (Entity-Relationship Diagram)
- 产品架构图 (Product Architecture Diagram)
- 用例图 (Use Case Diagram)
- 类图 (Class Diagram)
- 组件图 (Component Diagram)
- 泳道图 (Swimlane Diagram)
- 思维导图 (Mind Map)
- Git 分支模型 (Git Branching Model)
- AWS 架构图 (AWS Architecture Diagram)

### 支持的文件格式

- `.drawio` - draw.io 专用格式
- `.xml` - XML 格式的 draw.io 文件
- 支持压缩和非压缩两种存储格式

## 使用方法

### 与 AI 对话示例

```
"请根据 src/ 目录生成系统架构图"
"在 architecture.drawio 中添加 Redis 缓存层"
"验证 diagram.drawio 是否格式正确"
"分析这个项目的代码结构，生成一个产品架构图"
```

### 使用验证工具

验证工具位于：`scripts/check_drawio_syntax.py`

```bash
# 验证单个文件
python3 scripts/check_drawio_syntax.py diagram.drawio

# 验证相对路径文件
python3 scripts/check_drawio_syntax.py ./path/to/diagram.drawio

# 验证整个目录（递归查找所有 .drawio 和 .xml 文件）
python3 scripts/check_drawio_syntax.py ./diagrams

# 验证当前目录
python3 scripts/check_drawio_syntax.py .
```

**验证工具功能：**

- ✅ 检查 XML 格式良好性（标签闭合、引号、转义字符）
- ✅ 验证 draw.io 文件结构（mxfile、diagram、mxGraphModel）
- ✅ 检查必要元素（root、基础 mxCell id="0" 和 id="1"）
- ✅ 支持压缩和非压缩格式
- ✅ 递归扫描目录
- ✅ 提供详细的错误报告

## 核心文档

### [SKILL.md](SKILL.md) - AI 技能文档

- 完整的工作流程（生成、编辑、验证）
- Draw.io 文件基本结构
- 样式属性快速参考
- 最佳实践和常见错误
- 完整示例代码

### [references/xml_guide.md](references/xml_guide.md) - XML 结构详细指南

- Draw.io XML 完整架构说明
- 所有元素和属性详解
- 形状和连接线样式参考
- 高级功能（分组、泳道、表格、图层）
- 自定义属性和样式

### [references/diagram-examples.md](references/diagram-examples.md) - 完整图表示例

- 简单流程图示例
- AWS 架构图示例
- 泳道流程图示例
- 思维导图示例
- Git 分支模型示例
- ER 图示例
- Transformer 架构图示例

## 快速参考

### 常用样式

**矩形框：**

```
rounded=0;whiteSpace=wrap;html=1;fillColor=#dae8fc;strokeColor=#6c8ebf;
```

**圆角矩形：**

```
rounded=1;whiteSpace=wrap;html=1;fillColor=#d5e8d4;strokeColor=#82b366;
```

**菱形：**

```
rhombus;whiteSpace=wrap;html=1;fillColor=#fff2cc;strokeColor=#d6b656;
```

**圆形：**

```
ellipse;whiteSpace=wrap;html=1;fillColor=#f8cecc;strokeColor=#b85450;
```

**连接线（正交）：**

```
edgeStyle=orthogonalEdgeStyle;rounded=0;html=1;endArrow=classic;
```

**虚线：**

```
dashed=1;dashPattern=8 8;endArrow=classic;html=1;
```

### 配色方案

- 蓝色系：`#dae8fc` / `#6c8ebf` - 适用于服务、组件
- 绿色系：`#d5e8d4` / `#82b366` - 适用于数据存储、成功状态
- 黄色系：`#fff2cc` / `#d6b656` - 适用于警告、决策节点
- 红色系：`#f8cecc` / `#b85450` - 适用于错误、危险操作
- 紫色系：`#e1d5e7` / `#9673a6` - 适用于特殊功能、高亮
- 橙色系：`#ffe6cc` / `#d79b00` - 适用于替代方案、次要元素

### 形状类型

- `shape=rectangle` - 矩形
- `shape=ellipse` - 椭圆/圆形
- `shape=rhombus` - 菱形（决策节点）
- `shape=cylinder3` - 圆柱体（数据库）
- `shape=hexagon` - 六边形
- `shape=cloud` - 云形状
- `shape=actor` - 人形图标
- `shape=document` - 文档形状
- `shape=swimlane` - 泳道容器
- `shape=table` - 表格

## 工作流程建议

### 生成新图表

1. 分析需求，确定图表类型
2. 分析代码结构（如需要）
3. 设计图表布局和元素
4. 生成 XML 并保存为 .drawio 文件
5. 使用验证工具检查格式
6. 根据验证结果修复问题

### 编辑现有图表

1. 读取现有 .drawio 文件
2. 解析 XML 结构
3. 执行修改操作
4. 保存修改后的文件
5. 使用验证工具确认

## 当前限制

- ❌ 不支持图片嵌入（base64 编码）
- ❌ 不支持自定义形状库
- ❌ 不支持复杂数学公式（MathJax）
- ❌ 不支持交互式链接和动画

**建议：** 对于这些高级功能，建议在生成基础图表后，在 [draw.io 编辑器](https://app.diagrams.net/) 中手动完成。

## 外部资源

- [draw.io 官方网站](https://www.drawio.com/)
- [diagrams.net 在线编辑器](https://app.diagrams.net/)
- [draw.io 文档](https://www.diagrams.net/doc/)
- [mxGraph 文档](https://jgraph.github.io/mxgraph/)

## 版本信息

- **版本**: 1.0.0
- **创建日期**: 2025-12-12
- **最后更新**: 2025-12-22

## 贡献与反馈

如有问题或建议，请通过项目相关渠道反馈。
