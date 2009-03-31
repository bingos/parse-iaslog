use strict;
use warnings;
use Test::More tests => 16;

BEGIN { use_ok('Parse::IASLog') };

my $original = '10.10.10.10,client,06/04/1999,14:42:19,IAS,CLIENTCOMP,6,2,7,1,5,9,61,5,64,1,65,1,31,1,4136,1,4142,0';

# Function Interface

my $record1 = parse_ias( $original ) or die;

ok( $record1->{'NAS-IP-Address'} eq '10.10.10.10', 'NAS-IP-Address' );
ok( $record1->{'User-Name'} eq 'client', 'User-Name' );
ok( $record1->{'Record-Date'} eq '06/04/1999', 'Record-Date' );
ok( $record1->{'Record-Time'} eq '14:42:19', 'Record-Time' );
ok( $record1->{'Service-Name'} eq 'IAS', 'Service-Name' );
ok( $record1->{'Computer-Name'} eq 'CLIENTCOMP', 'Computer-Name' );

ok( $record1->{'NAS-Port-Type'} eq 'Virtual (VPN)', 'NAS-Port-Type' );
ok( $record1->{'Service-Type'} eq 'Framed', 'Service-Type' );
ok( $record1->{'Tunnel-Medium-Type'} eq 'IP (IP version 4)', 'Tunnel-Medium-Type' );
ok( $record1->{'Tunnel-Type'} eq 'Point-to-Point Tunneling Protocol (PPTP)', 'Tunnel-Type' );
ok( $record1->{'Framed-Protocol'} eq 'PPP', 'Framed-Protocol' );
ok( $record1->{'NAS-Port'} eq '9', 'NAS-Port' );
ok( $record1->{'Calling-Station-ID'} eq '1', 'Calling-Station-ID' );

ok( $record1->{'Packet-Type'} eq 'Access-Request', 'Packet-Type' );
ok( $record1->{'Reason-Code'} eq 'Success', 'Reason-Code' );