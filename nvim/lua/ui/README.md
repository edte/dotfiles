./ui/ 目录
用于neovim的基础UI配置：
大概结构如下：


-------------------                 bufferline  --------------------------------------------------
                    waybar(我没用)
|                   context                                                                    |
|
|         file tree
|                                                                                              | 
signbar                                                                                    scroolbar
|                                       theme                                       symbol tree| 
|
|                                                                                              | 
|
|

                                        whichkey                
----------------    ------------  statusline -----------------------     -----------------


1. bufferline，即打开的文件/buffer列表，用于切换文件/buffer
2. waybar(我没用) 
3. context, 函数上下文
4. file tree，文件目录树，显示项目结构和移动，修改
5. signbar，用于显示行号，折叠，mark信息等
6. nvim 主题
7. symbol tree，符号树，主要用于显示函数符号，快速函数切换
8. scrooltar，滚动条，显示git信息，错误信息等
9. whichkey，快捷键提示
10. statusline，状态栏，显示项目名，文件名，行号，分支，lsp状态，filetype，时间等信息



