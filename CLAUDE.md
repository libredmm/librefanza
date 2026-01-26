# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Librefanza is a Rails 7.2 application that aggregates movie metadata from multiple Japanese adult video sources (Fanza, JAVLibrary, MGStage, SOD, FC2) into a unified database. It normalizes product IDs across sources and provides a searchable catalog.

## Common Commands

```bash
# Setup
bin/setup                    # Install dependencies and prepare database

# Development
bin/rails server             # Start Rails server
bin/sidekiq                  # Start Sidekiq for background jobs

# Testing
bundle exec rspec            # Run all tests
bundle exec rspec spec/models/movie_spec.rb  # Run single test file
bundle exec rspec spec/models/movie_spec.rb:10  # Run specific line

# Database
bin/rails db:prepare         # Create/migrate database
```

## Architecture

### Data Model

The core domain revolves around **Movies** which aggregate **Items** from different sources:

- `Movie` - Central entity with `normalized_id` as primary key. Aggregates items from all sources.
- `FanzaItem`, `JavlibraryItem`, `MgstageItem`, `SodItem`, `Fc2Item` - Source-specific items. All include `GenericItem` concern.
- `FanzaActress` - Actress entity with profile data from Fanza API.

Each source also has a corresponding `*Page` model (e.g., `JavlibraryPage`) that stores raw HTML for scraping.

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

Sidekiq workers in `app/workers/`:
- `FanzaItemCrawler` - Daily crawl of new Fanza items
- `ActressCrawler` - Daily actress profile updates
- `MgstageCrawler` - Daily MGStage crawl
- `HouseKeeper` - Cleanup tasks

Schedule defined in `config/sidekiq.yml`.

### Authentication

Uses Clearance gem. Admin-only routes are protected via `Clearance::Constraints::SignedIn` with `is_admin?` check.

## Testing

Aim for 100% line test coverage on every change.

## Environment Variables

- `FANZA_API_ID`, `FANZA_AFFILIATE_ID` - Fanza API credentials
- `PROXY_URL` - Optional HTTP proxy for external requests
- `DATABASE_URL` - PostgreSQL connection string (production)
