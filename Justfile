# Install dependencies and prepare database
install:
    bundle install
    bun install
    bin/rails db:prepare

# Start development server (Rails + JS/CSS watchers)
dev:
    bin/dev

# Build JS and CSS assets
build:
    bun run build
    bun run build:css

# Run tests (builds assets first)
test *args:
    bun run build
    bun run build:css
    bundle exec rspec {{ args }}

# Lint and check (no modifications)
check:
    bundle exec rspec

# Rails console
console:
    bin/rails console

# Start Sidekiq
sidekiq:
    bin/sidekiq
