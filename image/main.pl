#!/usr/bin/perl -w

# vim:set sts=2 ts=2 sw=2 et ai fdm=marker:

use strict;
use warnings;

use Net::DNS::Nameserver;
use Socket;
use Sys::Hostname;

$SIG{INT}  = sub { die "caught sigint $!" };
$SIG{TERM} = sub { die "caught sigterm $!" };

my $name = hostname();
my $addr = inet_ntoa(scalar(gethostbyname($name)) || 'localhost');

sub reply_handler {
  my ($qname, $qclass, $qtype, $peerhost, $query, $conn) = @_;
  my ($rcode, @ans, @auth, @add);

  if ($qtype eq "TXT" or $qtype eq "A") {
    my %h = (
      "TXT" => "\"remote:$peerhost local:$addr now:" . time() . "\"",
      "A"   => $peerhost
    );

    my ($ttl, $rdata) = (60, $h{$qtype});
    my $rr = new Net::DNS::RR("$qname $ttl $qclass $qtype $rdata");
    push @ans, $rr;
    $rcode = "NOERROR";
  } else {
    # NODATA is NOERROR without an answer section
    $rcode = "NOERROR";
  }

  my $headermask = { aa => 1 };
  my $optionmask = {};

  return ($rcode, \@ans, \@auth, \@add, $headermask, $optionmask);
}

my $ns = new Net::DNS::Nameserver(
  LocalPort => $ENV{PORT} || 5353,
  LocalAddr => '0.0.0.0',
  ReplyHandler => \&reply_handler,
  Verbose      => 0
) or die "$!";

$ns->main_loop();

