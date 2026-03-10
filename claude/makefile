SRC        := ~/dotfiles/claude
CODEBUDDY  := ~/.codebuddy
CLAUDE     := ~/.claude
CLAUDE_INT := ~/.claude-internal
CODEX      := ~/.codex
CODEX_INT  := ~/.codex-internal

# Helper: backup existing file/symlink then create new symlink
define link
	@test -f $(2) -o -L $(2) && mv $(2) $(2).bk || true
	ln -sf $(1) $(2)
endef

# Helper: deploy skills to target directory
define deploy_skills
	rm -rf $(1)/skills
	mkdir -p $(1)/skills
	stow skills -t $(1)/skills
endef

.PHONY: all codebuddy claude claude-internal codex codex-internal clean

# ─── Default ────────────────────────────────────────────────────
all: codebuddy claude claude-internal codex codex-internal

# ─── Codebuddy ──────────────────────────────────────────────────
codebuddy:
	$(call link,$(SRC)/rules.md,$(CODEBUDDY)/CODEBUDDY.md)
	$(call link,$(SRC)/mcp.json,$(CODEBUDDY)/mcp.json)
	$(call link,$(SRC)/settings.json,$(CODEBUDDY)/settings.json)
	$(call link,$(SRC)/lsp.json,$(CODEBUDDY)/.lsp.json)
	$(call deploy_skills,$(CODEBUDDY))

# ─── Claude ─────────────────────────────────────────────────────
claude:
	$(call link,$(SRC)/rules.md,$(CLAUDE)/CLAUDE.md)
	$(call deploy_skills,$(CLAUDE))

# ─── Claude Internal ───────────────────────────────────────────
claude-internal:
	$(call link,$(SRC)/rules.md,$(CLAUDE_INT)/CLAUDE.md)
	$(call deploy_skills,$(CLAUDE_INT))

# ─── Codex ──────────────────────────────────────────────────────
codex:
	$(call link,$(SRC)/rules.md,$(CODEX)/AGENTS.md)
	$(call link,$(SRC)/codex.toml,$(CODEX)/config.toml)
	$(call deploy_skills,$(CODEX))

# ─── Codex Internal ────────────────────────────────────────────
codex-internal:
	$(call link,$(SRC)/rules.md,$(CODEX_INT)/AGENTS.md)
	$(call link,$(SRC)/codex.toml,$(CODEX_INT)/config.toml)
	$(call deploy_skills,$(CODEX_INT))

# ─── Clean backups ──────────────────────────────────────────────
clean:
	rm -f $(CODEBUDDY)/CODEBUDDY.md.bk $(CODEBUDDY)/mcp.json.bk \
	      $(CODEBUDDY)/settings.json.bk $(CODEBUDDY)/.lsp.json.bk
	rm -f $(CLAUDE)/CLAUDE.md.bk
	rm -f $(CLAUDE_INT)/CLAUDE.md.bk
	rm -f $(CODEX)/AGENTS.md.bk $(CODEX)/config.toml.bk
	rm -f $(CODEX_INT)/AGENTS.md.bk $(CODEX_INT)/config.toml.bk
