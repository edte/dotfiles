//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
// map keyamp
api.map('h', 'E');
api.map('l', 'R');

api.map("t","T");
api.map("w","T");
//api.map("o","t");
//api.map('o','og'); 
api.map("ot","T");

api.map('sv','<Ctrl-p>');
//api.map('s','sg');
//api.map("s","T");

api.map('J', 'E'); // tab向左
api.map('K', 'R'); // tab向右

// save original function of zo into zt
api.map('zt', 'zo');
// use zo to replace zi
api.map('zo','zi');
// use zi to replace zt, which is the original function of zo
api.map('zi','zt');

api.map('on','oh');

// optional, clean zt
api.unmap('zt')

api.map('oo','gn')

api.map('H', 'S');
api.map('L', 'D');
api.map('F', 'af');

api.map('p', '<Ctrl-6>');
api.map('<tab>', '<Ctrl-6>');

api.map('e', ';U');      // Edit current URL, and open in same tab
api.map('E', ';u');      // Edit current URL, and open in new tab


// Open Chrome Flags
api.mapkey('gF', '#12Open Chrome Flags', () => { tabOpenLink("chrome://flags/"); });

//api.Hints.setCharacters('asdgyuiopqwertnmzxcvb');

api.addSearchAlias('m', 'music', 'https://music.woa.com/search/?keyword=', 's');
api.addSearchAlias('w', 'git', 'https://git.woa.com/search?search=', 's');
api.addSearchAlias('i', 'iwiki', 'https://so.woa.com/#/search?source=iwiki&query=', 's');
api.addSearchAlias('k', 'km', 'https://so.woa.com/#/search?source=kmp&query=', 's');



//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
// unmap keyamp

api.unmap('<Ctrl-j>');
api.iunmap('<Ctrl-j>');
api.vunmap('<Ctrl-j>');

// api.unmap('E');
api.unmap('R');
api.unmap('B');
api.unmap('S');
api.unmap('D');
//api.unmap('w');
api.unmap('C');
api.unmap(":");
api.unmap("<Alt-i>");
api.unmap("<Alt-s>");

api.unmap("cf");
api.unmap("gf");
api.unmap("[[");
api.unmap("]]");
api.unmap(";fs");
api.unmap(";m");
api.unmap("af");
api.unmap("<Ctrl-h>");

api.unmap("<Alt-p>");
api.unmap("<Alt-m>");

// rename tab
api.map('aa', ":document.title=prompt ('new tab name')");


//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
// general
enableAutoFocus=false;
omnibarHistoryCacheSize=1000000;

settings.cursorAtEndOfInput	=false;
settings.digitForRepeat	=false;
settings.modeAfterYank	= "Normal";
settings.tabsThreshold=10;  // 按 T 后显示的标签页上限,超过会搜索
settings.omnibarMaxResults=10;
settings.historyMUOrder = false;//历史记录搜索，不使用默认的MU排序。MU排序太鸡肋。


//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
// theme

const hintsCss =
  "font-size: 12pt; font-family: JetBrains Mono NL, Cascadia Code, SauceCodePro Nerd Font, Consolas, Menlo, monospace; border: 0px; color: #0366d6; background: initial; background-color: #ffffff";

api.Hints.style(hintsCss);
api.Hints.style(hintsCss, "text");

settings.theme = `
.sk_theme {
  font-family: JetBrains Mono NL, Cascadia Code, SauceCodePro Nerd Font, Consolas, Menlo, monospace;
  font-size: 10pt;
  background: #ffffff;
  color: #24292f;
}
.sk_theme tbody {
  color: #ffffff;
}
.sk_theme input {
  color: #24292f;
}
.sk_theme .url {
  color: #24292f;
}
.sk_theme .annotation {
  color: #24292f;
}
.sk_theme .omnibar_highlight {
  color: #24292f;
}
.sk_theme #sk_omnibarSearchResult ul li:nth-child(odd) {
  background: #ffffff;
}
.sk_theme #sk_omnibarSearchResult ul li.focused {
  background: #0598bc;
}
#sk_status {
  left:20px;
  display:block;
  width:10%;
  min-width:200px;
  overflow:hidden;
  position:fixed;
  padding:0px;
  background-color:transparent;
}
#sk_find {
  font-size: 10pt;
}
`;
