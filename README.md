# mise-insided-plugin

A mise plugin that runs PHP 7.4 and Composer (v2.2) inside Docker containers automatically.

## Installation

### Option 1: Install from local path

```bash
mise plugin add mise-insided-plugin /Users/cristian.martinez/insided/dev/mise-insided-plugin
```

### Option 2: Install from git repository (once published)

```bash
mise plugin add mise-insided-plugin https://github.com/your-org/mise-insided-plugin.git
```

## Usage

Once installed, `php` and `composer` commands will automatically run inside Docker:

```bash
php -v                    # PHP 7.4.x (cli)
composer -V               # Composer version 2.2.x
composer install
php artisan migrate
```

## Configuration

### Version-based configuration (recommended)

Specify versions in `.mise.toml` and the plugin will automatically use the corresponding Docker images:

```toml
[tools]
php = "7.4"
composer = "2.2"
```

This will use `php:7.4-cli` and `composer:2.2` Docker images.

### Custom Docker image overrides

Override the default Docker images using environment variables in `.mise.toml`:

```toml
[tools]
php = "7.4"
composer = "2.2"

[env]
PHP_DOCKER_IMAGE = "php:7.4-cli-alpine"
COMPOSER_DOCKER_IMAGE = "composer:2.2"
```

### Global configuration

Add to your shell config (~/.config/fish/config.fish or ~/.bashrc):

```bash
export PHP_DOCKER_IMAGE="php:7.4-cli"
export COMPOSER_DOCKER_IMAGE="composer:2.2"
```

## Features

- **Version-aware**: Reads versions from `.mise.toml` automatically
- **Automatic Docker execution**: No need for manual aliases
- **PHP support**: Any PHP version available in Docker Hub
- **Composer support**: Any Composer version available in Docker Hub
- **Volume mounting**: Current directory automatically mounted to `/app`
- **Interactive & non-interactive modes**: Works with both CLI and scripts

## Requirements

- [mise](https://mise.jdx.dev/) installed
- Docker running locally

## How it works

The plugin provides executable shims in `bin/` that wrap Docker commands:

- `bin/php` → `docker run php:7.4-cli php ...`
- `bin/composer` → `docker run composer:2.2 composer ...`

mise automatically adds these to your PATH when the plugin is active.

## Troubleshooting

### Commands not found

Ensure mise is properly configured:

```bash
mise doctor
```

### Permission issues

Make sure Docker is running and you have permissions:

```bash
docker ps
```

### Custom Docker images

To use a custom PHP/Composer image with extensions:

```bash
export PHP_DOCKER_IMAGE="your-registry/php:7.4-custom"
```
