# Librefanza

[![Rspec](https://github.com/libredmm/librefanza/actions/workflows/rspec.yml/badge.svg)](https://github.com/libredmm/librefanza/actions/workflows/rspec.yml)

A Rails application that aggregates movie metadata from multiple Japanese adult video sources (Fanza, MGStage, SOD, FC2) into a unified database with normalized product IDs.

## Setup

Install Ruby matching [.ruby-version](.ruby-version), Bundler, Bun, and just. Provide PostgreSQL for the application and test databases (see [config/database.yml](config/database.yml)), and Redis for background jobs.

```bash
just install
```

## Development

```bash
just dev        # Start Rails server + JS/CSS watchers
just sidekiq    # Start Sidekiq for background jobs
just console    # Open the Rails console
just build      # Build JavaScript and CSS assets
```

## Testing

`just test` builds assets before running RSpec. PostgreSQL must be available; the suite maintains the test database schema, uses fake Sidekiq jobs, and blocks external HTTP requests through WebMock.

```bash
just test
just test spec/models/movie_spec.rb
just test spec/models/movie_spec.rb:10
```

## Configuration

Development uses dotenv. The deployment Compose file loads `.env` followed by `.env.production`. Keep real credentials out of version control.

| Variable | Purpose |
| --- | --- |
| `DATABASE_URL` | PostgreSQL connection string; otherwise Rails uses `config/database.yml`. |
| `FANZA_API_ID`, `FANZA_AFFILIATE_ID` | Credentials for Fanza API requests. |
| `PROXY_URL` | Optional HTTP proxy for MGStage, SOD, and FC2 scraping. |
| `BLACKHOLE_PATTERN` | Case-insensitive regex excluding search keywords; defaults to `^$`. |
| `MGSTAGE_SERIES_URL` | URL returning a whitespace-separated list of series for the MGStage crawler. |
| `FC2_BASE_URL` | FC2 source URL; defaults to `https://adult.contents.fc2.com/`. |

## Architecture

The application uses Rails, PostgreSQL, and Sidekiq. Bun builds JavaScript and Sass assets into `app/assets/builds/`, which Sprockets serves. Frontend dependencies include Bootstrap, Stimulus, Turbo, and ClipboardJS.

- [Movie](app/models/movie.rb) aggregates source-specific items under the `normalized_id` primary key. [Fanza::Id](app/lib/fanza/id.rb) normalizes product IDs across sources, such as `abc00123` and `ABC123` to `ABC-123`.
- Source item models share [GenericItem](app/models/concerns/generic_item.rb), which synchronizes their associated movie on save and destruction. [Derivable](app/models/concerns/derivable.rb) derives fields on creation and touch; [CoverImageOverridable](app/models/concerns/cover_image_overridable.rb) handles movie cover overrides. Page models retain scraped HTML, while `FanzaActress` stores actress metadata.
- [app/lib](app/lib) contains the Fanza API client and MGStage, SOD, and FC2 scrapers. [FanzaSearcher](app/workers/fanza_searcher.rb) searches sources in order, with an `until_executed` job lock and a separate one-day, process-local search cooldown. Forced searches bypass the cooldown.
- [config/sidekiq.yml](config/sidekiq.yml) schedules daily actress, Fanza item, and MGStage crawls. `HouseKeeper` is invoked manually.
- Clearance handles authentication; [config/routes.rb](config/routes.rb) protects administrative routes with a signed-in `is_admin?` constraint.

## Deployment

[compose.yaml](compose.yaml) runs the web application and Sidekiq using `ghcr.io/libredmm/librefanza:latest`, alongside `redis:7`. PostgreSQL must be provided separately.

On the deployment host, place `compose.yaml`, `.env`, and `.env.production` in the same directory. Configure `DATABASE_URL`, the application's API credentials, and Rails secrets in the environment files; keep these files out of version control. Then run:

```bash
docker compose pull
docker compose up -d --remove-orphans
docker compose ps
docker compose logs --tail=100 web sidekiq
```

The web service exposes port `3000` and runs `rails db:prepare` before starting Puma. Sidekiq starts independently, so database migrations must tolerate concurrent worker startup. Redis data persists in a named volume.

The [Docker workflow](.github/workflows/docker.yml) publishes images tagged `latest` and with the full commit SHA on pushes to `master`; deployment is a separate step. Tests run in a separate workflow and do not gate image publication, so verify both workflows before deploying.

To deploy a specific revision, set both application image tags in `compose.yaml` to its full commit SHA. Rolling back the image does not undo database migrations; verify schema compatibility first.
