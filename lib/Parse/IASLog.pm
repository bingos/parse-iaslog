package Parse::IASLog;

# We export some stuff
require Exporter;
@ISA = qw( Exporter );
@EXPORT = qw(parse_ias);

use strict;
use warnings;
use vars qw($VERSION);

$VERSION = '1.08';

my %attributes = qw(
-90 MS-MPPE-Encryption-Types
-89 MS-MPPE-Encryption-Policy
-88 MS-BAP-Usage
-87 MS-Link-Drop-Time-Limit
-86 MS-Link-Utilization-Threshold
1 User-Name
2 User-Password
3 CHAP-Password
4 NAS-IP-Address
5 NAS-Port
6 Service-Type
7 Framed-Protocol
8 Framed-IP-Address
9 Framed-IP-Netmask
10 Framed-Routing
11 Filter-ID
12 Framed-MTU
13 Framed-Compression
14 Login-IP-Host
15 Login-Service
16 Login-TCP-Port
18 Reply-Message
19 Callback-Number
20 Callback-ID
22 Framed-Route
23 Framed-IPX-Network
24 State
25 Class
26 Vendor-Specific
27 Session-Timeout
28 Idle-Timeout
29 Termination-Action
30 Called-Station-ID
31 Calling-Station-ID
32 NAS-Identifier
33 Proxy-State
34 Login-LAT-Service
35 Login-LAT-Node
36 Login-LAT-Group
37 Framed-AppleTalk-Link
38 Framed-AppleTalk-Network
39 Framed-AppleTalk-Zone
40 Acct-Status-Type
41 Acct-Delay-Time
42 Acct-Input-Octets
43 Acct-Output-Octets
44 Acct-Session-ID
45 Acct-Authentic
46 Acct-Session-Time
47 Acct-Input-Packets
48 Acct-Output-Packets
49 Acct-Terminate-Cause
50 Acct-Multi-Session-ID
51 Acct-Link-Count
52 Acct-Input-Gigawords
53 Acct-Output-Gigawords
55 Event-Timestamp
60 CHAP-Challenge
61 NAS-Port-Type
62 Port-Limit
63 Login-LAT-Port
64 Tunnel-Type
65 Tunnel-Medium-Type
66 Tunnel-Client-Endpt
67 Tunnel-Server-Endpt
68 Acct-Tunnel-Connection
69 Tunnel-Password
70 ARAP-Password
71 ARAP-Features
72 ARAP-Zone-Access
73 ARAP-Security
74 ARAP-Security-Data
75 Password-Retry
76 Prompt
77 Connect-Info
78 Configuration-Token
79 EAP-Message
80 Message-Authenticator
81 Tunnel-Pvt-Group-ID
82 Tunnel-Assignment-ID
83 Tunnel-Preference
84 ARAP-Challenge-Response
85 Acct-Interim-Interval
86 Acct-Tunnel-Packets-Lost
87 NAS-Port-ID
88 Framed-Pool
90 Tunnel-Client-Auth-ID
91 Tunnel-Server-Auth-ID
107 Ascend-Calling-Subaddress
108 Ascend-Callback-Delay
109 Ascend-Endpoint-Disc
110 Ascend-Remote-FW
111 Ascend-Multicast-G-Leave-Delay
112 Ascend-CBCP-Enable
113 Ascend-CBCP-Mode
114 Ascend-CBCP-Delay
115 Ascend-CBCP-Trunk-Group
116 Ascend-Appletalk-Route
117 Ascend-Appletalk-Peer-Mode
118 Ascend-Route-Appletalk
119 Ascend-FCP-Parameter
120 Ascend-Modem-Port-No
121 Ascend-Modem-Slot-No
122 Ascend-Modem-Shelf-No
123 Ascend-CallAttempt-Limit
124 Ascend-CallBlock-Duration
125 Ascend-Maximum-Call-Duration
126 Ascend-Route-Preference
127 Ascend-Tunneling-Protocol
128 Ascend-Shared-Profile-Enable
129 Ascend-Primary-Home-Agent
130 Ascend-Secondary-Home-Agent
131 Ascend-Dialout-Allowed
132 Ascend-Client-Gateway
133 Ascend-BACP-Enable
134 Ascend-DHCP-Maximum-Leases
135 Ascend-Client-Primary-DNS
136 Ascend-Client-Secondary-DNS
137 Ascend-Client-Assign-DNS
138 Ascend-User-Acct-Type
139 Ascend-User-Acct-Host
140 Ascend-User-Acct-Port
141 Ascend-User-Acct-Key
142 Ascend-User-Acct-Base
143 Ascend-User-Acct-Time
144 Ascend-Assign-IP-Client
145 Ascend-Assign-IP-Server
146 Ascend-Assign-IP-Global-Pool
147 Ascend-DHCP-Reply
148 Ascend-DHCP-Pool-Number
149 Ascend-Expect-Callback
150 Ascend-Event-Type
151 Ascend-Session-Svr-Key
152 Ascend-Multicast-Rate-Limit
153 Ascend-IF-Netmask
154 Ascend-Remote-Addr
155 Ascend-Multicast-Client
156 Ascend-FR-Circuit-Name
157 Ascend-FR-Link-Up
158 Ascend-FR-Nailed-Grp
159 Ascend-FR-Type
160 Ascend-FR-Link-Mgt
161 Ascend-FR-N391
162 Ascend-FR-DCE-N392
163 Ascend-FR-DTE-N392
164 Ascend-FR-DCE-N393
165 Ascend-FR-DTE-N393
166 Ascend-FR-T391
167 Ascend-FR-T392
168 Ascend-Bridge-Address
169 Ascend-TS-Idle-Limit
170 Ascend-TS-Idle-Mode
171 Ascend-DBA-Monitor
172 Ascend-Base-Channel-Count
173 Ascend-Minimum-Channels
174 Ascend-IPX-Route
175 Ascend-FT1-Caller
176 Ascend-Backup
177 Ascend-Call-Type
178 Ascend-Group
179 Ascend-FR-DLCI
180 Ascend-FR-Profile-Name
181 Ascend-Ara-PW
182 Ascend-IPX-Node-Addr
183 Ascend-Home-Agent-IP-Addr
184 Ascend-Home-Agent-Password
185 Ascend-Home-Network-Name
186 Ascend-Home-Agent-UDP-Port
187 Ascend-Multilink-ID
188 Ascend-Num-In-Multilink
189 Ascend-First-Dest
190 Ascend-Pre-Input-Octets
191 Ascend-Pre-Output-Octets
192 Ascend-Pre-Input-Packets
193 Ascend-Pre-Output-Packets
194 Ascend-Maximum-Time
195 Ascend-Disconnect-Cause
196 Ascend-Connect-Progress
197 Ascend-Data-Rate
198 Ascend-Pre-Session-Time
199 Ascend-Token-Idle
200 Ascend-Token-Immediate
201 Ascend-Require-Auth
202 Ascend-Number-Sessions
203 Ascend-Authen-Alias
204 Ascend-Token-Expiry
205 Ascend-Menu-Selector
206 Ascend-Menu-Item
207 Ascend-PW-Warntime
208 Ascend-PW-Lifetime
209 Ascend-IP-Direct
210 Ascend-PPP-VJ-Slot-Comp
211 Ascend-PPP-VJ-1172
212 Ascend-PPP-Async-Map
213 Ascend-Third-Prompt
214 Ascend-Send-Secret
215 Ascend-Receive-Secret
216 Ascend-IPX-PeerMode
217 Ascend-IP-Pool-Definition
218 Ascend-Assign-IP-Pool
219 Ascend-FR-Direct
220 Ascend-FR-Direct-Profile
221 Ascend-FR-Direct-DLCI
222 Ascend-Handle-IPX
223 Ascend-Netware-Timeout
224 Ascend-IPX-Alias
225 Ascend-Metric
226 Ascend-PRI-Number-Type
227 Ascend-Dial-Number
228 Ascend-Route-IP
229 Ascend-Route-IPX
230 Ascend-Bridge
231 Ascend-Send-Auth
232 Ascend-Send-Passwd
233 Ascend-Link-Compression
234 Ascend-Target-Util
235 Ascend-Maximum-Channels
236 Ascend-Inc-Channel-Count
237 Ascend-Dec-Channel-Count
238 Ascend-Seconds-Of-History
239 Ascend-History-Weigh-Type
240 Ascend-Add-Seconds
241 Ascend-Remove-Seconds
242 Ascend-Data-Filter
243 Ascend-Call-Filter
244 Ascend-Idle-Limit
245 Ascend-Preempt-Limit
246 Ascend-Callback
247 Ascend-Data-Svc
248 Ascend-Force56
249 Ascend-Billing-Number
250 Ascend-Call-By-Call
251 Ascend-Transit-Number
252 Ascend-Host-Info
253 Ascend-PPP-Address
254 Ascend-MPP-Idle-Percent
255 Ascend-Xmit-Rate
4096 Saved-Radius-Framed-IP-Address
4097 Saved-Radius-Callback-Number
4098 NP-Calling-Station-ID
4099 Saved-NP-Calling-Station-ID
4100 Saved-Radius-Framed-Route
4101 Ignore-User-Dialin-Properties
4102 Day-And-Time-Restrictions
4103 NP-Called-Station-ID
4104 NP-Allowed-Port-Types
4105 NP-Authentication-Type
4106 NP-Allowed-EAP-Type
4107 Shared-Secret
4108 Client-IP-Address
4109 Client-Packet-Header
4110 Token-Groups
4111 NP-Allow-Dial-in
4112 Request-ID
4113 Manipulation-Target
4114 Manipulation-Rule
4115 Original-User-Name
4116 Client-Vendor
4117 Client-UDP-Port
4118 MS-CHAP-Challenge
4119 MS-CHAP-Response
4120 MS-CHAP-Domain
4121 MS-CHAP-Error
4122 MS-CHAP-CPW-1
4123 MS-CHAP-CPW-2
4124 MS-CHAP-LM-Enc-PW
4125 MS-CHAP-NT-Enc-PW
4126 MS-CHAP-MPPE-Keys
4127 Authentication-Type
4128 Client-Friendly-Name
4129 SAM-Account-Name
4130 Fully-Qualifed-User-Name
4131 Windows-Groups
4132 EAP-Friendly-Name
4133 Auth-Provider-Type
4134 MS-Acct-Auth-Type
4135 MS-Acct-EAP-Type
4136 Packet-Type
4137 Auth-Provider-Name
4138 Acct-Provider-Type
4139 Acct-Provider-Name
4140 MS-MPPE-Send-Key
4141 MS-MPPE-Recv-Key
4142 Reason-Code
4143 MS-Filter
4144 MS-CHAP2-Response
4145 MS-CHAP2-Success
4146 MS-CHAP2-CPW
4147 MS-RAS-Vendor
4148 MS-RAS-Version
4149 NP-Policy-Name
4150 MS-Primary-DNS-Server
4151 MS-Secondary-DNS-Server
4152 MS-Primary-NBNS-Server
4153 MS-Secondary-NBNS-Server
4154 Proxy-Policy-Name
4155 Provider-Type
4156 Provider-Name
4157 Remote-Server-Address
4158 Generate-Class-Attribute
4159 MS-RAS-Client-Name
4160 MS-RAS-Client-Version
4161 Allowed-Certificate-OID
4162 Extension-State
4163 Generate-Session-Timeout
4164 MS-Session-Timeout
4165 MS-Quarantine-IPFilter
4166 MS-Quarantine-Session-Timeout
4167 MS-User-Security-Identity
4168 Remote-RADIUS-to-Windows-User-Mapping
4169 Passport-User-Mapping-UPN-Suffix
4170 Tunnel-Tag
4171 NP-PEAPUpfront-Enabled
5000 Cisco-AV-Pair
6000 Nortel-Port-QOS
6001 Nortel-Port-Priority
8097 Certificate-EKU
8098 EAP-Configuration
8099 MS-PEAP-Embedded-EAP-TypeId
8100 MS-PEAP-Fast-Roamed-Session
8101 IAS-EAP-TypeId
8102 EAP-TLV
8103 Reject-Reason-Code
8104 Proxy-EAP-Configuration
8105 Session
8106 Is-Replay
8107 Clear-Text-Password
11000 USR-Last-Number-Dialed-Out
11001 USR-Last-Number-Dialed-In-DNIS
11002 USR-Last-Callers-Number-ANI
11003 USR-Channel
11004 USR-Event-ID
11005 USR-Event-Date-Time
11006 USR-Call-Start-Date-Time
11007 USR-Call-End-Date-Time
11008 USR-Default-DTE-Data-Rate
11009 USR-Initial-Rx-Link-Data-Rate
11010 USR-Final-Rx-Link-Data-Rate
11011 USR-Initial-Tx-Link-Data-Rate
11012 USR-Final-Tx-Link-Data-Rate
11013 USR-Chassis-Temperature
11014 USR-Chassis-Temp-Threshold
11015 USR-Actual-Voltage
11016 USR-Expected-Voltage
11017 USR-Power-Supply-Number
11018 USR-Card-Type
11019 USR-Chassis-Slot
11020 USR-Sync-Async-Mode
11021 USR-Originate-Answer-Mode
11022 USR-Modulation-Type
11023 USR-Initial-Modulation-Type
11024 USR-Connect-Term-Reason
11025 USR-Failure-to-Connect-Reason
11026 USR-Equalization-Type
11027 USR-Fallback-Enabled
11028 USR-Connect-Time-Limit
11029 USR-Number-of-Rings-Limit
11030 USR-DTE-Data-Idle-Timout
11031 USR-Characters-Sent
11032 USR-Characters-Received
11033 USR-Blocks-Sent
11034 USR-Blocks-Received
11035 USR-Blocks-Resent
11036 USR-Retrains-Requested
11037 USR-Retrains-Granted
11038 USR-Line-Reversals
11039 USR-Number-Of-Characters-Lost
11040 USR-Number-of-Blers
11041 USR-Number-of-Link-Timeouts
11042 USR-Number-of-Fallbacks
11043 USR-Number-of-Upshifts
11044 USR-Number-of-Link-NAKs
11045 USR-DTR-False-Timeout
11046 USR-Fallback-Limit
11047 USR-Block-Error-Count-Limit
11048 USR-DTR-True-Timeout
11049 USR-Security-Login-Limit
11050 USR-Security-Resp-Limit
11051 USR-DTE-Ring-No-Answer-Limit
11052 USR-Back-Channel-Data-Rate
11053 USR-Simplified-MNP-Levels
11054 USR-Simplified-V42bis-Usage
11055 USR-Mbi-Ct-PRI-Card-Slot
11056 USR-Mbi-Ct-TDM-Time-Slot
11057 USR-Mbi-Ct-PRI-Card-Span-Line
11058 USR-Mbi-Ct-BChannel-Used
11059 USR-Physical-State
11060 USR-Packet-Bus-Session
11061 USR-Server-Time
11062 USR-Channel-Connected-To
11063 USR-Slot-Connected-To
11064 USR-Device-Connected-To
11065 USR-NFAS-ID
11066 USR-Q931-Call-Reference-Value
11067 USR-Call-Event-Code
11068 USR-DS0
11069 USR-DS0s
11070 USR-Gateway-IP-Address
11071 USR-Call-Arrival-in-GMT
11072 USR-Call-Connect-in-GMT
11073 USR-Call-Terminate-in-GMT
11074 USR-IDS0-Call-Type
11075 USR-Call-Reference-Number
11076 USR-CDMA-Call-Reference-Number
11077 USR-Mobile-IP-Address
11078 USR-IWF-IP-Address
11079 USR-Called-Party-Number
11080 USR-Calling-Party-Number
11081 USR-Call-Type
11082 USR-ESN
11083 USR-IWF-Call-Identifier
11084 USR-IMSI
11085 USR-Service-Option
11086 USR-Disconnect-Cause-Indicator
11087 USR-Mobile-NumBytes-Txed
11088 USR-Mobile-NumBytes-Rxed
11089 USR-Num-Fax-Pages-Processed
11090 USR-Compression-Type
11091 USR-Call-Error-Code
11092 USR-Modem-Setup-Time
11093 USR-Call-Connecting-Time
11094 USR-Connect-Time
11095 USR-RMMIE-Manufacutere-ID
11096 USR-RMMIE-Product-Code
11097 USR-RMMIE-Serial-Number
11098 USR-RMMIE-Firmware-Version
11099 USR-RMMIE-Firmware-Build-Date
11100 USR-RMMIE-Status
11101 USR-RMMIE-Num-Of-Updates
11102 USR-RMMIE-x2-Status
11103 USR-RMMIE-Planned-Disconnect
11104 USR-RMMIE-Last-Update-Time
11105 USR-RMMIE-Last-Update-Event
11106 USR-RMMIE-Rcv-Tot-PwrLvl
11107 USR-RMMIE-Rcv-PwrLvl-3300Hz
11108 USR-RMMIE-Rcv-PwrLvl-3750Hz
11109 USR-RMMIE-PwrLvl-NearEcho-Canc
11110 USR-RMMIE-PwrLvl-FarEcho-Canc
11111 USR-RMMIE-PwrLvl-Noise-Lvl
11112 USR-RMMIE-PwrLvl-Xmit-Lvl
11113 USR-PW-USR-IFilter-IP
11114 USR-PW-USR-IFilter-IPX
11115 USR-PW-USR-IFilter-SAP
11116 USR-PW-USR-OFilter-IP
11117 USR-PW-USR-OFilter-IPX
11118 USR-PW-USR-OFilter-SAP
11119 USR-PW-VPN-ID
11120 USR-PW-VPN-Name
11121 USR-PW-VPN-Neighbor
11122 USR-PW-Framed-Routing-V2
11123 USR-PW-VPN-Gateway
11124 USR-PW-Tunnel-Authentication
11125 USR-PW-Index
11126 USR-PW-Cutoff
11127 USR-PW-Packet
11128 USR-Primary-DNS-Server
11129 USR-Secondary-DNS-Server
11130 USR-Primary-NBNS-Server
11131 USR-Secondary-NBNS-Server
11132 USR-Syslog-Tap
11133 USR-Log-Filter-Packet
11134 USR-Chassis-Call-Slot
11135 USR-Chassis-Call-Span
11136 USR-Chassis-Call-Channel
11137 USR-Keypress-Timeout
11138 USR-Unauthenticated-Time
11139 USR-VPN-Encryptor
11140 USR-VPN-GW-Location-ID
11141 USR-Re-Chap-Timeout
11142 USR-CCP-Algorithm
11143 USR-ACCM-Type
11144 USR-Connect-Speed
11145 USR-Framed-IP-Address-Pool-Name
11146 USR-MP-EDO
11147 USR-Local-Framed-IP-Addr
11148 USR-Framed-IPX-Route
11149 USR-MPIP-Tunnel-Originator
11150 USR-Bearer-Capabilities
11151 USR-Speed-Of-Connection
11152 USR-Max-Channels
11153 USR-Channel-Expansion
11154 USR-Channel-Decrement
11155 USR-Expansion-Algorithm
11156 USR-Compression-Algorithm
11157 USR-Receive-Acc-Map
11158 USR-Transmit-Acc-Map
11159 USR-Compression-Reset-Mode
11160 USR-Min-Compression-Size
11161 USR-IP
11162 USR-IPX
11163 USR-Filter-Zones
11164 USR-Appletalk
11165 USR-Bridging
11166 USR-Spoofing
11167 USR-Host-Type
11168 USR-Send-Name
11169 USR-Send-Password
11170 USR-Start-Time
11171 USR-End-Time
11172 USR-Send-Script1
11173 USR-Reply-Script1
11174 USR-Send-Script2
11175 USR-Reply-Script2
11176 USR-Send-Script3
11177 USR-Reply-Script3
11178 USR-Send-Script4
11179 USR-Reply-Script4
11180 USR-Send-Script5
11181 USR-Reply-Script5
11182 USR-Send-Script6
11183 USR-Reply-Script6
11184 USR-Terminal-Type
11185 USR-Appletalk-Network-Range
11186 USR-Local-IP-Address
11187 USR-Routing-Protocol
11188 USR-Modem-Group
11189 USR-IPX-Routing
11190 USR-IPX-WAN
11191 USR-IP-RIP-Policies
11192 USR-IP-RIP-Simple-Auth-Password
11193 USR-IP-RIP-Input-Filter
11194 USR-IP-Call-Input-Filter
11195 USR-IPX-RIP-Input-Filter
11196 USR-MP-MRRU
11197 USR-IPX-Call-Input-Filter
11198 USR-AT-Input-Filter
11199 USR-AT-RTMP-Input-Filter
11200 USR-AT-Zip-Input-Filter
11201 USR-AT-Call-Input-Filter
11202 USR-ET-Bridge-Input-Filter
11203 USR-IP-RIP-Output-Filter
11204 USR-IP-Call-Output-Filter
11205 USR-IPX-RIP-Output-Filter
11206 USR-IPX-Call-Output-Filter
11207 USR-AT-Output-Filter
11208 USR-AT-RTMP-Output-Filter
11209 USR-AT-Zip-Output-Filter
11210 USR-AT-Call-Output-Filter
11211 USR-ET-Bridge-Output-Filter
11212 USR-ET-Bridge-Call-Output-Filter
11213 USR-IP-Default-Route-Option
11214 USR-MP-EDO-HIPER
11215 USR-Modem-Training-Time
11216 USR-Interface-Index
11217 USR-Tunnel-Security
11218 USR-Port-Tap
11219 USR-Port-Tap-Format
11220 USR-Port-Tap-Output
11221 USR-Port-Tap-Facility
11222 USR-Port-Tap-Priority
11223 USR-Port-Tap-Address
11224 USR-MobileIP-Home-Agent-Address
11225 USR-Tunneled-MLPP
11226 USR-Multicast-Proxy
11227 USR-Multicast-Receive
11228 USR-Multicast-Forwarding
11229 USR-IGMP-Query-Interval
11230 USR-IGMP-Maximum-Response-Time
11231 USR-IGMP-Robustness
11232 USR-IGMP-Version
11233 USR-IGMP-Routing
11234 USR-VTS-Session-Key
11235 USR-Orig-NAS-Type
11236 USR-Call-Arrival-Time
11237 USR-Call-End-Time
11238 USR-Rad-Multicast-Routing-Ttl
11239 USR-Rad-Multicast-Routing-Rate-Limit
11240 USR-Rad-Multicast-Routing-Protocol
11241 USR-Rad-Multicast-Routing-Boundary
11242 USR-Rad-Dvmrp-Metric
11243 USR-Chat-Script-Name
11244 USR-Chat-Script-Rules
11245 USR-Rad-Location-Type
11246 USR-Tunnel-Switch-Endpoint
11247 USR-OSPF-Addressless-Index
11248 USR-Callback-Type
11249 USR-Tunnel-Auth-Hostname
11250 USR-Acct-Reason-Code
11251 USR-DNIS-ReAuthentication
11252 USR-PPP-Source-IP-Filter
11253 USR-Auth-Mode
11254 USR-NAS-Type
11255 USR-Request-Type
);

