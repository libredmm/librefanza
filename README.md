# Librefanza

[![Rspec](https://github.com/libredmm/librefanza/workflows/Rspec/badge.svg?branch=master)](https://github.com/libredmm/librefanza/actions/workflows/rspec.yml)

A Rails application that aggregates movie metadata from multiple Japanese adult video sources (Fanza, MGStage, SOD, FC2) into a unified database with normalized product IDs.

## Setup

```bash
bin/setup
```

## Development

```bash
bin/rails server    # Start Rails server
bin/sidekiq         # Start Sidekiq for background jobs
```

## Testing

```bash
bundle exec rspec
```
