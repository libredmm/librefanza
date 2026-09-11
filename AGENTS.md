# AGENTS.md

Read [README.md](README.md) for setup, commands, configuration, architecture, and deployment. Keep contributor and operator documentation there; keep this file focused on coding-agent rules. Both files are public: exclude private hostnames, infrastructure layout, credentials, and tooling that is unavailable from this repository.

## Editing

- Match constants to paths under `app/lib/` for Zeitwerk autoloading. Put patches that reopen existing classes in `config/initializers/`, not `app/lib/`.
- Preserve the Unicode whitespace handling in `config/initializers/unicode_strip.rb`; scraping relies on stripping fullwidth spaces (`\u3000`).
- Pass native JSON values to Sidekiq jobs, including string-keyed option hashes such as `{ "force" => true }`.

## Validation

- Use `just test` so assets are built before RSpec. It accepts a spec path and optional line number; see the README for examples. Aim for 100% line coverage on changes.
- Retain `Sidekiq.testing!(:fake)` in `spec/spec_helper.rb`; do not replace it with the deprecated `require "sidekiq/testing"`. Stub external HTTP requests with WebMock.
- Preserve explicit Bun installation and asset builds in CI. The locked `jsbundling-rails` recognizes `bun.lockb`, but not `bun.lock`, when selecting a package manager; it can fall back to Bun on `PATH`.
