---
title: Upgrading Guide
nav_order: 23
---

This guide provides some notes on upgrading Cody.

Version | Notes
--- | ---
1.0.0 | The most notable change is that properties auto-camelization no longer happens by default. You can still enable it but is not recommended. See the [auto_camelize settings]({% link _docs/settings.md %}) to enable it.

## Upgrade Details

The following section provides a little more detail on each version upgrade. Note, not all versions required more details.

### 1.0.0
* Breaking changes: CamelCase for properties instead of underscore. Map straight to the CloudFormation resource to remove mental overhead.
* Update templates to use the latest
* Change delete: `--sure` to `--yes` option. `-y` shorthand.
* Rename CODY_ENV_EXTRA env variable to CODY_EXTRA

{% include prev_next.md %}
