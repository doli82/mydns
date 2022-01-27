FROM alpine:3.14

env BIND_LOG -g

RUN apk --update upgrade && \
    apk add bind bind-tools bind-plugins


# RUN rm -rf /etc/bind && \
#     mkdir -m 0750 -p /etc/bind && \
#     chown -R root:named /etc/bind
RUN chown -R root:named /etc/bind && \
    mkdir -m 0770 -p /var/cache/bind && \
    chown -R named:named /var/cache/bind 
    
# RUN rm -rf /var/cache/bind && \
#     mkdir -m 0770 -p /var/cache/bind && \
#     chown -R named:named /var/cache/bind 

RUN rndc-confgen -a

COPY .docker/bind /etc/bind/

VOLUME ["/etc/bind"]
VOLUME ["/var/cache/bind"]

EXPOSE 53/udp 53/tcp

COPY .docker/entrypoint.sh /
RUN chmod a+x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]