my %reason_codes = (
 0 => 'Success', 
 1 => 'Internal error', 
 2 => 'Access denied',
 3 => 'Malformed request',
 4 => 'Global catalog unavailable',
 5 => 'Domain unavailable',
 6 => 'Server unavailable',
 7 => 'No such domain', 
 8 => 'No such user', 
16 => 'Authentication failure', 
17 => 'Password change failure', 
18 => 'Unsupported authentication type',
19 => 'No reversibly encrypted password is stored for the user account',
32 => 'Local users only', 
33 => 'Password must be changed', 
34 => 'Account disabled', 
35 => 'Account expired', 
36 => 'Account locked out', 
37 => 'Invalid logon hours', 
38 => 'Account restriction', 
48 => 'Did not match remote access policy', 
49 => 'Did not match connection request policy', 
64 => 'Dial-in locked out', 
65 => 'Dial-in disabled', 
66 => 'Invalid authentication type', 
67 => 'Invalid calling station', 
68 => 'Invalid dial-in hours', 
69 => 'Invalid called station', 
70 => 'Invalid port type', 
71 => 'Invalid restriction', 
80 => 'No record',
96 => 'Session timed out', 
97 => 'Unexpected request', 
);

my $enumerate = {
  'NAS-Port-Type' => {
    '11' => 'SDSL - Symmetric DSL',
    '21' => 'FDDI',
    '7' => 'HDLC Clear Channel',
    '17' => 'Cable',
    '2' => 'ISDN Sync',
    '1' => 'Sync (T1 Line)',
    '18' => 'Wireless - Other',
    '0' => 'Async (Modem)',
    '16' => 'xDSL - Digital Subscriber Line of unknown type',
    '13' => 'ADSL-DMT - Asymmetric DSL Discrete Multi-Tone',
    '6' => 'PIAFS',
    '3' => 'ISDN Async V.120',
    '9' => 'X.75',
    '12' => 'ADSL-CAP - Asymmetric DSL Carrierless Amplitude Phase Modulation',
    '20' => 'Token Ring',
    '14' => 'IDSL - ISDN Digital Subscriber Line',
    '15' => 'Ethernet',
    '8' => 'X.25',
    '4' => 'ISDN Async V.110',
    '19' => 'Wireless - IEEE 802.11',
    '10' => 'G.3 Fax',
    '5' => 'Virtual (VPN)'
  },
  'Tunnel-Type' => {
    '6' => 'IP Authentication Header in the Tunnel-mode (AH)',
    '11' => 'Bay Dial Virtual Services (DVS)',
    '3' => 'Layer Two Tunneling Protocol (L2TP)',
    '7' => 'IP-in-IP Encapsulation (IP-IP)',
    '9' => 'IP Encapsulating Security Payload in the Tunnel-mode (ESP)',
    '12' => 'IP-in-IP Tunneling',
    '2' => 'Layer Two Forwarding (L2F)',
    '8' => 'Minimal IP-in-IP Encapsulation (MIN-IP-IP)',
    '1' => 'Point-to-Point Tunneling Protocol (PPTP)',
    '4' => 'Ascend Tunnel Management Protocol (ATMP)',
    '13' => 'Virtual LANs (VLAN)',
    '10' => 'Generic Route Encapsulation (GRE)',
    '5' => 'Virtual Tunneling Protocol (VTP)'
  },
  'USR-Final-Tx-Link-Data-Rate' => {
    '33' => '36000-BPS',
    '32' => '34666-BPS',
    '21' => '28K-BPS',
    '7' => '7200-BPS',
    '26' => '26666-BPS',
    '17' => '57.6K-BPS',
    '2' => '300-BPS',
    '1' => '110-BPS',
    '18' => '21.6K-BPS',
    '30' => '32000-BPS',
    '16' => 'UNKNOWN-BPS',
    '44' => '50666-BPS',
    '27' => '28000-BPS',
    '25' => '25333-BPS',
    '28' => '29333-BPS',
    '40' => '45333-BPS',
    '20' => '26K-BPS',
    '14' => '75-BPS',
    '49' => '57333-BPS',
    '24' => '33K-BPS',
    '10' => '14.4K-BPS',
    '31' => '33333-BPS',
    '35' => '38666-BPS',
    '11' => '16.8-BPS',
    '53' => '62666-BPS',
    '48' => '56000-BPS',
    '42' => '48000-BPS',
    '22' => '115K-BPS',
    '46' => '53333-BPS',
    '13' => '38.4K-BPS',
    '23' => '31K-BPS',
    '29' => '30666-BPS',
    '6' => '4800-BPS',
    '50' => '58666-BPS',
    '39' => '44000-BPS',
    '36' => '40000-BPS',
    '3' => '600-BPS',
    '51' => '60000-BPS',
    '9' => '12K-BPS',
    '41' => '46666-BPS',
    '12' => '19.2K-BPS',
    '47' => '54666-BPS',
    '15' => '450-BPS',
    '52' => '61333-BPS',
    '38' => '42666-BPS',
    '8' => '9600-BPS',
    '4' => '1200-BPS',
    '34' => '37333-BPS',
    '45' => '52000-BPS',
    '37' => '41333-BPS',
    '43' => '49333-BPS',
    '19' => '24K-BPS',
    '54' => '64000-BPS',
    '5' => '2400-BPS'
  },
  'Client-Vendor' => {
    '2352' => 'RedBack Networks',
    '181' => 'ADC Kentrox',
    '307' => 'Livingston Enterprises, Inc.',
    '166' => 'Shiva Corporation',
    '1' => 'Proteon',
    '434' => 'EICON',
    '244' => 'Lantronix',
    '0' => 'RADIUS Standard',
    '562' => 'Nortel Networks',
    '272' => 'BinTec Communications GmbH',
    '64' => 'Gandalf',
    '332' => 'Digi International',
    '9' => 'Cisco',
    '429' => 'U.S. Robotics, Inc.',
    '15' => 'Xylogics, Inc.',
    '14' => 'BBN',
    '52' => 'Cabletron Systems',
    '529' => 'Ascend Communications Inc.',
    '117' => 'Telebit',
    '43' => '3Com',
    '311' => 'Microsoft',
    '5' => 'ACC',
    '343' => 'Intel Corporation'
  },
  'Manipulation-Target' => {
    '1' => 'User-Name',
    '30' => 'Called-Station-Id',
    '31' => 'Calling-Station-Id'
  },
  'USR-IP-Default-Route-Option' => {
    '1' => 'enabled',
    '2' => 'disabled'
  },
  'Ascend-FR-Direct' => {
    '1' => 'FR-Direct-Yes',
    '0' => 'FR-Direct-No'
  },
  'Ascend-Callback' => {
    '1' => 'Callback-Yes',
    '0' => 'Callback-No'
  },
  'Acct-Terminate-Cause' => {
    '11' => 'NAS-Reboot',
    '21' => 'Port-Reinit',
    '7' => 'Admin-Reboot',
    '17' => 'User-Error',
    '2' => 'Lost-Carrier',
    '22' => 'Port-Disabled',
    '1' => 'User-Request',
    '18' => 'Host-Request',
    '13' => 'Port-Preempted',
    '16' => 'Callback',
    '6' => 'Admin-Reset',
    '3' => 'Lost-Service',
    '9' => 'NAS-Error',
    '12' => 'Port-Unneeded',
    '20' => 'Reauthentication-Failure',
    '14' => 'Port-Suspended',
    '15' => 'Service-Unavailable',
    '8' => 'Port-Error',
    '4' => 'Idle-Timeout',
    '19' => 'Supplicant-Restart',
    '10' => 'NAS-Request',
    '5' => 'Session-Timeout'
  },
  'Tunnel-Medium-Type' => {
    '6' => '802 (includes all 802 media plus Ethernet canonical format)',
    '11' => 'IPX',
    '3' => 'NSAP',
    '7' => 'E.163 (POTS)',
    '9' => 'F.69 (Telex)',
    '12' => 'Appletalk',
    '2' => 'IP6 (IP version 6)',
    '15' => 'E.164 with NSAP format subaddress',
    '14' => 'Banyan Vines',
    '8' => 'E.164 (SMDS Frame Relay ATM)',
    '1' => 'IP (IP version 4)',
    '4' => 'HDLC (8-bit multidrop)',
    '13' => 'Decnet IV',
    '10' => 'X.121 (X.25 Frame Relay)',
    '5' => 'BBN 1822'
  },
  'ARAP-Zone-Access' => {
    '4' => 'Use zone filter exclusively',
    '1' => 'Only allow access to default zone',
    '3' => '(not used)',
    '2' => 'Use zone filter inclusively'
  },
  'USR-Tunnel-Security' => {
    '1' => 'Control-Only',
    '3' => 'Both-Data-and-Control',
    '0' => 'None',
    '2' => 'Data-Only'
  },
  'USR-Fallback-Enabled' => {
    '1' => 'Disabled',
    '2' => 'Enabled'
  },
  'NP-Allowed-Port-Types' => {
    '11' => 'SDSL - Symmetric DSL',
    '21' => 'FDDI',
    '7' => 'HDLC Clear Channel',
    '17' => 'Cable',
    '2' => 'ISDN Sync',
    '1' => 'Sync (T1 Line)',
    '18' => 'Wireless - Other',
    '0' => 'Async (Modem)',
    '16' => 'xDSL - Digital Subscriber Line of unknown type',
    '13' => 'ADSL-DMT - Asymmetric DSL Discrete Multi-Tone',
    '6' => 'PIAFS',
    '3' => 'ISDN Async V.120',
    '9' => 'X.75',
    '12' => 'ADSL-CAP - Asymmetric DSL Carrierless Amplitude Phase Modulation',
    '20' => 'Token Ring',
    '14' => 'IDSL - ISDN Digital Subscriber Line',
    '15' => 'Ethernet',
    '8' => 'X.25',
    '4' => 'ISDN Async V.110',
    '19' => 'Wireless - IEEE 802.11',
    '10' => 'G.3 Fax',
    '5' => 'Virtual (VPN)'
  },
  'USR-RMMIE-Status' => {
    '1' => 'notEnabledInLocalModem',
    '3' => 'ok',
    '2' => 'notDetectedInRemoteModem'
  },
  'USR-Originate-Answer-Mode' => {
    '4' => 'Answer-in-Answer-Mode',
    '1' => 'Originate-in-Originate-Mode',
    '3' => 'Answer-in-Originate-Mode',
    '2' => 'Originate-in-Answer-Mode'
  },
  'Ascend-PW-Lifetime' => {
    '0' => 'Lifetime-In-Days'
  },
  'Ascend-Send-Auth' => {
    '1' => 'Send-Auth-PAP',
    '0' => 'Send-Auth-None',
    '2' => 'Send-Auth-CHAP'
  },
  'Ascend-Bridge' => {
    '1' => 'Bridge-Yes',
    '0' => 'Bridge-No'
  },
  'USR-Routing-Protocol' => {
    '1' => 'Rip1',
    '2' => 'Rip2'
  },
  'USR-Simplified-MNP-Levels' => {
    '6' => 'synchronousNone',
    '11' => 'lapmEc',
    '3' => 'mnpLevel4',
    '7' => 'mnpLevel2',
    '9' => 'v42Etc',
    '12' => 'v42Etc2',
    '2' => 'mnpLevel3',
    '14' => 'piafs',
    '8' => 'mnp10',
    '1' => 'none',
    '4' => 'ccittV42',
    '13' => 'ccittV42SREJ',
    '10' => 'mnp10Ec',
    '5' => 'usRoboticsHST'
  },
  'Termination-Action' => {
    '1' => 'RADIUS-Request',
    '0' => 'Default'
  },
  'USR-Expansion-Algorithm' => {
    '1' => 'Constant',
    '2' => 'Linear'
  },
  'USR-Back-Channel-Data-Rate' => {
    '1' => '450BPS',
    '3' => 'None',
    '2' => '300BPS'
  },
  'USR-Failure-to-Connect-Reason' => {
    '33' => 'v32Cleardown',
    '32' => 'none',
    '63' => 'tokenPassingTimeout',
    '21' => 'noAnswerTone',
    '71' => 'priDialoutRqTimeout',
    '7' => 'undefined',
    '26' => 'v42DisconnectCmd',
    '18' => 'lineBusy',
    '72' => 'abortAnlgDstOvrIsdn',
    '16' => 'noDialTone',
    '44' => 'linkAbort',
    '55' => 'pbReceivedLsWhileLinkUp',
    '74' => 'normalUnspecified',
    '27' => 'v42IdExchangeFail',
    '57' => 'pbBadFrame',
    '61' => 'pbReceiveMsgBufOvrflw',
    '20' => 'voice',
    '10' => 'retransmitLimit',
    '31' => 'v42InvalidCommand',
    '35' => 'remoteAccessDenied',
    '11' => 'linkDisconnectMsgRec',
    '78' => 'invalidCauseValue',
    '48' => 'pbLinkErrTxTardyACK',
    '77' => 'abnormalDisconnect',
    '65' => 'mnpProtocolViolation',
    '29' => 'v42InvalidCodeWord',
    '50' => 'pbReceiveBusTimeout',
    '39' => 'noPromptingInSync',
    '64' => 'dspInterruptTimeout',
    '58' => 'pbAckWaitTimeout',
    '41' => 'modeIncompatible',
    '12' => 'noLoopCurrent',
    '15' => 'managementCommand',
    '52' => 'pbLinkErrRxTAL',
    '60' => 'pbReceiveOvrflwRNRFail',
    '56' => 'pbOutOfSequenceFrame',
    '66' => 'class2FaxHangupCmd',
    '73' => 'normalUserCallClear',
    '45' => 'autopassFailed',
    '76' => 'protocolErrorEvent',
    '19' => 'noAnswer',
    '62' => 'rcvdGatewayDiscCmd',
    '54' => 'pbClockMissing',
    '67' => 'hstSpeedSwitchTimeout',
    '70' => 't1Glare',
    '68' => 'tooManyUnacked',
    '2' => 'escapeSequence',
    '17' => 'keyAbort',
    '1' => 'dtrDrop',
    '30' => 'v42StringToLong',
    '25' => 'v42BreakTimeout',
    '28' => 'v42BadSetup',
    '75' => 'bearerIncompatibility',
    '40' => 'nonArqMode',
    '14' => 'unableToRetrain',
    '69' => 'timerExpired',
    '59' => 'pbReceivedAckSeqErr',
    '49' => 'pbTransmitBusTimeout',
    '24' => 'v42SabmeTimeout',
    '53' => 'pbTransmitMasterTimeout',
    '22' => 'noCarrier',
    '42' => 'noPromptInNonARQ',
    '46' => 'pbGenericError',
    '23' => 'undetermined',
    '13' => 'invalidSpeed',
    '6' => 'mnpIncompatible',
    '3' => 'athCommand',
    '36' => 'loopLoss',
    '9' => 'linkPassword',
    '51' => 'pbLinkErrTxTAL',
    '47' => 'pbLinkErrTxPreAck',
    '8' => 'remotePassword',
    '38' => 'promptNotEnabled',
    '4' => 'carrierLoss',
    '34' => 'dialSecurity',
    '37' => 'ds0Teardown',
    '43' => 'dialBackLink',
    '5' => 'inactivityTimout'
  },
  'Login-Service' => {
    '6' => 'X25-T3POS',
    '3' => 'Portmaster (proprietary)',
    '2' => 'TCP Clear',
    '8' => 'TCP Clear Quiet (suppresses any NAS-generated connect string)',
    '1' => 'Rlogin',
    '4' => 'LAT',
    '0' => 'Telnet',
    '5' => 'X25-PAD'
  },
  'USR-Device-Connected-To' => {
    '1' => 'None',
    '3' => 'quadModem',
    '2' => 'isdnGateway'
  },
  'Auth-Provider-Type' => {
    '1' => 'Windows',
    '0' => 'None',
    '2' => 'RADIUS Proxy'
  },
  'Ascend-Force56' => {
    '1' => 'Force-56-Yes',
    '0' => 'Force-56-No'
  },
  'USR-NAS-Type' => {
    '6' => 'Generic-RADIUS',
    '4' => '3Com-SA-Server',
    '1' => '3Com-NETServer',
    '3' => 'TACACS+-Server',
    '0' => '3Com-NMC',
    '7' => '3Com-NETBuilder-II',
    '2' => '3Com-HiPerArc',
    '5' => 'Ascend'
  },
  'USR-Filter-Zones' => {
    '1' => 'enabled',
    '2' => 'disabled'
  },
  'Acct-Provider-Type' => {
    '2' => 'RADIUS Proxy'
  },
  'Framed-Compression' => {
    '1' => 'Van Jacobson TCP/IP header compression',
    '3' => 'Stac-LZS compression',
    '0' => 'None',
    '2' => 'IPX Header compression'
  },
  'USR-Initial-Rx-Link-Data-Rate' => {
    '33' => '36000-BPS',
    '32' => '34666-BPS',
    '21' => '28K-BPS',
    '7' => '7200-BPS',
    '26' => '26666-BPS',
    '17' => '57.6K-BPS',
    '2' => '300-BPS',
    '1' => '110-BPS',
    '18' => '21.6K-BPS',
    '30' => '32000-BPS',
    '16' => 'UNKNOWN-BPS',
    '44' => '50666-BPS',
    '27' => '28000-BPS',
    '25' => '25333-BPS',
    '28' => '29333-BPS',
    '40' => '45333-BPS',
    '20' => '26K-BPS',
    '14' => '75-BPS',
    '49' => '57333-BPS',
    '24' => '33K-BPS',
    '10' => '14.4K-BPS',
    '31' => '33333-BPS',
    '35' => '38666-BPS',
    '11' => '16.8-BPS',
    '53' => '62666-BPS',
    '48' => '56000-BPS',
    '42' => '48000-BPS',
    '22' => '115K-BPS',
    '46' => '53333-BPS',
    '13' => '38.4K-BPS',
    '23' => '31K-BPS',
    '29' => '30666-BPS',
    '6' => '4800-BPS',
    '50' => '58666-BPS',
    '39' => '44000-BPS',
    '36' => '40000-BPS',
    '3' => '600-BPS',
    '51' => '60000-BPS',
    '9' => '12K-BPS',
    '41' => '46666-BPS',
    '12' => '19.2K-BPS',
    '47' => '54666-BPS',
    '15' => '450-BPS',
    '52' => '61333-BPS',
    '38' => '42666-BPS',
    '8' => '9600-BPS',
    '4' => '1200-BPS',
    '34' => '37333-BPS',
    '45' => '52000-BPS',
    '37' => '41333-BPS',
    '43' => '49333-BPS',
    '19' => '24K-BPS',
    '54' => '64000-BPS',
    '5' => '2400-XBPS'
  },
  'USR-Default-DTE-Data-Rate' => {
    '11' => '16.8-BPS',
    '21' => '28K-BPS',
    '7' => '7200-BPS',
    '17' => '57.6K-BPS',
    '2' => '300-BPS',
    '22' => '115K-BPS',
    '1' => '110-BPS',
    '18' => '21.6K-BPS',
    '16' => 'UNKNOWN-BPS',
    '13' => '38.4K-BPS',
    '6' => '4800-BPS',
    '3' => '600-BPS',
    '9' => '12K-BPS',
    '12' => '19.2K-BPS',
    '20' => '26K-BPS',
    '14' => '75-BPS',
    '15' => '450-BPS',
    '8' => '9600-BPS',
    '4' => '1200-BPS',
    '19' => '24K-BPS',
    '10' => '14.4K-BPS',
    '5' => '2400-BPS'
  },
  'USR-Event-ID' => {
    '33' => 'Modem-Ring-No-Answer',
    '32' => 'Modem-Reset-by-DTE',
    '90' => 'NTP-Contact-Degraded',
    '63' => 'Connection-Attempt-Failure',
    '21' => 'DTR-True',
    '71' => 'Gateway-Network-Failed',
    '102' => 'RADIUS-Accounting-Group-Restore',
    '7' => 'Module-Removed',
    '80' => 'Psu-Incompatible',
    '26' => 'No-Loop-Current-Detected',
    '119' => 'T1/T1-E1/PRI-InCall-Fail-Event',
    '99' => 'DNS-Contact-Restored',
    '18' => 'Connection-Failed',
    '72' => 'Gateway-Network-Restored',
    '16' => 'In-Connection-Term',
    '44' => 'Dial-Out-Restricted-Number',
    '55' => 'Yellow-Alarm-Clear',
    '84' => 'T1 T1-E1/PRI-Call-Failed-Event',
    '74' => 'Packet-Bus-Clock-Restored',
    '27' => 'Yellow-Alarm',
    '95' => 'Changed-to-Maint-Srvs-State',
    '57' => 'Loss-Of-Signal-Clear',
    '61' => 'Incoming-Connection-Terminated',
    '20' => 'DTE-Transmit-Idle',
    '92' => 'Out-Connection-Failed',
    '103' => 'RADIUS-Accounting-Group-Degrade',
    '89' => 'IPGW-Link-Down',
    '10' => 'HUB-Temp-Out-of-Range',
    '31' => 'Timing-Source-Switch',
    '35' => 'Pkt-Bus-Session-Active',
    '11' => 'Fan-Failed',
    '91' => 'In-Connection-Failed',
    '78' => 'DS0s-Out-of-Service',
    '48' => 'Response-Attempt-Limit-Exceeded',
    '87' => 'NTP-Contact-Restored',
    '93' => 'Application-ProcessorReset',
    '77' => 'DS0s-In-Service',
    '65' => 'Continuous-CRC-Alarm-Clear',
    '29' => 'Loss-Of-Signal',
    '50' => 'Dial-Out-Call-Duration',
    '39' => 'User-Interface-Reset',
    '64' => 'Continuous-CRC-Alarm',
    '97' => 'Loop-Back-on-channel',
    '58' => 'Rcv-Alrm-Ind-Signal-Clear',
    '41' => 'Gateway-Port-Link-Active',
    '12' => 'Watchdog-Timeout',
    '15' => 'Out-Connection-Est',
    '81' => 'T1 T1-E1/PRI-Call-Arrive-Event',
    '52' => 'Pkt-Bus-Session-Err-Status',
    '60' => 'Outgoing-Connection-Established',
    '56' => 'Red-Alarm-Clear',
    '101' => 'RADIUS-Accounting-Restored',
    '73' => 'Packet-Bus-Clock-Lost',
    '66' => 'Physical-State-Change',
    '45' => 'Dial-Back-Restricted-Number',
    '86' => 'NTP-Contact-Lost',
    '76' => 'D-Channel-Out-of-Service',
    '19' => 'Connection-Timeout',
    '62' => 'Outgoing-Connection-Terminated',
    '54' => 'Acct-Server-Contact-Loss',
    '17' => 'Out-Connection-Term',
    '88' => 'IPGW-Link-Up',
    '30' => 'Rcv-Alrm-Ind-Signal',
    '100' => 'DNS-Contact-Degraded',
    '82' => 'T1 T1-E1/PRI-Call-Connect-Event',
    '25' => 'No-Dial-Tone-Detected',
    '120' => 'T1/T1-E1/PRI-OutCall-Fail-Event',
    '28' => 'Red-Alarm',
    '83' => 'T1 T1-E1/PRI-Call-Termina-Event',
    '75' => 'D-Channel-In-Service',
    '40' => 'Gateway-Port-Out-of-Service',
    '192' => 'CDMA-Call-End',
    '14' => 'In-Connection-Est',
    '59' => 'Incoming-Connection-Established',
    '191' => 'CDMA-Call-Start',
    '49' => 'Login-Attempt-Limit-Exceeded',
    '24' => 'Fallbacks-at-Threshold',
    '104' => 'RADIUS-Accounting-Group-NonOper',
    '53' => 'NMC-AutoRespnse-Trap',
    '122' => 'RMMIE-Speed-Shift-Event',
    '121' => 'RMMIE-Retrain-Event',
    '79' => 'T1/T1PRI/E1PRI-Call-Event',
    '22' => 'DTR-False',
    '42' => 'Dial-Out-Login-Failure',
    '46' => 'User-Blacklisted',
    '23' => 'Block-Error-at-Threshold',
    '13' => 'Mgmt-Bus-Failure',
    '96' => 'Loop-Back-cleared-on-channel',
    '6' => 'Module-Inserted',
    '85' => 'DNS-Contact-Lost',
    '36' => 'Pkt-Bus-Session-Congestion',
    '94' => 'DSP-Reset',
    '9' => 'PSU-Failed',
    '51' => 'Dial-In-Call-Duration',
    '47' => 'Attempted-Login-Blacklisted',
    '8' => 'PSU-Voltage-Alarm',
    '38' => 'Pkt-Bus-Session-Inactive',
    '98' => 'Telco-Abnormal-Response',
    '34' => 'DTE-Ring-No-Answer',
    '37' => 'Pkt-Bus-Session-Lost',
    '43' => 'Dial-In-Login-Failure'
  },
  'USR-Final-Rx-Link-Data-Rate' => {
    '33' => '36000-BPS',
    '32' => '34666-BPS',
    '21' => '28K-BPS',
    '7' => '7200-BPS',
    '26' => '26666-BPS',
    '17' => '57.6K-BPS',
    '2' => '300-BPS',
    '1' => '110-BPS',
    '18' => '21.6K-BPS',
    '30' => '32000-BPS',
    '16' => 'UNKNOWN-BPS',
    '44' => '50666-BPS',
    '27' => '28000-BPS',
    '25' => '25333-BPS',
    '28' => '29333-BPS',
    '40' => '45333-BPS',
    '20' => '26K-BPS',
    '14' => '75-BPS',
    '49' => '57333-BPS',
    '24' => '33K-BPS',
    '10' => '14.4K-BPS',
    '31' => '33333-BPS',
    '35' => '38666-BPS',
    '11' => '16.8-BPS',
    '53' => '62666-BPS',
    '48' => '56000-BPS',
    '42' => '48000-BPS',
    '22' => '115K-BPS',
    '46' => '53333-BPS',
    '13' => '38.4K-BPS',
    '23' => '31K-BPS',
    '29' => '30666-BPS',
    '6' => '4800-BPS',
    '50' => '58666-BPS',
    '39' => '44000-BPS',
    '36' => '40000-BPS',
    '3' => '600-BPS',
    '51' => '60000-BPS',
    '9' => '12K-BPS',
    '41' => '46666-BPS',
    '12' => '19.2K-BPS',
    '47' => '54666-BPS',
    '15' => '450-BPS',
    '52' => '61333-BPS',
    '38' => '42666-BPS',
    '8' => '9600-BPS',
    '4' => '1200-BPS',
    '34' => '37333-BPS',
    '45' => '52000-BPS',
    '37' => '41333-BPS',
    '43' => '49333-BPS',
    '19' => '24K-BPS',
    '54' => '64000-BPS',
    '5' => '2400-BPS'
  },
  'Ascend-History-Weigh-Type' => {
    '1' => 'History-Linear',
    '0' => 'History-Constant',
    '2' => 'History-Quadratic'
  },
  'USR-PW-Framed-Routing-V2' => {
    '1' => 'On',
    '0' => 'Off'
  },
  'USR-Auth-Mode' => {
    '6' => 'Auth-Netware',
    '3' => 'Auth-UNIX-PW',
    '7' => 'Auth-Skey',
    '9' => 'Auth-UNIX-Crypt',
    '2' => 'Auth-Safeword',
    '8' => 'Auth-EAP-Proxy',
    '1' => 'Auth-Ace',
    '4' => 'Auth-Defender',
    '0' => 'Auth-3Com',
    '5' => 'Auth-TACACSP'
  },
  'USR-Bridging' => {
    '1' => 'enabled',
    '2' => 'disabled'
  },
  'USR-Appletalk' => {
    '1' => 'enabled',
    '2' => 'disabled'
  },
  'Framed-Protocol' => {
    '6' => 'X.75 Synchronous',
    '261' => 'FR',
    '3' => 'AppleTalk Remote Access Protocol (ARAP)',
    '259' => 'X25',
    '2' => 'SLIP',
    '258' => 'EUUI',
    '4' => 'Gandalf Proprietary SingleLink/MultiLink protocol',
    '1' => 'PPP',
    '256' => 'MPP',
    '260' => 'COMB',
    '257' => 'EURAW',
    '5' => 'Xylogics proprietary IPX/SLIP'
  },
  'USR-Connect-Term-Reason' => {
    '33' => 'v32Cleardown',
    '32' => 'none',
    '63' => 'tokenPassingTimeout',
    '21' => 'noAnswerTone',
    '71' => 'priDialoutRqTimeout',
    '7' => 'undefined',
    '26' => 'v42DisconnectCmd',
    '18' => 'lineBusy',
    '72' => 'abortAnlgDstOvrIsdn',
    '16' => 'noDialTone',
    '44' => 'linkAbort',
    '55' => 'pbReceivedLsWhileLinkUp',
    '74' => 'normalUnspecified',
    '27' => 'v42IdExchangeFail',
    '57' => 'pbBadFrame',
    '61' => 'pbReceiveMsgBufOvrflw',
    '20' => 'voice',
    '10' => 'retransmitLimit',
    '31' => 'v42InvalidCommand',
    '35' => 'remoteAccessDenied',
    '11' => 'linkDisconnectMsgReceived',
    '78' => 'invalidCauseValue',
    '48' => 'pbLinkErrTxTardyACK',
    '77' => 'abnormalDisconnect',
    '65' => 'mnpProtocolViolation',
    '29' => 'v42InvalidCodeWord',
    '50' => 'pbReceiveBusTimeout',
    '39' => 'noPromptingInSync',
    '64' => 'dspInterruptTimeout',
    '58' => 'pbAckWaitTimeout',
    '41' => 'modeIncompatible',
    '12' => 'noLoopCurrent',
    '15' => 'managementCommand',
    '52' => 'pbLinkErrRxTAL',
    '60' => 'pbReceiveOvrflwRNRFail',
    '56' => 'pbOutOfSequenceFrame',
    '73' => 'normalUserCallClear',
    '66' => 'class2FaxHangupCmd',
    '45' => 'autopassFailed',
    '76' => 'protocolErrorEvent',
    '19' => 'noAnswer',
    '62' => 'rcvdGatewayDiscCmd',
    '54' => 'pbClockMissing',
    '67' => 'hstSpeedSwitchTimeout',
    '70' => 't1Glare',
    '68' => 'tooManyUnacked',
    '2' => 'escapeSequence',
    '17' => 'keyAbort',
    '1' => 'dtrDrop',
    '30' => 'v42StringToLong',
    '25' => 'v42BreakTimeout',
    '28' => 'v42BadSetup',
    '75' => 'bearerIncompatibility',
    '40' => 'nonArqMode',
    '14' => 'unableToRetrain',
    '69' => 'timerExpired',
    '59' => 'pbReceivedAckSeqErr',
    '49' => 'pbTransmitBusTimeout',
    '24' => 'v42SabmeTimeout',
    '53' => 'pbTransmitMasterTimeout',
    '22' => 'noCarrier',
    '42' => 'noPromptInNonARQ',
    '46' => 'pbGenericError',
    '23' => 'undetermined',
    '13' => 'invalidSpeed',
    '6' => 'mnpIncompatible',
    '3' => 'athCommand',
    '36' => 'loopLoss',
    '9' => 'linkPassword',
    '51' => 'pbLinkErrTxTAL',
    '47' => 'pbLinkErrTxPreAck',
    '8' => 'remotePassword',
    '38' => 'promptNotEnabled',
    '4' => 'carrierLoss',
    '34' => 'dialSecurity',
    '37' => 'ds0Teardown',
    '43' => 'dialBackLink',
    '5' => 'inactivityTimout'
  },
  'USR-Syslog-Tap' => {
    '1' => 'Raw',
    '0' => 'Off',
    '2' => 'Framed'
  },
  'Authentication-Type' => {
    '3' => 'MS-CHAP v1',
    '7' => 'Unauthenticated',
    '9' => 'MS-CHAP v1 CPW',
    '2' => 'CHAP',
    '8' => 'Extension',
    '1' => 'PAP',
    '4' => 'MS-CHAP v2',
    '10' => 'MS-CHAP v2 CPW',
    '5' => 'EAP'
  },
  'USR-Card-Type' => {
    '33' => 'NTServerNAC',
    '32' => 'ModemPoolISDNNAC',
    '7' => 'TrGatewayNAC',
    '26' => 'ISDNGatewayNAC',
    '1026' => 'BellcoreShrtHaulDualT1NIC',
    '18' => 'AccessServer',
    '1004' => 'QuadAlogDgtlMdmNIC',
    '16' => 'SingleT1NAC',
    '1018' => 'HSEthernetWithV35NIC',
    '44' => 'EnhancedAccessServer',
    '1020' => 'DualHighSpeedV35NIC',
    '1007' => 'EthernetNIC',
    '27' => 'ISDNpriT1NAC',
    '1013' => 'QuadAlogNonMgdIntlMdmNIC',
    '1012' => 'QuadAlogMgdIntlMdmNIC',
    '1008' => 'ShortHaulDualT1NIC',
    '20' => '486EthernetGatewayNAC',
    '1027' => 'SCSIEdgeServerNIC',
    '1001' => 'DualT1NIC',
    '1011' => 'QuadAlogNonMgdMdmNIC',
    '1021' => 'QuadV35RS232LowSpeedNIC',
    '1014' => 'QuadLsdLiMgdMdmNIC',
    '10' => 'QuadV32DigitalModemNAC',
    '31' => 'ModemPoolV34ModemNAC',
    '35' => 'QuadV34AnalogG2NAC',
    '11' => 'QuadV32AnalogModemNAC',
    '1019' => 'HSEthernetWithoutV35NIC',
    '1022' => 'DualE1NIC',
    '1010' => 'X25NIC',
    '29' => 'ModemPoolManagementNAC',
    '39' => 'X2524ChannelNAC',
    '12' => 'QuadV32DigAnlModemNAC',
    '15' => 'QuadV34DigAnlModemNAC',
    '1023' => 'ShortHaulDualE1NIC',
    '45' => 'EnhancedISDNGatewayNAC',
    '19' => '486TrGatewayNAC',
    '1002' => 'DualAlogMdmNIC',
    '2' => 'SlotUnknown',
    '17' => 'EthernetGatewayNAC',
    '1' => 'SlotEmpty',
    '1009' => 'DualAlogMgdIntlMdmNIC',
    '30' => 'ModemPoolNetserverNAC',
    '25' => 'ApplicationServerNAC',
    '1005' => 'TokenRingNIC',
    '28' => 'ClkedNetMgtCard',
    '14' => 'QuadV34AnlModemNAC',
    '22' => 'DualRS232NAC',
    '42' => 'WirelessGatewayNac',
    '1016' => 'QuadLsdLiMgdIntlMdmNIC',
    '23' => '486X25GatewayNAC',
    '13' => 'QuadV34DigModemNAC',
    '1006' => 'SingleT1NIC',
    '6' => 'QuadModemNAC',
    '36' => 'QuadV34DigAnlgG2NAC',
    '3' => 'NetwMgtCard',
    '9' => 'DualV34ModemNAC',
    '1003' => 'QuadDgtlMdmNIC',
    '1025' => 'BellcoreLongHaulDualT1NIC',
    '1015' => 'QuadLsdLiNonMgdMdmNIC',
    '8' => 'X25GatewayNAC',
    '38' => 'NETServerTokenRingNAC',
    '4' => 'DualT1NAC',
    '34' => 'QuadV34DigitalG2NAC',
    '37' => 'NETServerFrameRelayNAC',
    '1017' => 'QuadLsdLiNonMgdIntlMdmNIC',
    '5' => 'DualModemNAC'
  },
  'Ascend-Route-IPX' => {
    '1' => 'Route-IPX-Yes',
    '0' => 'Route-IPX-No'
  },
  'Packet-Type' => {
    '11' => 'Access-Challenge',
    '3' => 'Access-Reject',
    '12' => 'Status-Server (experimental)',
    '2' => 'Access-Accept',
    '1' => 'Access-Request',
    '4' => 'Accounting-Request',
    '13' => 'Status-Client (experimental)',
    '255' => 'Reserved',
    '5' => 'Accounting-Response'
  },
  'Ascend-Link-Compression' => {
    '1' => 'Link-Comp-Stac',
    '0' => 'Link-Comp-None'
  },
  'Acct-Status-Type' => {
    '11' => 'Tunnel-Reject',
    '3' => 'Interim Update',
    '7' => 'Accounting-On',
    '9' => 'Tunnel-Start',
    '12' => 'Tunnel-Link-Start',
    '2' => 'Stop',
    '14' => 'Tunnel-Link-Reject',
    '15' => 'Failed',
    '8' => 'Accounting-Off',
    '1' => 'Start',
    '13' => 'Tunnel-Link-Stop',
    '10' => 'Tunnel-Stop'
  },
  'USR-Equalization-Type' => {
    '1' => 'Long',
    '2' => 'Short'
  },
  'Ascend-Handle-IPX' => {
    '1' => 'Handle-IPX-Client',
    '0' => 'Handle-IPX-None',
    '2' => 'Handle-IPX-Server'
  },
  'Ascend-Data-Svc' => {
    '33' => 'Switched-1728K',
    '32' => 'Switched-1664K',
    '21' => 'Switched-896K',
    '7' => 'Switched-1536K',
    '26' => 'Switched-1216K',
    '2' => 'Nailed-64K',
    '17' => 'Switched-640K',
    '1' => 'Nailed-56KR',
    '18' => 'Switched-704K',
    '30' => 'Switched-1472K',
    '16' => 'Switched-576K',
    '25' => 'Switched-1152K',
    '27' => 'Switched-1280K',
    '28' => 'Switched-1344K',
    '40' => 'Switched-restricted-64-x30',
    '20' => 'Switched-832K',
    '14' => 'Switched-448K',
    '24' => 'Switched-1088K',
    '10' => 'Switched-192K',
    '31' => 'Switched-1600K',
    '35' => 'Switched-1856K',
    '11' => 'Switched-256K',
    '42' => 'Switched-modem',
    '22' => 'Switched-960K',
    '0' => 'Switched-Voice-Bearer',
    '23' => 'Switched-1024K',
    '13' => 'Switched-384K-MR',
    '29' => 'Switched-1408K',
    '6' => 'Switched-384K',
    '39' => 'Switched-clear-bearer-v110',
    '36' => 'Switched-1920K',
    '3' => 'Switched-64KR',
    '9' => 'Switched-128K',
    '41' => 'Switched-clear-56-v110',
    '12' => 'Switched-320K',
    '15' => 'Switched-512K',
    '38' => 'Switched-restricted-bearer-x30',
    '8' => 'Switched-1536KR',
    '4' => 'Switched-56K',
    '34' => 'Switched-1792K',
    '37' => 'Switched-inherited',
    '43' => 'Switched-atmodem',
    '19' => 'Switched-768K',
    '5' => 'Switched-384KR'
  },
  'Framed-Routing' => {
    '1' => 'Send',
    '3' => 'Send-Listen',
    '0' => 'None',
    '2' => 'Listen'
  },
  'Ascend-Route-IP' => {
    '1' => 'Route-IP-Yes',
    '0' => 'Route-IP-No'
  },
  'USR-Speed-Of-Connection' => {
    '1' => '56',
    '3' => 'Voice',
    '0' => 'Auto',
    '2' => '64'
  },
  'USR-Connect-Speed' => {
    '33' => '50666-BPS',
    '32' => '49333-BPS',
    '21' => '26400-BPS',
    '7' => '9600-BPS',
    '26' => '41333-BPS',
    '17' => '288000-BPS',
    '2' => '300-BPS',
    '1' => 'NONE',
    '18' => '75-1200-BPS',
    '30' => '46666-BPS',
    '16' => '115200-BPS',
    '44' => '30666-BPS',
    '27' => '42666-BPS',
    '25' => '37333-BPS',
    '28' => '44000-BPS',
    '40' => '25333-BPS',
    '20' => '24000-BPS',
    '14' => '38400-BPS',
    '49' => '40000-BPS',
    '24' => '33333-BPS',
    '10' => '16800-BPS',
    '31' => '48000-BPS',
    '35' => '53333-BPS',
    '11' => '19200-BPS',
    '53' => '62666-BPS',
    '48' => '38666-BPS',
    '42' => '28000-BPS',
    '22' => '31200-BPS',
    '46' => '34666-BPS',
    '13' => '28800-BPS',
    '23' => '33600-BPS',
    '29' => '45333-BPS',
    '6' => '7200-BPS',
    '50' => '58666-BPS',
    '39' => '64000-BPS',
    '36' => '54666-BPS',
    '3' => '1200-BPS',
    '51' => '60000-BPS',
    '9' => '14400-BPS',
    '41' => '26666-BPS',
    '12' => '21600-BPS',
    '47' => '36000-BPS',
    '15' => '57600-BPS',
    '52' => '61333-BPS',
    '38' => '57333-BPS',
    '8' => '12000-BPS',
    '4' => '2400-BPS',
    '34' => '52000-BPS',
    '45' => '32000-BPS',
    '37' => '56000-BPS',
    '43' => '29333-BPS',
    '19' => '1200-75-BPS',
    '5' => '4800-BPS'
  },
  'USR-Callback-Type' => {
    '4' => 'Dynamic',
    '1' => 'Normal',
    '3' => 'Static',
    '2' => 'ANI'
  },
  'USR-CCP-Algorithm' => {
    '4' => 'Any',
    '1' => 'NONE',
    '3' => 'MS',
    '2' => 'Stac'
  },
  'USR-Initial-Tx-Link-Data-Rate' => {
    '33' => '36000-BPS',
    '32' => '34666-BPS',
    '21' => '28K-BPS',
    '7' => '7200-BPS',
    '26' => '26666-BPS',
    '17' => '57.6K-BPS',
    '2' => '300-BPS',
    '1' => '110-BPS',
    '18' => '21.6K-BPS',
    '30' => '32000-BPS',
    '16' => 'UNKNOWN-BPS',
    '44' => '50666-BPS',
    '27' => '28000-BPS',
    '25' => '25333-BPS',
    '28' => '29333-BPS',
    '40' => '45333-BPS',
    '20' => '26K-BPS',
    '14' => '75-BPS',
    '49' => '57333-BPS',
    '24' => '33K-BPS',
    '10' => '14.4K-BPS',
    '31' => '33333-BPS',
    '35' => '38666-BPS',
    '11' => '16.8-BPS',
    '53' => '62666-BPS',
    '48' => '56000-BPS',
    '42' => '48000-BPS',
    '22' => '115K-BPS',
    '46' => '53333-BPS',
    '13' => '38.4K-BPS',
    '23' => '31K-BPS',
    '29' => '30666-BPS',
    '6' => '4800-BPS',
    '50' => '58666-BPS',
    '39' => '44000-BPS',
    '36' => '40000-BPS',
    '3' => '600-BPS',
    '9' => '12K-BPS',
    '51' => '60000-BPS',
    '41' => '46666-BPS',
    '12' => '19.2K-BPS',
    '15' => '450-BPS',
    '47' => '54666-BPS',
    '38' => '42666-BPS',
    '8' => '9600-BPS',
    '52' => '61333-BPS',
    '4' => '1200-BPS',
    '34' => '37333-BPS',
    '45' => '52000-BPS',
    '37' => '41333-BPS',
    '43' => '49333-BPS',
    '19' => '24K-BPS',
    '54' => '64000-BPS',
    '5' => '2400-BPS'
  },
  'USR-RMMIE-Last-Update-Event' => {
    '4' => 'speedShift',
    '1' => 'none',
    '3' => 'retrain',
    '2' => 'initialConnection',
    '5' => 'plannedDisconnect'
  },
  'Provider-Type' => {
    '1' => 'Windows',
    '0' => 'None',
    '2' => 'RADIUS Proxy'
  },
  'Nortel-Port-QOS' => {
    '6' => 'Premium',
    '3' => 'Silver',
    '7' => 'Critical Network',
    '2' => 'Bronze',
    '4' => 'Gold',
    '1' => 'Custom',
    '0' => 'Standard',
    '5' => 'Platinum'
  },
  'Ascend-PW-Warntime' => {
    '0' => 'Days-Of-Warning'
  },
  'USR-Initial-Modulation-Type' => {
    '33' => 'v90Analogue',
    '21' => 'vFC',
    '7' => 'ccittV32bis',
    '26' => 'x75',
    '17' => 'v29FaxClass2',
    '2' => 'ccittV32',
    '1' => 'usRoboticsHST',
    '18' => 'v17FaxClass2',
    '30' => 'x2symmetric',
    '16' => 'v27FaxClass2',
    '27' => 'ayncSyncPPP',
    '25' => 'v120',
    '28' => 'clearChannel',
    '20' => 'v34',
    '14' => 'v17FaxClass1',
    '24' => 'v110',
    '10' => 'bell208b',
    '31' => 'piafs',
    '35' => 'v90AllDigital',
    '11' => 'v21FaxClass1',
    '22' => 'v34plus',
    '13' => 'v29FaxClass1',
    '23' => 'x2',
    '29' => 'x2client',
    '6' => 'bell212',
    '3' => 'ccittV22bis',
    '9' => 'negotiationFailed',
    '12' => 'v27FaxClass1',
    '15' => 'v21FaxClass2',
    '8' => 'ccittV23',
    '4' => 'bell103',
    '34' => 'v90Digital',
    '19' => 'v32Terbo',
    '5' => 'ccittV21'
  },
  'Service-Type' => {
    '6' => 'Administrative',
    '11' => 'Callback Administrative',
    '3' => 'Callback Login',
    '7' => 'NAS Prompt',
    '9' => 'Callback Nas Prompt',
    '2' => 'Framed',
    '8' => 'Authenticate Only',
    '1' => 'Login',
    '4' => 'Callback Framed',
    '10' => 'Call Check',
    '5' => 'Outbound'
  },
  'USR-Call-Event-Code' => {
    '32' => 'outCallConnect',
    '21' => 'analogBlocked',
    '7' => 'modemsNotAllowed',
    '26' => 'protocolError',
    '17' => 'progReject',
    '2' => 'setup',
    '1' => 'notSupported',
    '18' => 'callingPartyReject',
    '30' => 'outCallArrival',
    '16' => 'chidReject',
    '27' => 'noFreeBchannel',
    '25' => 'congestion',
    '28' => 'inOutCallCollision',
    '20' => 'blocked',
    '14' => 'bcReject',
    '24' => 'busy',
    '10' => 'noFreeIGW',
    '31' => 'inCallConnect',
    '11' => 'igwRejectCall',
    '22' => 'digitalBlocked',
    '13' => 'noFreeTdmts',
    '23' => 'outOfService',
    '29' => 'inCallArrival',
    '6' => 'noFreeModem',
    '3' => 'usrSetup',
    '9' => 'modemSetupTimeout',
    '12' => 'igwSetupTimeout',
    '15' => 'ieReject',
    '8' => 'modemsRejectCall',
    '4' => 'telcoDisconnect',
    '19' => 'calledPartyReject',
    '5' => 'usrDisconnect'
  },
  'USR-RMMIE-x2-Status' => {
    '6' => 'invalidSpeedSetting',
    '11' => 'local3200Disabled',
    '3' => 'x2Disabled',
    '7' => 'v8NotDetected',
    '9' => 'incompatibleVersion',
    '12' => 'excessHighFrequencyAtten',
    '2' => 'operational',
    '14' => 'retrainBeforeConnection',
    '8' => 'x2NotDetected',
    '1' => 'notOperational',
    '4' => 'v8Disabled',
    '13' => 'connectNotSupport3200',
    '10' => 'incompatibleModes',
    '5' => 'remote3200Disabled'
  },
  'USR-Spoofing' => {
    '1' => 'enabled',
    '2' => 'disabled'
  },
  'Ascend-PPP-VJ-Slot-Comp' => {
    '1' => 'VJ-Slot-Comp-No'
  },
  'USR-IPX-WAN' => {
    '1' => 'enabled',
    '2' => 'disabled'
  },
  'USR-IPX-Routing' => {
    '4' => 'all',
    '1' => 'send',
    '3' => 'respond',
    '0' => 'none',
    '2' => 'listen'
  },
  'Acct-Authentic' => {
    '1' => 'RADIUS',
    '3' => 'Remote',
    '0' => 'None',
    '2' => 'Local'
  },
  'USR-IP-RIP-Policies' => {
    '128' => 'SimpleAuth',
    '512' => 'V1Receive',
    '32' => 'PoisonReserve',
    '1024' => 'V2Receive',
    '64' => 'FlashUpdate',
    '2' => 'SendRoutes',
    '8' => 'AcceptDefault',
    '4' => 'SendSubnets',
    '2147483647' => 'Silent',
    '0' => 'SendDefault',
    '256' => 'V1Send',
    '16' => 'SplitHorizon'
  },
  'USR-Compression-Algorithm' => {
    '4' => 'Auto',
    '1' => 'Stac',
    '3' => 'Microsoft',
    '0' => 'None',
    '2' => 'Ascend'
  },
  'USR-Modulation-Type' => {
    '33' => 'v90Analogue',
    '21' => 'vFC',
    '7' => 'ccittV32bis',
    '26' => 'x75',
    '17' => 'v29FaxClass2',
    '2' => 'ccittV32',
    '1' => 'usRoboticsHST',
    '18' => 'v17FaxClass2',
    '30' => 'x2symmetric',
    '16' => 'v27FaxClass2',
    '27' => 'ayncSyncPPP',
    '25' => 'v120',
    '28' => 'clearChannel',
    '20' => 'v34',
    '14' => 'v17FaxClass1',
    '24' => 'v110',
    '10' => 'bell208b',
    '31' => 'piafs',
    '35' => 'v90AllDigital',
    '11' => 'v21FaxClass1',
    '22' => 'v34plus',
    '13' => 'v29FaxClass1',
    '23' => 'x2',
    '29' => 'x2client',
    '6' => 'bell212',
    '3' => 'ccittV22bis',
    '9' => 'negotiationFailed',
    '12' => 'v27FaxClass1',
    '15' => 'v21FaxClass2',
    '8' => 'ccittV23',
    '4' => 'bell103',
    '34' => 'v90Digital',
    '19' => 'v32Terbo',
    '5' => 'ccittV21'
  },
  'USR-Simplified-V42bis-Usage' => {
    '1' => 'none',
    '3' => 'mnpLevel5',
    '2' => 'ccittV42bis'
  },
  'Ascend-PPP-VJ-1172' => {
    '1' => 'PPP-VJ-1172'
  },
  'USR-RMMIE-Planned-Disconnect' => {
    '6' => 'athCommand',
    '11' => 'invalidComprDataStringLen',
    '3' => 'dteInterfaceError',
    '7' => 'inactivityTimeout',
    '9' => 'arqProtocolRetransmitLim',
    '12' => 'invalidComprDataCommand',
    '2' => 'dteNotReady',
    '8' => 'arqProtocolError',
    '1' => 'none',
    '4' => 'dteRequest',
    '10' => 'invalidComprDataCodeword',
    '5' => 'escapeToOnlineCommandMode'
  },
  'Ascend-PRI-Number-Type' => {
    '4' => 'Local-Number',
    '1' => 'Intl-Number',
    '0' => 'Unknown-Number',
    '2' => 'National-Number',
    '5' => 'Abbrev-Number'
  },
  'Ascend-IPX-PeerMode' => {
    '1' => 'IPX-Peer-Dialin',
    '0' => 'IPX-Peer-Router'
  },
  'Prompt' => {
    '1' => 'Echo',
    '0' => 'No Echo'
  },
  'USR-Sync-Async-Mode' => {
    '1' => 'Asynchronous',
    '2' => 'Synchronous'
  },
  'USR-Request-Type' => {
    '11' => 'Access-Challenge',
    '21' => 'Resource-Free-Request',
    '7' => 'Access-Password-Change',
    '26' => 'NAS-Reboot-Request',
    '2' => 'Access-Accept',
    '22' => 'Resource-Free-Response',
    '1' => 'Access-Request',
    '255' => 'Reserved',
    '23' => 'Resource-Query-Request',
    '13' => 'Status-Client',
    '27' => 'NAS-Reboot-Response',
    '25' => 'Disconnect-User',
    '3' => 'Access-Reject',
    '253' => 'Tacacs-Message',
    '9' => 'Access-Password-Reject',
    '12' => 'Status-Server',
    '8' => 'Access-Password-Ack',
    '4' => 'Accounting-Request',
    '24' => 'Resource-Query-Response',
    '5' => 'Accounting-Response'
  },
  'USR-Compression-Reset-Mode' => {
    '1' => 'Reset-Every-Packet',
    '0' => 'Auto',
    '2' => 'Reset-On-Error'
  }
};

