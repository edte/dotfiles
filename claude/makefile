all:
	mv ~/.codebuddy/CODEBUDDY.md ~/.codebuddy/CODEBUDDY.md.bk
	ln -s ~/dotfiles/claude/rules.md  ~/.codebuddy/CODEBUDDY.md

	mv ~/.codex/AGENTS.md ~/.codex/AGENTS.md.bk
	ln -s ~/dotfiles/claude/rules.md ~/.codex/AGENTS.md

	mv ~/.codebuddy/mcp.json ~/.codebuddy/mcp.json.bk
	ln -s ~/dotfiles/claude/mcp.json  ~/.codebuddy/mcp.json

	mv ~/.codebuddy/settings.json ~/.codebuddy/settings.json.bk
	ln -s ~/dotfiles/claude/settings.json  ~/.codebuddy/settings.json

	mv ~/.codebuddy/.lsp.json ~/.codebuddy/.lsp.json.bk
	ln -s ~/dotfiles/claude/lsp.json  ~/.codebuddy/.lsp.json

	rm -rf ~/.codebuddy/skills
	mkdir -p ~/.codebuddy/skills
	stow skills -t ~/.codebuddy/skills
	stow skills -t ~/.codex/skills
