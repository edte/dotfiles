local ls = require("luasnip")
local func = ls.function_node
local postfix = require("luasnip.extras.postfix").postfix
local snip = ls.snippet
local text = ls.text_node
local insert = ls.insert_node
local func = ls.function_node
local choice = ls.choice_node
local dynamic = ls.dynamic_node
local events = require("luasnip.util.events")
local snip_node = ls.snippet_node
local lsp_format = vim.lsp.buf.format
local session = require("luasnip.session")

local env = session.config.snip_env
local s = env["s"]
local t = env["t"]
local i = env["i"]
local parse = env["parse"]

local function string_split(s, delimter)
  local result = {}
  for match in (s .. delimter):gmatch("(.-)" .. delimter) do
    table.insert(result, match)
  end
  return result
end

local M = {
  ----------------------------------------------------------------- 后缀补全------------------------------------------------------------------------------
  -- 使用 := 将表达式分配给新变量。
  postfix(".var", {
    func(function(_, snip)
      return "i := " .. snip.snippet.env.POSTFIX_MATCH .. ""
    end, {}),
  }),

  -- len
  postfix(".len", {
    func(function(_, snip)
      return "len(" .. snip.snippet.env.POSTFIX_MATCH .. ")"
    end, {}),
  }),

  -- Creates a copy of a slice with a range of elements removed.
  postfix(".remove", {
    func(function(_, snip)
      return snip.snippet.env.POSTFIX_MATCH
          .. " = append("
          .. snip.snippet.env.POSTFIX_MATCH
          .. "[:1], "
          .. snip.snippet.env.POSTFIX_MATCH
          .. "[2:]...)"
    end, {}),
  }),

  postfix(".apend", {
    func(function(_, snip)
      return "append(" .. snip.snippet.env.POSTFIX_MATCH .. ", "
    end, {}),
    insert(1),
    text({ ")" }),
  }),

  postfix(".append", {
    func(function(_, snip)
      return snip.snippet.env.POSTFIX_MATCH .. " = append(" .. snip.snippet.env.POSTFIX_MATCH .. ", "
    end, {}),
    insert(1),
    text({ ")" }),
  }),

  postfix(".appendAssign", {
    func(function(_, snip)
      return snip.snippet.env.POSTFIX_MATCH .. " = append(" .. snip.snippet.env.POSTFIX_MATCH .. ", "
    end, {}),
    insert(1),
    text({ ")" }),
  }),

  -- Generates the code to parse int from string.
  postfix(".parseint", {
    func(function(_, snip)
      return "value, err := strconv.ParseInt(" .. snip.snippet.env.POSTFIX_MATCH .. ", 10, 64)"
    end, {}),
  }),

  -- Generates the code to parse int from string.
  postfix(".stoi", {
    func(function(_, snip)
      return "value, err := strconv.ParseInt(" .. snip.snippet.env.POSTFIX_MATCH .. ", 10, 64)"
    end, {}),
  }),

  -- Generates the code to parse int from string.
  postfix(".stof", {
    func(function(_, snip)
      return "value, err := strconv.ParseFloat(" .. snip.snippet.env.POSTFIX_MATCH .. ", 10, 64)"
    end, {}),
  }),

  -- Generates the code to parse float from string.
  postfix(".parsefloat", {
    func(function(_, snip)
      return "value, err := strconv.ParseFloat(" .. snip.snippet.env.POSTFIX_MATCH .. ", 10, 64)"
    end, {}),
  }),

  postfix(".imag", {
    func(function(_, snip)
      return "imga(" .. snip.snippet.env.POSTFIX_MATCH .. ")"
    end, {}),
  }),

  postfix(".panic", {
    func(function(_, snip)
      return "panic(" .. snip.snippet.env.POSTFIX_MATCH .. ")"
    end, {}),
  }),

  postfix(".complex", {
    func(function(_, snip)
      return "complex(" .. snip.snippet.env.POSTFIX_MATCH .. ")"
    end, {}),
  }),

  postfix(".real", {
    func(function(_, snip)
      return "real(" .. snip.snippet.env.POSTFIX_MATCH .. ")"
    end, {}),
  }),

  postfix(".return", {
    func(function(_, snip)
      return "return " .. snip.snippet.env.POSTFIX_MATCH .. ""
    end, {}),
  }),

  postfix(".copy", {
    func(function(_, snip)
      return "copy(" .. snip.snippet.env.POSTFIX_MATCH .. ", )"
    end, {}),
  }),

  postfix(".make", {
    func(function(_, snip)
      return "make(" .. snip.snippet.env.POSTFIX_MATCH .. ", )"
    end, {}),
  }),

  postfix(".close", {
    func(function(_, snip)
      return "close(" .. snip.snippet.env.POSTFIX_MATCH .. ")"
    end, {}),
  }),

  postfix(".cap", {
    func(function(_, snip)
      return "cap(" .. snip.snippet.env.POSTFIX_MATCH .. ")"
    end, {}),
  }),

  postfix(".println", {
    func(function(_, snip)
      return "fmt.Println(" .. snip.snippet.env.POSTFIX_MATCH .. ")"
    end, {}),
  }),

  postfix(".printf", {
    func(function(_, snip)
      return 'fmt.Printf("%+v", ' .. snip.snippet.env.POSTFIX_MATCH .. ")"
    end, {}),
  }),

  postfix(".is", {
    func(function(_, snip)
      return "errors.Is(" .. snip.snippet.env.POSTFIX_MATCH .. ")"
    end, {}),
  }),

  postfix(".as", {
    func(function(_, snip)
      return "errors.As(" .. snip.snippet.env.POSTFIX_MATCH .. ")"
    end, {}),
  }),

  -- Turns the E expression into if E {}.
  postfix(".if", {
    func(function(_, snip)
      return "if " .. snip.snippet.env.POSTFIX_MATCH .. " { "
    end, {}),
    text({ "", "" }),
    text("\t"),
    insert(1),
    text({ "", "" }),
    text({ "}" }),
  }),

  -- Turns the E expression into if !E {}.
  postfix(".else", {
    func(function(_, snip)
      return "if !" .. snip.snippet.env.POSTFIX_MATCH .. " { "
    end, {}),
    text({ "", "" }),
    text("\t"),
    insert(1),
    text({ "", "" }),
    text({ "}" }),
  }),

  -- Creates the range form of the for loop with an index and a value to iterate over a slice or an array.
  postfix(".forr", {
    func(function(_, snip)
      return "for k, v := range " .. snip.snippet.env.POSTFIX_MATCH .. " { "
    end, {}),
    text({ "", "" }),
    text("\t"),
    insert(1),
    text({ "", "" }),
    text({ "}" }),
  }),

  -- Creates the range form of the for loop to iterate over a slice or an array
  postfix(".for", {
    func(function(_, snip)
      return "for i := range " .. snip.snippet.env.POSTFIX_MATCH .. " { "
    end, {}),
    text({ "", "" }),
    text("\t"),
    insert(1),
    text({ "", "" }),
    text({ "}" }),
  }),

  -- Wraps the expression with the sort.Float64s() function.
  postfix(".sort", {
    func(function(_, snip)
      return "sort.Float64s(" .. snip.snippet.env.POSTFIX_MATCH .. ")"
    end, {}),
  }),

  -- Wraps the expression with the sort.Ints() function.
  postfix(".sort", {
    func(function(_, snip)
      return "sort.Ints(" .. snip.snippet.env.POSTFIX_MATCH .. ")"
    end, {}),
  }),

  -- Wraps the expression with the sort.Strings() function.
  postfix(".sort", {
    func(function(_, snip)
      return "sort.Strings(" .. snip.snippet.env.POSTFIX_MATCH .. ")"
    end, {}),
  }),

  -- Wraps the expression with the sort.Slice() function.
  postfix(".sort", {
    func(function(_, snip)
      return "sort.Slice(" .. snip.snippet.env.POSTFIX_MATCH .. ", func(i, j int) bool {"
    end, {}),
    text({ "", "" }),
    text({ "    return false " }),
    text({ "", "" }),
    text({ "})" }),
  }),

  postfix(".nn", {
    func(function(_, snip)
      return "if " .. snip.snippet.env.POSTFIX_MATCH .. " != nil {"
    end, {}),
    text({ "", "" }),
    text({ "}" }),
  }),

  postfix(".nil", {
    func(function(_, snip)
      return "if " .. snip.snippet.env.POSTFIX_MATCH .. " == nil {"
    end, {}),
    text({ "", "" }),
    text({ "}" }),
  }),

  -- Generates boilerplate code for idiomatic error handling.
  postfix(".rr", {
    text({ "if err != nil {", "" }), -- if condition {
    text("\t"),
    text({ "return err", "" }),
    text("}"),
    insert(0),
  }),

  ---------------------------------------------------templates------------------------------------------------------------------
  snip({
    trig = "main",
    docstring = "func main(){\n}",
    dscr = "生成main函数",
  }, {
    text({ "func main(){", "" }),
    text({ "}" }),
  }, {
    callbacks = {
      [0] = {
        [events.enter] = function(node, _event_args)
          lsp_format({
            filter = function(client)
              return client.name == "null-ls"
            end,
          })
        end,
      },
    },
  }),

  ------------------------------------------------
  ----     Type  Keyword
  ------------------------------------------------
  snip({
    trig = "typ",
    docstring =
    "////Press to <C-s> trigger \ntype Name struct{\n\tField\tType\n}\n\n////or type Name interface{\n\tMethod\n}",
    dscr = "创建一个结构体/接口",
  }, {
    choice(1, {
      snip_node(nil, {
        func(function(args, snip, _)
          return "// " .. args[1][1] .. " represent " .. string.lower(args[1][1])
        end, { 1 }, nil),
        text({ "", "" }),
        text({ "type " }),
        insert(1, "Name"),
        text({ " struct {", "" }), -- type Name interface{
        text("\t"),
        insert(2, "Field"),
        text("\t"),
        insert(3, "Type"),
        text({ "", "}" }),
        insert(0),
      }),
      snip_node(nil, {
        func(function(args, snip, _)
          return "// " .. args[1][1] .. " represent " .. string.lower(args[1][1])
        end, { 1 }, nil),
        text({ "", "" }),
        text({ "type " }),
        insert(1, "Name"),
        text({ " interface {", "" }), -- type Name interface{
        text("\t"),
        insert(2, "Method"),
        text({ "", "}" }),
        insert(0),
      }),
    }),
  }, {
    callbacks = {
      [0] = {
        [events.enter] = function(node, _event_args)
          lsp_format({
            filter = function(client)
              return client.name == "null-ls"
            end,
          })
        end,
      },
    },
  }),

  -- type Name struct {}
  snip({
    trig = "typs",
    docstring = "type Name struct{\n\tField\tType\n}",
    dscr = "生成一个结构体",
  }, {
    func(function(args, snip, _)
      return "// " .. args[1][1] .. " represent " .. string.lower(args[1][1])
    end, { 1 }, nil),
    text({ "", "" }),
    text({ "type " }),
    insert(1, "Name"),
    text({ " struct {", "" }), -- type Name interface{
    text("\t"),
    insert(2, "Field"),
    text("\t"),
    insert(3, "Type"),
    text({ "", "}" }),
    insert(0),
  }, {
    callbacks = {
      [0] = {
        [events.enter] = function(node, _event_args)
          lsp_format({
            filter = function(client)
              return client.name == "null-ls"
            end,
          })
        end,
      },
    },
  }),

  -- type Name interface{}
  snip({
    trig = "typi",
    docstring = "type Name interface{\n\tMethod\n}",
    dscr = "生成一个接口",
  }, {
    func(function(args, snip, _)
      return "// " .. args[1][1] .. " represent " .. string.lower(args[1][1])
    end, { 1 }, nil),
    text({ "", "" }),
    text({ "type " }),
    insert(1, "Name"),
    text({ " interface {", "" }), -- type Name interface{
    text("\t"),
    insert(2, "Method"),
    text({ "", "}" }),
    insert(0),
  }, {
    callbacks = {
      [0] = {
        [events.enter] = function(node, _event_args)
          lsp_format({
            filter = function(client)
              return client.name == "null-ls"
            end,
          })
        end,
      },
    },
  }),

  ------------------------------------------------
  ----     Struct Method
  ------------------------------------------------
  -- func(obj *Obj)FuncName(args..)(rets...){}
  snip({
    trig = "methodptr",
    docstring =
    '//this is example struct\ntype Example struct{\n}\n\n//following code will be autogenerated \n//Example cometrue MethodName\nfunc(example *Example) MethodName(Params...)(Rets...){\n\tpanic("unimplemented")\n}',
    dscr = "生成一个结构体方法(方法接收类型为指针)",
  }, {
    func(function(args, snip, _)
      return "// " .. args[1][1] .. " [#TODO](should add some comments)"
    end, { 2 }, nil),
    text({ "", "" }),
    text({ "func (" }),
    func(function(args, snip, user_arg_1)
      local lowstr = string.lower(args[1][1])
      return string.sub(lowstr, 1, 1) .. " *"
    end, { 1 }, nil),
    insert(1, "Name"),
    text(") "),
    insert(2, "MethodName"),
    text({ "(" }),
    insert(3, "Args..."),
    text(")("),
    insert(4, "Rets"),
    text({ "){", "" }), -- func (c *Cat)Name(aegs)(){
    text({ '\tpanic("unimplemented")' }),
    text({ "", "" }),
    text("}"),
    insert(0),
  }, {
    callbacks = {
      [0] = {
        [events.enter] = function(node, _event_args)
          lsp_format({
            filter = function(client)
              return client.name == "null-ls"
            end,
          })
        end,
      },
    },
  }),

  snip({
    trig = "methodstruct",
    docstring =
    '// this is example struct \ntype Example struct{\n}\n\n//following code will be autogenerated \n//Example cometrue MethodName\nfunc(example Example) MethodName(Params...)(Rets...){\n\tpanic("unimplemented")\n}',
    dscr = "生成一个结构体方法(方法接收类型为值类型)",
  }, {
    func(function(args, snip, _)
      return "// " .. args[1][1] .. " [#TODO](should add some comments)"
    end, { 2 }, nil),
    text({ "", "" }),
    text({ "func (" }),
    func(function(args, snip, user_arg_1)
      local lowstr = string.lower(args[1][1])
      return string.sub(lowstr, 1, 1) .. " "
    end, { 1 }, nil),
    insert(1, "Name"),
    text(") "),
    insert(2, "MethodName"),
    text({ "(" }),
    insert(3, "Params..."),
    text(")("),
    insert(4, "Rets..."),
    text({ "){" }), -- func (c *Cat)Name(aegs)(){
    text({ "", '\tpanic("unimplemented")' }),
    text({ "", "" }),
    text("}"),
    insert(0),
  }, {
    callbacks = {
      [0] = {
        [events.enter] = function(node, _event_args)
          lsp_format({
            filter = function(client)
              return client.name == "null-ls"
            end,
          })
        end,
      },
    },
  }),

  -- impl
  snip({
    trig = "impl",
    docstring =
    '//example interface \ntype Animal interface{\n\tEat()\n}\n\n//example struct\ntype Cat struct{\n}\n\n//the following code will be auto generator \n\nvar _ Animal = new(Cat)\n\n// following code will be autogenerated\nfunc (*Cat) Eat(){\n\tpanic("unimplemented")\n}',
    dscr = "判断结构体是否实现了某种方法(没有实现会自动触发codeaction来实现)",
  }, {
    text({ "var _ " }),
    insert(1, "ImplName"),
    text(" = new("),
    insert(2, "StructName"),
    text({ ")" }),
    insert(0),
  }, {
    callbacks = {
      [0] = {
        [events.enter] = function(node, _event_args)
          vim.lsp.buf.code_action()
          lsp_format({
            filter = function(client)
              return client.name == "null-ls"
            end,
          })
        end,
      },
    },
  }),

  -- function  with no return
  snip({
    trig = "funtest",
    docstring = 'func TestFuncName(t *testing.T){\n\tpanic("unimplemented")\n}',
    dscr = "func语句,生成测试函数",
  }, {
    text("func Test"),
    insert(1, "FuncName"),
    text({ "(t *testing.T){", "" }),
    text("\t"),
    text({ 'panic("unimplemented")', "" }),
    text("}"),
    insert(0),
  }, {
    callbacks = {
      [0] = {
        [events.enter] = function(node, _event_args)
          lsp_format({
            filter = function(client)
              return client.name == "null-ls"
            end,
          })
        end,
      },
    },
  }),

  -- ##############################################################################
  -- #                    Function Snippet Code                                   #
  -- ##############################################################################
  snip({
    trig = "funerr",
    docstring = 'func FuncName(Params...) error {\n\tpanic("unimplemented")\n\treturn nil\n}',
    dscr = "func语句,生成一个函数,函数返回值为error类型",
  }, {
    text("func "),
    insert(1, "FuncName"),
    text("("),
    insert(2, "Params..."),
    text(")"),
    insert(3, " error"),
    text({ "{", "" }),
    text("\t"),
    text({ "return nil", "" }),
    text("}"),
    insert(0),
  }, {
    callbacks = {
      [0] = {
        [events.enter] = function(node, _event_args)
          lsp_format({
            filter = function(client)
              return client.name == "null-ls"
            end,
          })
        end,
      },
    },
  }),

  -- function  with return
  snip({
    trig = "funclosure",
    docstring = ' func (Params...)(Rets...){\n\tpanic("unimplemented")\n}',
    dscr = "定义一个值的类型是函数的变量",
  }, {
    text(" func "),
    text("("),
    insert(1, "Params..."),
    text(")("),
    insert(2, "Rets..."),
    text({ "){", "" }),
    text("\t"),
    text({ 'panic("unimplemented")', "" }),
    text("}"),
    insert(0),
  }, {
    callbacks = {
      [0] = {
        [events.enter] = function(node, _event_args)
          lsp_format({
            filter = function(client)
              return client.name == "null-ls"
            end,
          })
        end,
      },
    },
  }),

  -- function  with return
  snip({
    trig = "funret",
    docstring = 'func FuncName(Params...)(Rets...){\n\tpanic("unimplemented")\n}',
    dscr = "func语句,函数有返回值",
  }, {
    text("func "),
    insert(1, "FuncName"),
    text("("),
    insert(2, "Params..."),
    text(")("),
    insert(3, "Rets..."),
    text({ "){", "" }),
    text("\t"),
    text({ 'panic("unimplemented")', "" }),
    text("}"),
    insert(0),
  }, {
    callbacks = {
      [0] = {
        [events.enter] = function(node, _event_args)
          lsp_format({
            filter = function(client)
              return client.name == "null-ls"
            end,
          })
        end,
      },
    },
  }),

  -- function  with no return
  snip({
    trig = "funnil",
    docstring = 'func FuncName(Params ...){\n\tpanic("unimplemented")\n}',
    dscr = "func语句, 函数返回值为空(没有返回值)",
  }, {
    text("func "),
    insert(1, "FuncName"),
    text("("),
    insert(2, "Params..."),
    text({ "){", "" }),
    text("\t"),
    text({ 'panic("unimplemented")', "" }),
    text("}"),
    insert(0),
  }, {
    callbacks = {
      [0] = {
        [events.enter] = function(node, _event_args)
          lsp_format({
            filter = function(client)
              return client.name == "null-ls"
            end,
          })
        end,
      },
    },
  }),

  snip({
    trig = "gofunc",
    docstring = 'go func(){\n\tpanic("unimplemented")\n}',
    dscr = "go func语句",
  }, {
    text({ "go func(){", "" }),
    text("\t"),
    text({ 'panic("unimplemented")', "" }),
    text({ "}()", "" }),
    insert(0),
  }, {
    callbacks = {
      [0] = {
        [events.enter] = function(node, _event_args)
          lsp_format({
            filter = function(client)
              return client.name == "null-ls"
            end,
          })
        end,
      },
    },
  }),

  -- for condition {}
  snip({
    trig = "forcondition",
    docstring = 'for condition {\n\tpanic("unimplemented")\n}',
    dscr = "for语句,条件满足则继续执行,条件不满足则跳出循环",
  }, {
    text("for "),
    insert(1, "condition"),
    text({ " {", "" }),
    text("\t"),
    insert(2, 'panic("unimplemented")'),
    text({ "", "" }),
    text("}"),
    insert(0),
  }, {
    callbacks = {
      [0] = {
        [events.enter] = function(node, _event_args)
          lsp_format({
            filter = function(client)
              return client.name == "null-ls"
            end,
          })
        end,
      },
    },
  }),

  -- for true {}
  snip({
    trig = "fortrue",
    docstring = 'for {\n\tpanic("unimplemented")\n}',
    dscr = "for语句,无限循环",
  }, {
    text({ "for {", "" }),
    text("\t"),
    insert(1, 'panic("unimplemented")'),
    text({ "", "" }),
    text("}"),
    insert(0),
  }, {
    callbacks = {
      [0] = {
        [events.enter] = function(node, _event_args)
          lsp_format({
            filter = function(client)
              return client.name == "null-ls"
            end,
          })
        end,
      },
    },
  }),

  ------------------------------------------------
  ----      If Statement
  ------------------------------------------------
  snip({
    trig = "ifcondition",
    docstring = 'if condition {\n\tpanic("unimplemented")\n}',
    dscr = "if语句,如果条件满足则执行",
  }, {
    text("if "),
    insert(1, "condition"),
    text({ " {", "" }), -- if condition {
    text("\t"),
    insert(2, 'panic("unimplemented")'),
    text({ "", "" }),
    text("}"),
    insert(0),
  }, {
    callbacks = {
      [0] = {
        [events.enter] = function(node, _event_args)
          lsp_format({
            filter = function(client)
              return client.name == "null-ls"
            end,
          })
        end,
      },
    },
  }),

  snip({
    trig = "iferr",
    docstring = "if err!= nil {\n\treturn err\n}",
    dscr = "if语句, error不为空执行",
  }, {
    text({ "if err != nil {", "" }), -- if condition {
    text("\t"),
    text({ "return err", "" }),
    text("}"),
    insert(0),
  }, {
    callbacks = {
      [0] = {
        [events.enter] = function(node, _event_args)
          lsp_format({
            filter = function(client)
              return client.name == "null-ls"
            end,
          })
        end,
      },
    },
  }),

  snip({
    trig = "ifnil",
    docstring = 'if !condition {\n\tpanic("unimplemented")\n}',
    dscr = "if语句, 当条件不满足时候执行",
  }, {
    text("if !"),
    insert(1, "condition"),
    text({ " {", "" }), -- if condition {
    text("\t"),
    insert(2, 'panic("unimplemented")'),
    text({ "", "" }),
    text("}"),
    insert(0),
  }, {
    callbacks = {
      [0] = {
        [events.enter] = function(node, _event_args)
          lsp_format({
            filter = function(client)
              return client.name == "null-ls"
            end,
          })
        end,
      },
    },
  }),

  snip({
    trig = "ifelse",
    docstring = 'if condition {\n\tpanic("unimplemented")\n}',
    dscr = "if else条件语句",
  }, {
    text("if "),
    insert(1, "condition"),
    text({ " {", "" }), -- if condition {
    text("\t"),
    insert(2, 'panic("unimplemented")'),
    text({ "", "" }),
    text({ "} else {", "" }),
    text("\t"),
    insert(3, 'panic("unimplemented")'),
    text({ "", "" }),
    text("}"),
    insert(0),
  }, {
    callbacks = {
      [0] = {
        [events.enter] = function(node, _event_args)
          lsp_format({
            filter = function(client)
              return client.name == "null-ls"
            end,
          })
        end,
      },
    },
  }),

  -- if debug
  snip({
    trig = "ifdebug",
    docstring = 'var debug = true\nif debug {\n\tpanic("unimplemented")\n} else {\n\t panic("unimplemented")\n}',
    dscr = "if语句,带debug条件",
  }, {
    text({ "var debug = true", "" }),
    text({ "if debug {", "" }),
    text("\t"),
    insert(1, 'panic("unimplemented")'),
    text({ "", "" }),
    text({ "} else {", "" }),
    text("\t"),
    insert(2, 'panic("unimplemented")'),
    text({ "", "" }),
    text("}"),
    insert(0),
  }, {
    callbacks = {
      [0] = {
        [events.enter] = function(node, _event_args)
          lsp_format({
            filter = function(client)
              return client.name == "null-ls"
            end,
          })
        end,
      },
    },
  }),

  -- select
  snip({
    trig = "select",
    docstring = 'select{\ncase caseCondition:\n\tpanic("unimplemented")\ndefault:\n\tpanic("unimplemented")',
    dscr = "select语句",
  }, {
    text({ "select {", "" }),
    text("case "),
    insert(1, "caseCondition"),
    text({ ":", "" }),
    text("\t"),
    text('panic("unimplemented")'),
    text({ "", "" }),
    text({ "default:", "" }),
    text("\t"),
    text('panic("unimplemented")'),
    text({ "", "" }),
    text("}"),
    insert(0),
  }, {
    callbacks = {
      [0] = {
        [events.enter] = function(node, _event_args)
          lsp_format({
            filter = function(client)
              return client.name == "null-ls"
            end,
          })
        end,
      },
    },
  }),

  -- switch
  snip({
    trig = "switch",
    docstring = 'switch Type {\ncase CaseStatement:\n\tpanic("unimplemented")\ndefault:\n\tpanic("unimplemented")\n}',
    dscr = "switch语句",
  }, {
    text("switch "),
    insert(1, "Type"),
    text({ " {", "" }),
    text("case "),
    insert(2, "CaseStatement"),
    text({ " :", "" }),
    text("\t"),
    text('panic("unimplemented")'),
    text({ "", "" }),
    text({ "default:", "" }),
    text("\t"),
    text('panic("unimplemented")'),
    text({ "", "" }),
    text("}"),
    insert(0),
  }, {
    callbacks = {
      [0] = {
        [events.enter] = function(node, _event_args)
          lsp_format({
            filter = function(client)
              return client.name == "null-ls"
            end,
          })
        end,
      },
    },
  }),

  s({ trig = "co", name = "Constant", dscr = "Insert a constant" }, {
    t("const "),
    i(1, "name"),
    t(" = "),
    i(2, "value"),
  }),

  s({ trig = "pf", name = "Formatted Print", dscr = "Insert a formatted print statement" }, {
    t('fmt.Printf("%#v\\n", '),
    i(1, "value"),
    t(")"),
  }),

  parse(
    { trig = "ife", name = "If Err", dscr = "Insert a basic if err not nil statement" },
    [[
  if err != nil {
    return err
  }
  ]]
  ),

  parse(
    { trig = "ifel", name = "If Err Log Fatal", dscr = "Insert a basic if err not nil statement with log.Fatal" },
    [[
  if err != nil {
    log.Fatal(err)
  }
  ]]
  ),

  s({ trig = "ifew", name = "If Err Wrapped", dscr = "Insert a if err not nil statement with wrapped error" }, {
    t("if err != nil {"),
    t({ "", '  return fmt.Errorf("failed to ' }),
    i(1, "message"),
    t(': %w", err)'),
    t({ "", "}" }),
  }),

  parse(
    { trig = "ma", name = "Main Package", dscr = "Basic main package structure" },
    [[
  package main

  import "fmt"

  func main() {
    fmt.Printf("%+v\n", "...")
  }
  ]]
  ),
}

return M
