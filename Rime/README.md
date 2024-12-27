# rimerc

一个自然码双拼用户的Rime配置, **高度定制, 仅供参考**


## 文件位置

- Windows
  - Weasel: `%APPDATA%\Rime`
- Mac OS X
  - Squirrel: `~/Library/Rime`
- Linux
  - Fcitx5: `~/.local/share/fcitx5/rime`
  - Fcitx: `~/.config/fcitx/rime`
  - iBus: `~/.config/ibus/rime`

## 配置文件说明

> 不带 custom 的是配置的定制，用于实现配置；带 custom 的则是配置的覆写，用于覆写不带 custom 的某些配置；其他内容继承不带 custom 配置


default.yaml 设置输入法、如何切换输入法、翻页等
squirrel.custom.yaml 鼠须管 (Mac 版本) 设置哪些软件默认英文输入，输入法皮肤等
weasel.custom.yaml 小狼毫 (Win 版本) 设置哪些软件默认英文输入，输入法皮肤等
custom_phrase.txt 设置快捷输入，修改完成后要重新部署才能生效


https://github.com/rime/home/wiki/RimeWithSchemata
https://github.com/rime/home/wiki/CustomizationGuide


## 主要更改

1. 大写 `V` 进入自然码单字编码查询模式
2. 大写 `U` 进入自然码拆字模式
3. 前面两种模式, 所提示的编码不会上屏, 详细用法见 [README_zrm2000.dict.txt](./README_zrm2000.dict.txt)
4. 仅将热键 (默认 ```Ctrl+` ```和 `F4`) 绑定到 `F1`, 因为误按到 `F1` 经常会跳转到浏览器, 且 ```Ctrl+` ```在 VSCode 中已有使用
5. 支持时间日期, 使用大写输入: `RQ, SJ, XQ`


## 参考

[Rime 双拼 + 自然码辅码 + English 混输方案](https://github.com/mutoe/rime)

[Rime Squirrel 鼠须管配置文件（朙月拼音、小鹤双拼、自然码双拼）](https://github.com/ssnhd/rime)

[rimerc: rimer 的词库和配置](https://github.com/Bambooin/rimerc)

[Rime](https://blog.isteed.cc/post/rime-2022/)
