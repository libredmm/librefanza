# Librefanza

[![Rspec](https://github.com/libredmm/librefanza/actions/workflows/rspec.yml/badge.svg)](https://github.com/libredmm/librefanza/actions/workflows/rspec.yml)

A Rails application that aggregates movie metadata from multiple Japanese adult video sources (Fanza, MGStage, SOD, FC2) into a unified database with normalized product IDs.

## Setup

```bash
just install
```

## Development

```bash
just dev        # Start Rails server + JS/CSS watchers
just sidekiq    # Start Sidekiq for background jobs
```

## Testing

```bash
just test
```
