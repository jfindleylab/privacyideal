FROM freeradius/freeradius-server:latest

USER root

# Install cpanm
RUN apt update && apt install -y cpanminus build-essential freeradius-utils

# Create directory
RUN mkdir -p /usr/share/privacyidea/freeradius

# Copy dependency file
COPY cpanfile /usr/share/privacyidea/freeradius/CPANfile
COPY privacyidea_radius.pm /usr/share/privacyidea/freeradius/privacyidea_radius.pm
COPY mods-perl-privacyidea /etc/freeradius/mods-available/mods-perl-privacyidea
COPY privacyidea /etc/freeradius/sites-available/privacyidea
COPY rlm_perl.ini /etc/freeradius/rlm_perl.ini

RUN rm -f /etc/freeradius/sites-enabled/default
RUN ln -s /etc/freeradius/mods-available/mods-perl-privacyidea /etc/freeradius/mods-enabled/mods-perl-privacyidea
RUN ln -s /etc/freeradius/sites-available/privacyidea /etc/freeradius/sites-enabled/privacyidea


# Install dependencies
RUN cpanm --notest --verbose --installdeps . --cpanfile /usr/share/privacyidea/freeradius/CPANfile

# Fix permissions
RUN chmod -R 755 /usr/share/privacyidea/freeradius