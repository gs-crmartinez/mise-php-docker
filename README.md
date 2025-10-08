# mise-php-docker

A mise plugin that runs PHP 8, Composer, and Xdebug inside Docker containers automatically.

## Prerequisites

- [mise](https://mise.jdx.dev/) installed
- Docker running locally

## Features

- **Auto-build**: Docker image builds automatically on first use
- **Unified image**: PHP and Composer use the same image (guaranteed version match)
- **Xdebug support**: Built-in debugging with VSCode integration
- **Version-aware**: Reads versions from `.mise.toml` automatically
- **Common extensions**: Includes PDO, MySQL, MySQLi out of the box

## Installation

### Option 1: Install from local path

```bash
mise plugin add mise-php-docker /Users/cristian.martinez/insided/dev/mise-insided-plugin
```

### Option 2: Install from git repository

```bash
mise plugin add mise-php-docker https://github.com/gs-crmartinez/mise-php-docker.git
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
- `bin/php-debug` → Sets `XDEBUG_MODE=debug` and calls `bin/php`

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
docker build -t mise-php-docker:8 .
```
