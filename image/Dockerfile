
FROM alpine:3.9
RUN apk add perl-net-dns

USER nobody
COPY main.pl /
ENV PORT 5353
ENTRYPOINT ["/main.pl"]

