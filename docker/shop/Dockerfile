ARG IMAGE
FROM $IMAGE

# Define build arguments
ARG APACHE_RUN_USER
ARG APACHE_RUN_GROUP

# If APACHE_RUN_USER and APACHE_RUN_GROUP exist, proceed with switching from www-data apache user/group to a new one
RUN test -n "$APACHE_RUN_USER" && test -n "$APACHE_RUN_GROUP" || \
    (exit 1)

# Set www-data home directory to /nonexistent
RUN sudo usermod -d /nonexistent www-data

# Create group with GID 1000 if it doesn't exist
RUN sudo groupadd -g 1000 "$APACHE_RUN_GROUP" || true

# Create user with UID 1000, home directory /var/www/html, and add to the group
RUN sudo adduser --uid 1000 --home /var/www/html --gecos "" --ingroup "$APACHE_RUN_GROUP" "$APACHE_RUN_USER" || true

# Remove password from newly created user
RUN sudo passwd -d "$APACHE_RUN_USER"

# Add user to sudoers
RUN sudo sh -c "echo \"$APACHE_RUN_USER ALL=(ALL:ALL) NOPASSWD:ALL\" >> /etc/sudoers"

# Stop Apache
RUN sudo service apache2 stop

# Switch to newly created user to be used when container starts
USER "$APACHE_RUN_USER":"$APACHE_RUN_GROUP"

# Update Apache configuration, by replacing www-data:www-data occurences with newly created user/group name
RUN sudo sed -i "s/www-data/$APACHE_RUN_USER/" /etc/apache2/apache2.conf
RUN sudo sed -i "s/www-data/$APACHE_RUN_USER/" /etc/apache2/envvars
RUN sudo sed -i "s/www-data/$APACHE_RUN_USER/" /etc/php/*/fpm/pool.d/www.conf

# Update Dochware, by replacing www-data:www-data occurences with newly created user/group name
RUN sudo sed -i 's/www-data/'"$APACHE_RUN_GROUP"'/g' /entrypoint.sh
RUN sudo sed -i 's/www-data/'"$APACHE_RUN_GROUP"'/g' /var/www/makefile

# Update Apache file's owner/group, with newly created user/group name (performance optimized with xargs & exclusion of html folder)
RUN sudo find /var/ -depth -user www-data -group www-data ! -path "/var/www/html/*" -print0 | xargs -0 -P4 -n1 sudo chown $APACHE_RUN_USER:$APACHE_RUN_GROUP
RUN sudo find /etc/ -depth -user www-data -group www-data -exec chown $APACHE_RUN_USER:$APACHE_RUN_GROUP {} +

# Start Apache
RUN sudo service apache2 start
