FROM ubuntu:trusty


# Install base packages
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get -yq install \
        curl \
        apache2 \
        libapache2-mod-php5 \
        php5-mysql \
        php5-mcrypt \
        php5-gd \
        php5-curl \
        php-pear \
        wget \
        unzip \
        php-apc && \
    rm -rf /var/lib/apt/lists/* && \
    curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
RUN /usr/sbin/php5enmod mcrypt
RUN echo "ServerName localhost" >> /etc/apache2/apache2.conf && \
    sed -i "s/variables_order.*/variables_order = \"EGPCS\"/g" /etc/php5/apache2/php.ini
    
RUN wget https://wordpress.org/latest.zip && mv latest.zip /var/www/latest.zip
RUN cd /var/www/ && unzip latest.zip && rm latest.zip
RUN mv -v /var/www/wordpress/* /var/www/html && chown -R www-data:www-data /var/www/html
RUN rm /var/www/html/index.html

ENV ALLOW_OVERRIDE **False**

# Add image configuration and scripts
ADD run.sh /run.sh
RUN chmod 755 /*.sh

# Configure /app folder with sample app
#RUN mkdir -p /app && rm -fr /var/www/html && ln -s /app /var/www/html
#ADD sample/ /app

EXPOSE 80
#WORKDIR /app
CMD ["/run.sh"]
