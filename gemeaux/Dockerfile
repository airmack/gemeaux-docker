FROM python:3.9-alpine
EXPOSE 1965/tcp
STOPSIGNAL SIGTERM 
STOPSIGNAL SIGINT

RUN apk add --no-cache --update git build-base sed runuser grep bash openssl && pip3 install tox 
WORKDIR /git/
RUN git clone https://github.com/airmack/gemeaux.git && git clone https://github.com/airmack/gemini-diagnostics.git
WORKDIR /git/gemini-diagnostics/
RUN git checkout play-nice 
WORKDIR /git/gemeaux/
RUN git checkout threading && /usr/local/bin/tox -e py39 && python -m pip install /git/gemeaux/.tox/dist/gemeaux-*.zip
RUN mkdir -p /var/capsule/bin && mkdir -p /var/capsule/conf && mkdir -p /var/capsule/gmi/ && mkdir -p /var/log/gemeaux/
WORKDIR /git/gemeaux/
RUN sed -i 's,examples,/var/capsule/gmi,g' example_app.py 
WORKDIR /var/capsule/
RUN adduser -S -D -H -G nogroup gemini
VOLUME ["/var/capsule/conf/","/var/capsule/bin/", "/var/capsule/gmi/","/var/log/gemeaux/"]
COPY start.sh /var/capsule/
HEALTHCHECK --interval=30s --timeout=5s CMD /git/gemini-diagnostics/gemini-diagnostics --checks TLSCloseNotify --play-nice
CMD /var/capsule/start.sh 
