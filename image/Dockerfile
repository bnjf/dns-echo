
FROM alpine:latest

# couldn't find no `perl-net-dns-nameserver`, unfortunately.  get it in with
# cpanminus.
RUN apk add perl perl-app-cpanminus make
RUN cpanm --no-wget Net::DNS::Nameserver
COPY main.pl /
ENV PORT 5353
ENTRYPOINT ["/main.pl"]

