FROM haproxy:1.8-alpine
RUN apk add --update curl && rm -rf /var/cache/apk/*
RUN mkdir -p /etc/confd/conf.d && mkdir /etc/confd/templates && mkdir /usr/local/etc/haproxy/ssl
# COPY mycertificate.pem /usr/local/etc/haproxy/ssl
COPY confd .
RUN chmod +x confd
COPY haproxy.toml /etc/confd/conf.d/
COPY haproxy.tmpl /etc/confd/templates/
COPY boot.sh .
COPY watcher.sh .
EXPOSE 80
CMD ["./boot.sh"]
