#!/bin/sh

# Custom boot script, executed by Dockware's entrypoint.sh.
# At the end of initialization, entrypoint.sh checks if "/var/www/boot_end.sh" exists,
# to execute the script at the end of its own execution. Therefore, this file should be
# exposed to the APP container through the volume. Any post-initialization action
# could / should be defined here...


