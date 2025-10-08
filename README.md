# mise-insided-plugin

A mise plugin that runs PHP 7.4, Composer 2.2, and Xdebug 3.1 inside Docker containers automatically.

## Prerequisites

- [mise](https://mise.jdx.dev/) installed
- Docker running locally

## Build the Docker Image

Before using this plugin, build the custom Docker image:

```bash
cd /Users/cristian.martinez/insided/dev/mise-insided-plugin
docker build -t mise-insided-php:7.4 .
```

This creates a unified image with:
- PHP 7.4 CLI
- Composer 2.2 (compatible with PHP 7.4)
- Xdebug 3.1 (for step debugging)

**Important:** Both `php` and `composer` commands use the **same image**, ensuring PHP version consistency.

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

Once installed, `php` and `composer` commands automatically run inside Docker:

```bash
php -v                    # PHP 7.4.x (cli)
composer -V               # Composer version 2.2.x
composer install
php artisan migrate
```

### Debugging with Xdebug

Enable step debugging from VSCode:

```bash
# Method 1: Use the php-debug wrapper
php-debug vendor/bin/phpunit tests/MyTest.php

# Method 2: Set XDEBUG_MODE environment variable
XDEBUG_MODE=debug php vendor/bin/phpunit tests/MyTest.php

# Method 3: Export for entire session
export XDEBUG_MODE=debug
php vendor/bin/phpunit tests/MyTest.php
```

**VSCode Setup:**

1. Copy [.vscode/launch.json](.vscode/launch.json) to your project
2. Install the [PHP Debug extension](https://marketplace.visualstudio.com/items?itemName=xdebug.php-debug)
3. Set breakpoints in your PHP files
4. Start debugging with F5 → "Listen for Xdebug"
5. Run your PHP script with `php-debug` or `XDEBUG_MODE=debug`

The debugger will pause at your breakpoints automatically.

## Configuration

### Version-based configuration

Specify versions in `.mise.toml`:

```toml
[tools]
php = "7.4"
```

The plugin will use `mise-insided-php:7.4` Docker image for both PHP and Composer.

### Custom Docker image override

Override with a custom image (if you've built one with extra extensions):

```toml
[tools]
php = "7.4"

[env]
PHP_DOCKER_IMAGE = "your-registry/custom-php:7.4"
```

Both `php` and `composer` will use the custom image.

### Global configuration

Add to your shell config (~/.config/fish/config.fish):

```fish
set -gx PHP_DOCKER_IMAGE "mise-insided-php:7.4"
```

Or for Bash (~/.bashrc):

```bash
export PHP_DOCKER_IMAGE="mise-insided-php:7.4"
```

## Features

- **Unified Docker image**: PHP and Composer use the same image (guaranteed version match)
- **Xdebug support**: Built-in debugging with VSCode integration
- **Version-aware**: Reads versions from `.mise.toml` automatically
- **Common extensions**: Includes PDO, MySQL, MySQLi out of the box
- **Volume mounting**: Current directory automatically mounted to `/app`
- **Interactive & non-interactive modes**: Works with both CLI and scripts

## How it works

The plugin provides executable shims in `bin/` that wrap Docker commands:

- `bin/php` → `docker run mise-insided-php:7.4 php ...`
- `bin/composer` → `docker run mise-insided-php:7.4 composer ...`
- `bin/php-debug` → Sets `XDEBUG_MODE=debug` and calls `bin/php`

mise automatically adds these to your PATH when the plugin is active.

## Troubleshooting

### Commands not found

Ensure mise is properly configured:

```bash
mise doctor
```

### Docker image not found

Build the Docker image first:

```bash
docker build -t mise-insided-php:7.4 .
```

### Permission issues

Make sure Docker is running:

```bash
docker ps
```

### Xdebug not connecting

1. Check VSCode is listening (F5 → "Listen for Xdebug")
2. Verify port 9003 is not blocked by firewall
3. Enable debug logging in [.vscode/launch.json](.vscode/launch.json) (`"log": true`)
4. Check Docker can reach host: `docker run --rm --add-host=host.docker.internal:host-gateway alpine ping -c 1 host.docker.internal`

### Adding more PHP extensions

Edit [Dockerfile](Dockerfile) and add extensions:

```dockerfile
RUN docker-php-ext-install gd zip bcmath
```

Then rebuild:

```bash
docker build -t mise-insided-php:7.4 .
```
