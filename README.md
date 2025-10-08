# mise-php-docker

A mise plugin that runs PHP 8 and Composer inside Docker containers automatically.

## Prerequisites

- [mise](https://mise.jdx.dev/) installed
- Docker running locally

## Features

- **Auto-build**: Docker image builds automatically on first use
- **Unified image**: PHP and Composer use the same image (guaranteed version match)
- **Version-aware**: Reads versions from `.mise.toml` and `.tool-versions` files
- **Common extensions**: Includes PDO, MySQL, MySQLi, ZIP out of the box

## Installation

### Option 1: Install from git repository

```bash
mise plugin add mise-php-docker https://github.com/gs-crmartinez/mise-php-docker.git
```

### Option 2: Install from local path

```bash
mise plugin add mise-php-docker /path/to/mise-php-docker
```

## Usage

The Docker image builds automatically on first use (may take a few minutes).

Once installed, `php` and `composer` commands automatically run inside Docker:

```bash
php -v                    # PHP 8.x (cli)
composer -V               # Composer version
composer install
php artisan migrate
```

## Configuration

### Version-based configuration

Specify versions in `.mise.toml`:

```toml
[tools]
php = "8"
```

The plugin will use `mise-php-docker:8` Docker image for both PHP and Composer. Defaults to PHP 8 if not specified.

### Custom Docker image override

Override with a custom image (if you've built one with extra extensions):

```toml
[tools]
php = "8"

[env]
PHP_DOCKER_IMAGE = "your-registry/custom-php:8"
```

Both `php` and `composer` will use the custom image.

### Global configuration

Add to your shell config (~/.config/fish/config.fish):

```fish
set -gx PHP_DOCKER_IMAGE "mise-php-docker:8"
```

Or for Bash (~/.bashrc):

```bash
export PHP_DOCKER_IMAGE="mise-php-docker:8"
```

## How it works

The plugin provides executable shims in `bin/` that wrap Docker commands:

- `bin/php` → Auto-builds `mise-php-docker:8` if needed, then runs `docker run mise-php-docker:8 php ...`
- `bin/composer` → Auto-builds `mise-php-docker:8` if needed, then runs `docker run mise-php-docker:8 composer ...`

mise automatically adds these to your PATH when the plugin is active.

## Troubleshooting

### Commands not found

Ensure mise is properly configured:

```bash
mise doctor
```

### Rebuilding the Docker image

To rebuild manually (e.g., after modifying the Dockerfile):

```bash
docker build -t mise-php-docker:8 .
```

### Permission issues

Make sure Docker is running:

```bash
docker ps
```

### Adding more PHP extensions

Edit [Dockerfile](Dockerfile) and add extensions:

```dockerfile
RUN docker-php-ext-install gd zip bcmath
```

Then rebuild:

```bash
docker build -t mise-php-docker:8 .
```