sub parse_ias {
  my $string = shift || return;
  return __PACKAGE__->new(@_)->parse($string);
}

sub new {
  my $package = shift;
  my %opts = @_;
  $opts{lc $_} = delete $opts{$_} for keys %opts;
  $opts{enumerate} = 1 unless defined $opts{enumerate} and !$opts{enumerate};
  return bless \%opts, $package;
}

sub parse {
  my $self = shift;
  my $raw_line = shift || return;
  $raw_line =~ s/(\x0D\x0A?|\x0A\x0D?)$//;
  my @data = split /,/, $raw_line;
  return unless scalar @data >= 6;
  my @header = splice @data, 0, 6;
  my $record = { @data };
  foreach my $attribute ( keys %{ $record } ) {
    next unless exists $attributes{ $attribute };
    $record->{$attribute} = pack "H*", $record->{$attribute} if $record->{$attribute} =~ /^0x[0-9A-F]+$/i;
    $record->{$attribute} =~ s/[\x00-\x1F]//g;
    $record->{ $attributes{$attribute} } = delete $record->{$attribute};
  }
  if ( $self->{enumerate} ) {
    $record->{'Reason-Code'} = $reason_codes{ $record->{'Reason-Code'} }
      if defined $record->{'Reason-Code'} and exists $reason_codes{ $record->{'Reason-Code'} };
    foreach my $attribute ( keys %{ $record } ) {
	next unless exists $enumerate->{ $attribute };
	next unless exists $enumerate->{ $attribute }->{ $record->{ $attribute } };
	$record->{ $attribute } = $enumerate->{ $attribute }->{ $record->{ $attribute } };
    }
  }
  @$record{qw/NAS-IP-Address User-Name Record-Date Record-Time Service-Name Computer-Name/} = @header;
  return $record;
}

