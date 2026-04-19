# WP-CLI Cheatsheet — FSG Media

Reference for common WP-CLI operations on WPE installs via SSH.

## Connect

```bash
ssh thefivestar@thefivestar.ssh.wpengine.net
ssh thefivestarstg@thefivestarstg.ssh.wpengine.net
ssh thefivestardev@thefivestardev.ssh.wpengine.net
ssh mortgagepoint@mortgagepoint.ssh.wpengine.net
ssh amaaonline@amaaonline.ssh.wpengine.net
```

## Plugins

```bash
# List all plugins with status
wp plugin list

# Plugins with available updates
wp plugin list --update=available --fields=name,version,update_version

# Update one plugin
wp plugin update {slug}

# Update all (use carefully — test on staging first)
wp plugin update --all

# Activate / deactivate
wp plugin activate {slug}
wp plugin deactivate {slug}

# Install from WordPress.org
wp plugin install {slug} --activate
```

## Cache

```bash
# Purge WP Rocket
wp rocket clean --confirm

# Flush object cache
wp cache flush

# Flush rewrite rules (after permalink changes)
wp rewrite flush
```

## Database

```bash
# Export DB
wp db export /tmp/backup-$(date +%Y%m%d).sql

# Import DB
wp db import backup.sql

# Search-replace (dry run first — always)
wp search-replace 'https://thefivestar.com' \
  'https://thefivestarstg.wpenginepowered.com' \
  --dry-run --all-tables

# Run actual search-replace
wp search-replace 'https://thefivestar.com' \
  'https://thefivestarstg.wpenginepowered.com' --all-tables

# Run a SQL query
wp db query "SELECT ID, post_title, post_status \
  FROM wp_posts WHERE post_type='post' LIMIT 10"
```

## Users

```bash
# List admin users
wp user list --role=administrator

# Create admin (change password immediately after)
wp user create newadmin email@fsg.com --role=administrator --user_pass=TempPass1!

# Delete user (reassign posts to user 1)
wp user delete {ID} --reassign=1

# Update password
wp user update {ID} --user_pass=NewPassword
```

## Posts and content

```bash
# List recent posts
wp post list --post_type=post --posts_per_page=20 \
  --fields=ID,post_title,post_status,post_date

# List pages
wp post list --post_type=page --fields=ID,post_title,post_status

# Delete revisions (DB cleanup)
wp post delete $(wp post list --post_type=revision --format=ids) --force
```

## Options and settings

```bash
wp option get siteurl
wp option get blogname
wp option get wp_rocket_settings   # WP Rocket config
wp option get aioseo_options       # AIOSEO config
```

## Core

```bash
wp core version
wp core check-update
# Never update core on production without staging test first
```

## Diagnostics

```bash
wp --info          # PHP + WP-CLI version info
wp cron event list --fields=hook,next_run_relative
wp theme list --status=active
```
