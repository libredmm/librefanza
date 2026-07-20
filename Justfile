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

# Deploy to remote host: sync compose file, pull latest image, restart
deploy host="dockyard" dir="librefanza":
    scp docker-compose.yml {{ host }}:{{ dir }}/docker-compose.yml
    ssh {{ host }} "cd {{ dir }} && docker compose pull --quiet && docker compose up -d --remove-orphans && docker image prune -f"
    ssh {{ host }} "cd {{ dir }} && docker compose ps"
