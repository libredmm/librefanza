# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Librefanza is a Rails 8.1 / Ruby 4.0 application that aggregates movie metadata from multiple Japanese adult video sources (Fanza, MGStage, SOD, FC2) into a unified database. It normalizes product IDs across sources and provides a searchable catalog.

## Common Commands

```bash
# Setup
just install                 # Install deps + prepare database

# Development
just dev                     # Start Rails server + JS/CSS watchers (via foreman)
just sidekiq                 # Start Sidekiq for background jobs
just console                 # Rails console

# Building assets
just build                   # Build JS and CSS into app/assets/builds/

# Testing
just test                    # Build assets + run all tests
just test spec/models/movie_spec.rb      # Run single test file
just test spec/models/movie_spec.rb:10   # Run specific line

```

### Asset Pipeline

Uses **Bun** for JS/CSS bundling via `jsbundling-rails` and `cssbundling-rails`. Bootstrap, Stimulus, Turbo, and ClipboardJS are npm packages (see `package.json`). Assets compile into `app/assets/builds/` and are served by Sprockets.

**Note:** Tests require pre-built assets. Use `just test` (which builds first) rather than bare `bundle exec rspec`.

**Note:** Bun 1.2+ uses text-based `bun.lock` (not binary `bun.lockb`). jsbundling-rails only auto-detects `bun.lockb`, so CI must explicitly install Bun and run `bun install`/`bun run build` rather than relying on auto-detection.

## Architecture

### Autoloading (Zeitwerk)

Files under `app/lib/` are autoloaded by Zeitwerk and must define matching constants (e.g., `app/lib/fanza/api.rb` → `Fanza::Api`). Monkey-patches that reopen existing classes (like `String`) go in `config/initializers/`, not `app/lib/`.

`config/initializers/unicode_strip.rb` — overrides `String#strip` to handle fullwidth Unicode whitespace (`\u3000`), which Ruby's built-in `strip` does not. Required for scraping Japanese content.

### Data Model

The core domain revolves around **Movies** which aggregate **Items** from different sources:

- `Movie` - Central entity with `normalized_id` as primary key. Aggregates items from all sources.
- `FanzaItem`, `MgstageItem`, `SodItem`, `Fc2Item`, `JavlibraryItem` - Source-specific items. All include `GenericItem` concern.
- `FanzaActress` - Actress entity with profile data from Fanza API.

Each source also has a corresponding `*Page` model (e.g., `MgstagePage`) that stores raw HTML for scraping.

### Key Concerns

- `GenericItem` (`app/models/concerns/generic_item.rb`) - Shared behavior for all item types. Defines the item interface (title, cover_image_url, actresses, etc.) and auto-creates/updates Movies on save.
- `Derivable` (`app/models/concerns/derivable.rb`) - Auto-derives fields before validation on create. Models implement `derive_fields` to compute dependent attributes.
- `CoverImageOverridable` - Allows manual cover image overrides.

### ID Normalization

`Fanza::Id` (`app/lib/fanza/id.rb`) normalizes product IDs across sources (e.g., "abc00123", "ABC-123", "ABC123" all become "ABC-123"). This enables matching items from different sources to the same Movie.

### External APIs

Located in `app/lib/`:
- `Fanza::Api` - Official DMM API for item and actress search
- `Mgstage::Api`, `Sod::Api`, `Fc2::Api` - Web scrapers for respective sites

### Background Jobs

Sidekiq 8 workers in `app/workers/`:
- `FanzaSearcher` - Searches for items across sources. Uses `until_executed` lock with 1-day cooldown for normal searches. Force searches bypass cooldown.
- `FanzaItemCrawler` - Daily crawl of new Fanza items
- `ActressCrawler` - Daily actress profile updates
- `MgstageCrawler` - Daily MGStage crawl
- `HouseKeeper` - Cleanup tasks (manually triggered, not scheduled)

Schedule defined in `config/sidekiq.yml`.

**Note:** Sidekiq 8 requires native JSON types for job arguments. Use string keys (`{ "force" => true }`) not symbols (`force: true`).

**Testing:** Uses `Sidekiq.testing!(:fake)` (new Sidekiq 8 API). Do not use the deprecated `require "sidekiq/testing"`.

### Authentication

Uses Clearance gem. Admin-only routes are protected via `Clearance::Constraints::SignedIn` with `is_admin?` check.

## Testing

Aim for 100% line test coverage on every change.

## Environment Variables

- `FANZA_API_ID`, `FANZA_AFFILIATE_ID` - Fanza API credentials
- `PROXY_URL` - Optional HTTP proxy for external requests
- `DATABASE_URL` - PostgreSQL connection string (production)
- `BLACKHOLE_PATTERN` - Regex to filter out keywords in FanzaSearcher (optional, defaults to `^$`)
- `MGSTAGE_SERIES_URL` - URL providing list of MGStage series to crawl
- `FC2_BASE_URL` - FC2 base URL (optional, defaults to `https://adult.contents.fc2.com/`)
