RIME_HOME := /Users/edte/Library/Rime
REPO_DIR := $(CURDIR)
SQUIRREL := /Library/Input Methods/Squirrel.app/Contents/MacOS/Squirrel
RIME_DICT_MANAGER := /Library/Input Methods/Squirrel.app/Contents/MacOS/rime_dict_manager
USER_DICT := rime_frost
TMP_SYNC_DIR := tmp
LAUNCH_AGENT_LABEL := com.edte.rime-userdb-backup
LAUNCH_AGENT_SRC := launchd/$(LAUNCH_AGENT_LABEL).plist
LAUNCH_AGENT_DST := $(HOME)/Library/LaunchAgents/$(LAUNCH_AGENT_LABEL).plist

.PHONY: all bootstrap userdb restore-userdb install-userdb-timer uninstall-userdb-timer

bootstrap: all restore-userdb

all:
	mkdir -p $(RIME_HOME)
	stow . -t $(RIME_HOME)


userdb:
	@set -e; \
	test -d "$(RIME_HOME)/$(USER_DICT).userdb"; \
	"$(SQUIRREL)" --quit || true; \
	sleep 1; \
	(cd "$(RIME_HOME)" && "$(RIME_DICT_MANAGER)" -b "$(USER_DICT)"); \
	mkdir -p "sync/current"; \
	cp "$(TMP_SYNC_DIR)/current/$(USER_DICT).userdb.txt" "sync/current/$(USER_DICT).userdb.txt"; \
	rm -f "$(TMP_SYNC_DIR)/current/$(USER_DICT).userdb.txt"; \
	rmdir "$(TMP_SYNC_DIR)/current" 2>/dev/null || true; \
	echo "wrote sync/current/$(USER_DICT).userdb.txt"

restore-userdb:
	"$(SQUIRREL)" --quit || true
	sleep 1
	@for file in sync/current/*.userdb.txt; do \
		(cd "$(RIME_HOME)" && "$(RIME_DICT_MANAGER)" -r "$(REPO_DIR)/$$file"); \
	done

install-userdb-timer:
	@set -e; \
	mkdir -p "$(HOME)/Library/LaunchAgents"; \
	plutil -lint "$(LAUNCH_AGENT_SRC)" >/dev/null; \
	launchctl bootout "gui/$$(id -u)/$(LAUNCH_AGENT_LABEL)" 2>/dev/null || true; \
	launchctl bootout "gui/$$(id -u)" "$(LAUNCH_AGENT_DST)" 2>/dev/null || true; \
	install -m 644 "$(LAUNCH_AGENT_SRC)" "$(LAUNCH_AGENT_DST)"; \
	launchctl bootstrap "gui/$$(id -u)" "$(LAUNCH_AGENT_DST)"; \
	launchctl enable "gui/$$(id -u)/$(LAUNCH_AGENT_LABEL)"; \
	echo "installed $(LAUNCH_AGENT_LABEL)"

uninstall-userdb-timer:
	@set -e; \
	launchctl bootout "gui/$$(id -u)/$(LAUNCH_AGENT_LABEL)" 2>/dev/null || true; \
	launchctl bootout "gui/$$(id -u)" "$(LAUNCH_AGENT_DST)" 2>/dev/null || true; \
	rm -f "$(LAUNCH_AGENT_DST)"; \
	echo "uninstalled $(LAUNCH_AGENT_LABEL)"