1;
__END__

=head1 NAME

Parse::IASLog - A parser for Microsoft IAS-formatted log entries.

=head1 SYNOPSIS

Function Interface:

  use strict;
  use Data::Dumper;
  use Parse::IASLog;

  while (<>) {
	chomp;
	my $record = parse_ias( $_, enumerate => 0 );
	next unless $record;
	print Dumper( $record );
  }

Object Interface:

  use strict;
  use Data::Dumper;
  use Parse::IASLog;

  my $ias = Parse::IASLog->new( enumerate => 0 );

  while (<>) {
	chomp;
	my $record = $ias->parse( $_ );
	next unless $record;
	print Dumper( $record );
  }

=head1 DESCRIPTION

Parse::IASLog provides a convenient way of parsing lines of text that are formatted in Microsoft
Internet Authentication Service (IAS) log format, where attributes are logged as attribute-value pairs.

The parser takes lines of IAS-formatted text and returns on successful parsing a hashref record containing
the applicable RADIUS attributes and values.

The module provides a perl implementation of the C<Iasparse> tool.

=head1 FUNCTION INTERFACE

Using the module automagically imports 'parse_ias' into your namespace.

=over

=item c<parse_ias>

Takes a string of IAS-formatted text as the first parameter. Subsequent parameter pairs are treated as 
options. See new() for full details regarding optional parameters.
Returns a hashref on success or undef on failure.
See below for the format of the hashref returned.

=back

=head1 OBJECT INTERFACE

=head2 CONSTRUCTOR

=over 

=item C<new>

Creates a new Parse::IASLog object. Takes one optional parameter:

  'enumerate', set to a false value to disable the enumeration of known
	       attribute values, default is 1;

=back

=head2 METHODS

=over 

=item C<parse>

Takes a string of IAS-formatted text. Returns a hashref on success or undef on failure.

The hashref will contain RADIUS attributes as keys. The following C<header> attributes should always
be present:

  'NAS-IP-Address', The IP address of the NAS sending the request;
  'User-Name', The user name that is requesting access;
  'Record-Date', The date that the log was written;
  'Record-Time', The time that the log was written;
  'Service-Name', The name of the service that is running in the RADIUS server;
  'Computer-Name', The name of the RADIUS server;

=back

=head1 AUTHOR

Chris C<BinGOs> Williams <chris@bingosnet.co.uk>

=head1 LICENSE

Copyright E<copy> Chris Williams

This module may be used, modified, and distributed under the same terms as Perl itself. Please see the license that came with your Perl distribution for details.

=head1 SEE ALSO

L<http://technet.microsoft.com/en-us/network/bb643123.aspx>

L<http://en.wikipedia.org/wiki/RADIUS>
