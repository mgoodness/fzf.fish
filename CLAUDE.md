# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Commands

**Run full test suite** (requires `fishtape` installed via Fisher):
```fish
fishtape tests/*/*.fish
```

**Run a single test:**
```fish
fishtape tests/<component>/<test_name>.fish
```

**Syntax check all Fish files:**
```fish
fish_indent --check **/*.fish
```

**Format Fish files (in-place):**
```fish
fish_indent -w **/*.fish
```

**Check Markdown/YAML formatting:**
```fish
prettier --check .
```

CI runs on macOS and Ubuntu and requires `fzf` and `fd` installed via Homebrew.

## Architecture

fzf.fish is a Fish shell plugin with six independent search commands bound to keyboard shortcuts.

**Startup** (`conf.d/fzf.fish`): Loaded on interactive shell start. Sets the `_fzf_search_vars_command` variable and calls `fzf_configure_bindings` to install key bindings.

**Key bindings** (`functions/fzf_configure_bindings.fish`): Public API. Installs six bindings (defaults: `Ctrl+R` history, `Ctrl+Alt+F` files, `Ctrl+Alt+L` git log, `Ctrl+Alt+S` git status, `Ctrl+Alt+P` processes, `Ctrl+V` variables). Users override via flags. Binds for both insert and default vi modes.

**Search commands** (`functions/_fzf_search_*.fish`): Private functions (prefixed `_fzf_`) triggered by key bindings. Each:
1. Generates a candidate list (files via `fd`, commits via `git log`, history via `builtin history`, etc.)
2. Configures a preview command if applicable
3. Calls `_fzf_wrapper` with fzf arguments
4. Parses the selection and writes it to the commandline via `commandline --current-token --replace`

**Wrapper** (`functions/_fzf_wrapper.fish`): Sets sensible fzf defaults (layout, height, border, keybinds). Respects `FZF_DEFAULT_OPTS` and `FZF_DEFAULT_OPTS_FILE`.

**Preview helpers** (`functions/_fzf_preview_file.fish`, `_fzf_preview_changed_file.fish`): Called by fzf's `--preview` flag for syntax-highlighted file views and git diffs.

## Conventions

- Private functions: `_fzf_` prefix. Public functions: no prefix.
- Use `set -f` for function-local variables.
- Tests use **Fishtape** (`@test` assertions, `mock` for command mocking). Organized as `tests/<component>/<test_name>.fish`.
- Targets Fish 4.0+ keybinding syntax.
