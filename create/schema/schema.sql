-- 
-- ZABBIX
-- Copyright (C) 2000-2005 SIA Zabbix
--
-- This program is free software; you can redistribute it and/or modify
-- it under the terms of the GNU General Public License as published by
-- the Free Software Foundation; either version 2 of the License, or
-- (at your option) any later version.
--
-- This program is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU General Public License for more details.
--
-- You should have received a copy of the GNU General Public License
-- along with this program; if not, write to the Free Software
-- Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
--

--
-- Do not use spaces
--

TABLE|httptest|httptestid|ZBX_SYNC
FIELD		|httptestid	|t_id		|'0'	|NOT NULL	|ZBX_SYNC
FIELD		|name		|t_varchar(64)	|''	|NOT NULL	|ZBX_SYNC
FIELD		|applicationid	|t_id		|'0'	|NOT NULL	|ZBX_SYNC
FIELD		|nextcheck	|t_integer	|'0'	|NOT NULL	|ZBX_SYNC
FIELD		|delay		|t_integer	|'60'	|NOT NULL	|ZBX_SYNC
FIELD		|status		|t_integer	|'0'	|NOT NULL	|ZBX_SYNC
INDEX		|httptest_1	|hostid

TABLE|httpstep|httpstepid|ZBX_SYNC
FIELD		|httpstepid	|t_id		|'0'	|NOT NULL	|ZBX_SYNC
FIELD		|httptestid	|t_id		|'0'	|NOT NULL	|ZBX_SYNC
FIELD		|name		|t_varchar(64)	|''	|NOT NULL	|ZBX_SYNC
FIELD		|no		|t_integer	|'0'	|NOT NULL	|ZBX_SYNC
FIELD		|url		|t_varchar(128)	|''	|NOT NULL	|ZBX_SYNC
FIELD		|timeout	|t_integer	|'30'	|NOT NULL	|ZBX_SYNC
FIELD		|posts		|t_blob		|''	|NOT NULL	|ZBX_SYNC
INDEX		|httpstep_1	|httptestid

TABLE|httpstepitem|httpstepitemid|ZBX_SYNC
FIELD		|httpstepitemid	|t_id		|'0'	|NOT NULL	|ZBX_SYNC
FIELD		|httpstepid	|t_id		|'0'	|NOT NULL	|ZBX_SYNC
FIELD		|itemid		|t_id		|'0'	|NOT NULL	|ZBX_SYNC
FIELD		|type		|t_integer	|'0'	|NOT NULL	|ZBX_SYNC
UNIQUE		|httpstepitem_1	|httpstepid,itemid

TABLE|httpmacro|httpmacroid|ZBX_SYNC
FIELD		|httpmacroid	|t_id		|'0'	|NOT NULL	|ZBX_SYNC
FIELD		|httptestid	|t_id		|'0'	|NOT NULL	|ZBX_SYNC
FIELD		|name		|t_varchar(64)	|'0'	|NOT NULL	|ZBX_SYNC
FIELD		|macro		|t_varchar(64)	|'0'	|NOT NULL	|ZBX_SYNC
FIELD		|value		|t_varchar(255)	|'0'	|NOT NULL	|ZBX_SYNC
FIELD		|note		|t_blob		|''	|NOT NULL	|ZBX_SYNC
UNIQUE		|httpmacro_1	|httptestid,name

TABLE|nodes|nodeid|
FIELD		|nodeid		|t_integer	|'0'	|NOT NULL	|0
FIELD		|name		|t_varchar(64)	|'0'	|NOT NULL	|0
FIELD		|timezone	|t_integer	|'0'	|NOT NULL	|ZBX_SYNC
FIELD		|ip		|t_varchar(15)	|''	|NOT NULL	|ZBX_SYNC
FIELD		|port		|t_integer	|'10051'|NOT NULL	|ZBX_SYNC
FIELD		|slave_history	|t_integer	|'30'	|NOT NULL	|ZBX_SYNC
FIELD		|slave_trends	|t_integer	|'365'	|NOT NULL	|ZBX_SYNC
FIELD		|event_lastid	|t_id		|'0'	|NOT NULL	|0
FIELD		|events_eventid	|t_id		|'0'	|NOT NULL	|0
FIELD		|alerts_alertid	|t_id		|'0'	|NOT NULL	|0
FIELD		|history_lastid	|t_bigint	|'0'	|NOT NULL	|0
FIELD		|history_str_lastid|t_bigint	|'0'	|NOT NULL	|0
FIELD		|history_uint_lastid|t_bigint	|'0'	|NOT NULL	|0
FIELD		|nodetype	|t_integer	|'0'	|NOT NULL	|ZBX_SYNC
FIELD		|masterid	|t_integer	|'0'	|NOT NULL	|0

TABLE|node_cksum|cksumid|0
FIELD		|cksumid	|t_id		|'0'	|NOT NULL	|ZBX_SYNC
FIELD		|nodeid		|t_id		|'0'	|NOT NULL	|ZBX_SYNC
FIELD		|tablename	|t_varchar(64)	|''	|NOT NULL	|ZBX_SYNC
FIELD		|fieldname	|t_varchar(64)	|''	|NOT NULL	|ZBX_SYNC
FIELD		|recordid	|t_id		|'0'	|NOT NULL	|ZBX_SYNC
FIELD		|cksumtype	|t_integer	|'0'	|NOT NULL	|ZBX_SYNC
FIELD		|cksum		|t_char(32)	|''	|NOT NULL	|ZBX_SYNC
INDEX		|cksum_1	|nodeid,tablename,fieldname,recordid,cksumtype

TABLE|node_configlog|nodeid,conflogid|0
FIELD		|conflogid	|t_id		|'0'	|NOT NULL	|ZBX_SYNC
FIELD		|nodeid		|t_id		|'0'	|NOT NULL	|ZBX_SYNC
FIELD		|tablename	|t_varchar(64)	|''	|NOT NULL	|ZBX_SYNC
FIELD		|recordid	|t_id		|'0'	|NOT NULL	|ZBX_SYNC
FIELD		|operation	|t_integer	|'0'	|NOT NULL	|ZBX_SYNC
FIELD		|sync_master	|t_integer	|'0'	|NOT NULL	|ZBX_SYNC
FIELD		|sync_slave	|t_integer	|'0'	|NOT NULL	|ZBX_SYNC
INDEX		|configlog_1	|conflogid
INDEX		|configlog_2	|nodeid,tablename

TABLE|services|serviceid|ZBX_SYNC
FIELD		|serviceid	|t_id		|'0'	|NOT NULL	|ZBX_SYNC
FIELD		|name		|t_varchar(128)	|''	|NOT NULL	|ZBX_SYNC
FIELD		|status		|t_integer	|'0'	|NOT NULL	|ZBX_SYNC
FIELD		|algorithm	|t_integer	|'0'	|NOT NULL	|ZBX_SYNC
FIELD		|triggerid	|t_id		|	|		|ZBX_SYNC
FIELD		|showsla	|t_integer	|'0'	|NOT NULL	|ZBX_SYNC
FIELD		|goodsla	|t_double(5,2)	|'99.9'	|NOT NULL	|ZBX_SYNC
FIELD		|sortorder	|t_integer	|'0'	|NOT NULL	|ZBX_SYNC

TABLE|services_times|timeid|ZBX_SYNC
FIELD		|timeid		|t_id		|'0'	|NOT NULL	|ZBX_SYNC
FIELD		|serviceid	|t_id		|'0'	|NOT NULL	|ZBX_SYNC
FIELD		|type		|t_integer	|'0'	|NOT NULL	|ZBX_SYNC
FIELD		|ts_from	|t_integer	|'0'	|NOT NULL	|ZBX_SYNC
FIELD		|ts_to		|t_integer	|'0'	|NOT NULL	|ZBX_SYNC
FIELD		|note		|t_varchar(255)	|''	|NOT NULL	|ZBX_SYNC
INDEX		|times_1	|serviceid,type,ts_from,ts_to

TABLE|services_links|linkid|ZBX_SYNC
FIELD		|linkid		|t_id		|'0'	|NOT NULL	|ZBX_SYNC
FIELD		|serviceupid	|t_id		|'0'	|NOT NULL	|ZBX_SYNC
FIELD		|servicedownid	|t_id		|'0'	|NOT NULL	|ZBX_SYNC
FIELD		|soft		|t_integer	|'0'	|NOT NULL	|ZBX_SYNC
INDEX		|links_1	|servicedownid
UNIQUE		|links_2	|serviceupid,servicedownid

TABLE|graphs_items|gitemid|ZBX_SYNC
FIELD		|gitemid	|t_id		|'0'	|NOT NULL	|ZBX_SYNC
FIELD		|graphid	|t_id		|'0'	|NOT NULL	|ZBX_SYNC
FIELD		|itemid		|t_id		|'0'	|NOT NULL	|ZBX_SYNC
FIELD		|drawtype	|t_integer	|'0'	|NOT NULL	|ZBX_SYNC
FIELD		|sortorder	|t_integer	|'0'	|NOT NULL	|ZBX_SYNC
FIELD		|color		|t_varchar(32)	|'Dark Green'	|NOT NULL	|ZBX_SYNC
FIELD		|yaxisside	|t_integer	|'1'	|NOT NULL	|ZBX_SYNC
FIELD		|calc_fnc	|t_integer	|'2'	|NOT NULL	|ZBX_SYNC
FIELD		|type		|t_integer	|'0'	|NOT NULL	|ZBX_SYNC
FIELD		|periods_cnt	|t_integer	|'5'	|NOT NULL	|ZBX_SYNC

TABLE|graphs|graphid|ZBX_SYNC
FIELD		|graphid	|t_id		|'0'	|NOT NULL	|ZBX_SYNC
FIELD		|name		|t_varchar(128)	|''	|NOT NULL	|ZBX_SYNC
FIELD		|width		|t_integer	|'0'	|NOT NULL	|ZBX_SYNC
FIELD		|height		|t_integer	|'0'	|NOT NULL	|ZBX_SYNC
FIELD		|yaxistype	|t_integer	|'0'	|NOT NULL	|ZBX_SYNC
FIELD		|yaxismin	|t_double(16,4)	|'0'	|NOT NULL	|ZBX_SYNC
FIELD		|yaxismax	|t_double(16,4)	|'0'	|NOT NULL	|ZBX_SYNC
FIELD		|templateid	|t_id		|'0'	|NOT NULL	|ZBX_SYNC
FIELD		|show_work_period|t_integer	|'1'	|NOT NULL	|ZBX_SYNC
FIELD		|show_triggers	|t_integer	|'1'	|NOT NULL	|ZBX_SYNC
FIELD		|graphtype	|t_integer	|'0'	|NOT NULL	|ZBX_SYNC
INDEX		|graphs_1	|name

TABLE|sysmaps_links|linkid|ZBX_SYNC
FIELD		|linkid		|t_id		|'0'	|NOT NULL	|ZBX_SYNC
FIELD		|sysmapid	|t_id		|'0'	|NOT NULL	|ZBX_SYNC
FIELD		|selementid1	|t_id		|'0'	|NOT NULL	|ZBX_SYNC
FIELD		|selementid2	|t_id		|'0'	|NOT NULL	|ZBX_SYNC
FIELD		|triggerid	|t_id		|	|		|ZBX_SYNC
FIELD		|drawtype_off	|t_integer	|'0'	|NOT NULL	|ZBX_SYNC
FIELD		|color_off	|t_varchar(32)	|'Black'|NOT NULL	|ZBX_SYNC
FIELD		|drawtype_on	|t_integer	|'0'	|NOT NULL	|ZBX_SYNC
FIELD		|color_on	|t_varchar(32)	|'Red'	|NOT NULL	|ZBX_SYNC

TABLE|sysmaps_elements|selementid|ZBX_SYNC
FIELD		|selementid	|t_id		|'0'	|NOT NULL	|ZBX_SYNC
FIELD		|sysmapid	|t_id		|'0'	|NOT NULL	|ZBX_SYNC
FIELD		|elementid	|t_id		|'0'	|NOT NULL	|ZBX_SYNC
FIELD		|elementtype	|t_integer	|'0'	|NOT NULL	|ZBX_SYNC
FIELD		|iconid_off	|t_bigint		|'0'	|NOT NULL	|ZBX_SYNC
FIELD		|iconid_on	|t_bigint		|'0'	|NOT NULL	|ZBX_SYNC
FIELD		|label		|t_varchar(128)	|''	|NOT NULL	|ZBX_SYNC
FIELD		|label_location	|t_integer	|	|NULL		|ZBX_SYNC
FIELD		|x		|t_integer	|'0'	|NOT NULL	|ZBX_SYNC
FIELD		|y		|t_integer	|'0'	|NOT NULL	|ZBX_SYNC
FIELD		|url		|t_varchar(255)	|''	|NOT NULL	|ZBX_SYNC

TABLE|sysmaps|sysmapid|ZBX_SYNC
FIELD		|sysmapid	|t_id		|'0'	|NOT NULL	|ZBX_SYNC
FIELD		|name		|t_varchar(128)	|''	|NOT NULL	|ZBX_SYNC
FIELD		|width		|t_integer	|'0'	|NOT NULL	|ZBX_SYNC
FIELD		|height		|t_integer	|'0'	|NOT NULL	|ZBX_SYNC
FIELD		|backgroundid	|t_bigint		|'0'	|NOT NULL	|ZBX_SYNC
FIELD		|label_type	|t_integer	|'0'	|NOT NULL	|ZBX_SYNC
FIELD		|label_location	|t_integer	|'0'	|NOT NULL	|ZBX_SYNC
INDEX		|1		|name

TABLE|config|configid|ZBX_SYNC
FIELD		|configid	|t_id		|'0'	|NOT NULL	|ZBX_SYNC
FIELD		|alert_history	|t_integer	|'0'	|NOT NULL	|ZBX_SYNC
FIELD		|event_history	|t_integer	|'0'	|NOT NULL	|ZBX_SYNC
FIELD		|refresh_unsupported|t_integer	|'0'	|NOT NULL	|ZBX_SYNC
FIELD		|work_period	|t_varchar(100)	|'1-5,00:00-24:00'	|NOT NULL	|ZBX_SYNC

TABLE|groups|groupid|ZBX_SYNC
FIELD		|groupid	|t_id		|'0'	|NOT NULL	|ZBX_SYNC
FIELD		|name		|t_varchar(64)	|''	|NOT NULL	|ZBX_SYNC
INDEX		|1		|name

TABLE|hosts_groups|hostgroupid|ZBX_SYNC
FIELD		|hostgroupid	|t_id		|'0'	|NOT NULL	|ZBX_SYNC
FIELD		|hostid		|t_id		|'0'	|NOT NULL	|ZBX_SYNC
FIELD		|groupid	|t_id		|'0'	|NOT NULL	|ZBX_SYNC
INDEX		|groups_1	|hostid,groupid

TABLE|alerts|alertid|ZBX_SYNC
FIELD		|alertid	|t_id		|'0'	|NOT NULL	|ZBX_SYNC
FIELD		|actionid	|t_id		|'0'	|NOT NULL	|ZBX_SYNC
FIELD		|triggerid	|t_id		|'0'	|NOT NULL	|ZBX_SYNC
FIELD		|userid		|t_id		|'0'	|NOT NULL	|ZBX_SYNC
FIELD		|clock		|t_time		|'0'	|NOT NULL	|ZBX_SYNC
FIELD		|mediatypeid	|t_id		|'0'	|NOT NULL	|ZBX_SYNC
FIELD		|sendto		|t_varchar(100)	|''	|NOT NULL	|ZBX_SYNC
FIELD		|subject	|t_varchar(255)	|''	|NOT NULL	|ZBX_SYNC
FIELD		|message	|t_blob		|''	|NOT NULL	|ZBX_SYNC
FIELD		|status		|t_integer	|'0'	|NOT NULL	|ZBX_SYNC
FIELD		|retries	|t_integer	|'0'	|NOT NULL	|ZBX_SYNC
FIELD		|error		|t_varchar(128)	|''	|NOT NULL	|ZBX_SYNC
FIELD		|repeats	|t_integer	|'0'	|NOT NULL	|ZBX_SYNC
FIELD		|maxrepeats	|t_integer	|'0'	|NOT NULL	|ZBX_SYNC
FIELD		|nextcheck	|t_integer	|'0'	|NOT NULL	|ZBX_SYNC
FIELD		|delay		|t_integer	|'0'	|NOT NULL	|ZBX_SYNC
INDEX		|1		|actionid
INDEX		|2		|clock
INDEX		|3		|triggerid
INDEX		|4		|status,retries
INDEX		|5		|mediatypeid
INDEX		|6		|userid

TABLE|actions|actionid|ZBX_SYNC
FIELD		|actionid	|t_id		|'0'	|NOT NULL	|ZBX_SYNC
FIELD		|userid		|t_id		|'0'	|NOT NULL	|ZBX_SYNC
FIELD		|subject	|t_varchar(255)	|''	|NOT NULL	|ZBX_SYNC
FIELD		|message	|t_blob		|''	|NOT NULL	|ZBX_SYNC
FIELD		|recipient	|t_integer	|'0'	|NOT NULL	|ZBX_SYNC
FIELD		|maxrepeats	|t_integer	|'0'	|NOT NULL	|ZBX_SYNC
FIELD		|repeatdelay	|t_integer	|'600'	|NOT NULL	|ZBX_SYNC
FIELD		|source		|t_integer	|'0'	|NOT NULL	|ZBX_SYNC
FIELD		|actiontype	|t_integer	|'0'	|NOT NULL	|ZBX_SYNC
FIELD		|status		|t_integer	|'0'	|NOT NULL	|ZBX_SYNC
FIELD		|scripts	|t_blob		|''	|NOT NULL	|ZBX_SYNC

TABLE|conditions|conditionid|ZBX_SYNC
FIELD		|conditionid	|t_id		|'0'	|NOT NULL	|ZBX_SYNC
FIELD		|actionid	|t_id		|'0'	|NOT NULL	|ZBX_SYNC
FIELD		|conditiontype	|t_integer	|'0'	|NOT NULL	|ZBX_SYNC
FIELD		|operator	|t_integer	|'0'	|NOT NULL	|ZBX_SYNC
FIELD		|value		|t_varchar(255)	|''	|NOT NULL	|ZBX_SYNC
INDEX		|1		|actionid

TABLE|events|eventid|0
FIELD		|eventid	|t_id		|'0'	|NOT NULL	|ZBX_SYNC
FIELD		|triggerid	|t_id		|'0'	|NOT NULL	|ZBX_SYNC
FIELD		|clock		|t_time		|'0'	|NOT NULL	|ZBX_SYNC
FIELD		|value		|t_integer	|'0'	|NOT NULL	|ZBX_SYNC
FIELD		|acknowledged	|t_integer	|'0'	|NOT NULL	|ZBX_SYNC
INDEX		|1		|triggerid,clock
INDEX		|2		|clock

TABLE|functions|functionid|ZBX_SYNC
FIELD		|functionid	|t_id		|'0'	|NOT NULL	|ZBX_SYNC
FIELD		|itemid		|t_id		|'0'	|NOT NULL	|ZBX_SYNC
FIELD		|triggerid	|t_id		|'0'	|NOT NULL	|ZBX_SYNC
FIELD		|lastvalue	|t_varchar(255)	|	|		|0
FIELD		|function	|t_varchar(12)	|''	|NOT NULL	|ZBX_SYNC
FIELD		|parameter	|t_varchar(255)	|'0'	|NOT NULL	|ZBX_SYNC
INDEX		|1		|triggerid
INDEX		|2		|itemid,function,parameter

TABLE|history||0
FIELD		|itemid		|t_id		|'0'		|NOT NULL	|ZBX_SYNC
FIELD		|clock		|t_time		|'0'		|NOT NULL	|ZBX_SYNC
FIELD		|value		|t_double(16,4)	|'0.0000'	|NOT NULL	|ZBX_SYNC
INDEX		|1		|itemid,clock

TABLE|history_sync|id|
FIELD		|id		|t_serial		|		|		|ZBX_SYNC
FIELD		|nodeid		|t_id		|'0'		|NOT NULL	|ZBX_SYNC
FIELD		|itemid		|t_id		|'0'		|NOT NULL	|ZBX_SYNC
FIELD		|clock		|t_time		|'0'		|NOT NULL	|ZBX_SYNC
FIELD		|value		|t_double(16,4)	|'0.0000'	|NOT NULL	|ZBX_SYNC
INDEX		|1		|nodeid,id

TABLE|history_uint||0
FIELD		|itemid		|t_id		|'0'	|NOT NULL	|ZBX_SYNC
FIELD		|clock		|t_time		|'0'	|NOT NULL	|ZBX_SYNC
FIELD		|value		|t_bigint		|'0'	|NOT NULL	|ZBX_SYNC
INDEX		|1		|itemid,clock

TABLE|history_uint_sync|id|
FIELD		|id		|t_serial		|	|		|ZBX_SYNC
FIELD		|nodeid		|t_id		|'0'	|NOT NULL	|ZBX_SYNC
FIELD		|itemid		|t_id		|'0'	|NOT NULL	|ZBX_SYNC
FIELD		|clock		|t_time		|'0'	|NOT NULL	|ZBX_SYNC
FIELD		|value		|t_bigint		|'0'	|NOT NULL	|ZBX_SYNC
INDEX		|1		|nodeid,id

TABLE|history_str||0
FIELD		|itemid		|t_id		|'0'	|NOT NULL	|ZBX_SYNC
FIELD		|clock		|t_time		|'0'	|NOT NULL	|ZBX_SYNC
FIELD		|value		|t_varchar(255)	|''	|NOT NULL	|ZBX_SYNC
INDEX		|1		|itemid,clock

TABLE|history_str_sync|id|
FIELD		|id		|t_serial		|	|		|ZBX_SYNC
FIELD		|nodeid		|t_id		|'0'	|NOT NULL	|ZBX_SYNC
FIELD		|itemid		|t_id		|'0'	|NOT NULL	|ZBX_SYNC
FIELD		|clock		|t_time		|'0'	|NOT NULL	|ZBX_SYNC
FIELD		|value		|t_varchar(255)	|''	|NOT NULL	|ZBX_SYNC
INDEX		|1		|nodeid,id

TABLE|hosts|hostid|ZBX_SYNC
FIELD		|hostid		|t_id		|'0'	|NOT NULL	|ZBX_SYNC
FIELD		|host		|t_varchar(64)	|''	|NOT NULL	|ZBX_SYNC
FIELD		|useip		|t_integer	|'1'	|NOT NULL	|ZBX_SYNC
FIELD		|ip		|t_varchar(15)	|'127.0.0.1'|NOT NULL	|ZBX_SYNC
FIELD		|port		|t_integer	|'0'	|NOT NULL	|ZBX_SYNC
FIELD		|status		|t_integer	|'0'	|NOT NULL	|ZBX_SYNC
FIELD		|disable_until	|t_integer	|'0'	|NOT NULL	|0
FIELD		|error		|t_varchar(128)	|''	|NOT NULL	|ZBX_SYNC
FIELD		|available	|t_integer	|'0'	|NOT NULL	|ZBX_SYNC
FIELD		|errors_from	|t_integer	|'0'	|NOT NULL	|0
INDEX		|1		|host
INDEX		|2		|status

TABLE|items|itemid|ZBX_SYNC
FIELD		|itemid		|t_id		|'0'	|NOT NULL	|ZBX_SYNC
FIELD		|type		|t_integer	|'0'	|NOT NULL	|ZBX_SYNC
FIELD		|snmp_community	|t_varchar(64)	|''	|NOT NULL	|ZBX_SYNC
FIELD		|snmp_oid	|t_varchar(255)	|''	|NOT NULL	|ZBX_SYNC
FIELD		|snmp_port	|t_integer	|'161'	|NOT NULL	|ZBX_SYNC
FIELD		|hostid		|t_id		|'0'	|NOT NULL	|ZBX_SYNC
FIELD		|description	|t_varchar(255)	|''	|NOT NULL	|ZBX_SYNC
FIELD		|key_		|t_varchar(64)	|''	|NOT NULL	|ZBX_SYNC
FIELD		|delay		|t_integer	|'0'	|NOT NULL	|ZBX_SYNC
FIELD		|history	|t_integer	|'90'	|NOT NULL	|ZBX_SYNC
FIELD		|trends		|t_integer	|'365'	|NOT NULL	|ZBX_SYNC
FIELD		|nextcheck	|t_time		|'0'	|NOT NULL	|0
FIELD		|lastvalue	|t_varchar(255)	|	|NULL		|0
FIELD		|lastclock	|t_time		|	|NULL		|0
FIELD		|prevvalue	|t_varchar(255)	|	|NULL		|0
FIELD		|status		|t_integer	|'0'	|NOT NULL	|ZBX_SYNC
FIELD		|value_type	|t_integer	|'0'	|NOT NULL	|ZBX_SYNC
FIELD		|trapper_hosts	|t_varchar(255)	|''	|NOT NULL	|ZBX_SYNC
FIELD		|units		|t_varchar(10)	|''	|NOT NULL	|ZBX_SYNC
FIELD		|multiplier	|t_integer	|'0'	|NOT NULL	|ZBX_SYNC
FIELD		|delta		|t_integer	|'0'	|NOT NULL	|ZBX_SYNC
FIELD		|prevorgvalue	|t_double(16,4)	|	|NULL		|0
FIELD		|snmpv3_securityname|t_varchar(64)|''	|NOT NULL	|ZBX_SYNC
FIELD		|snmpv3_securitylevel|t_integer	|'0'	|NOT NULL	|ZBX_SYNC
FIELD		|snmpv3_authpassphrase|t_varchar(64)|''	|NOT NULL	|ZBX_SYNC
FIELD		|snmpv3_privpassphrase|t_varchar(64)|''	|NOT NULL	|ZBX_SYNC

FIELD		|formula	|t_varchar(255)	|'0'	|NOT NULL	|ZBX_SYNC
FIELD		|error		|t_varchar(128)	|''	|NOT NULL	|ZBX_SYNC

FIELD		|lastlogsize	|t_integer	|'0'	|NOT NULL	|0
FIELD		|logtimefmt	|t_varchar(64)	|''	|NOT NULL	|ZBX_SYNC
FIELD		|templateid	|t_id		|'0'	|NOT NULL	|ZBX_SYNC
FIELD		|valuemapid	|t_bigint		|'0'	|NOT NULL	|ZBX_SYNC
FIELD		|delay_flex	|t_varchar(255)	|''	|NOT NULL	|ZBX_SYNC
UNIQUE		|1		|hostid,key_
INDEX		|2		|nextcheck
INDEX		|3		|status

TABLE|media|mediaid|ZBX_SYNC
FIELD		|mediaid	|t_id		|'0'	|NOT NULL	|ZBX_SYNC
FIELD		|userid		|t_id		|'0'	|NOT NULL	|ZBX_SYNC
FIELD		|mediatypeid	|t_id		|'0'	|NOT NULL	|ZBX_SYNC
FIELD		|sendto		|t_varchar(100)	|''	|NOT NULL	|ZBX_SYNC
FIELD		|active		|t_integer	|'0'	|NOT NULL	|ZBX_SYNC
FIELD		|severity	|t_integer	|'63'	|NOT NULL	|ZBX_SYNC
FIELD		|period		|t_varchar(100)	|'1-7,00:00-23:59'|NOT NULL	|ZBX_SYNC
INDEX		|1		|userid
INDEX		|2		|mediatypeid

TABLE|media_type|mediatypeid|ZBX_SYNC
FIELD		|mediatypeid	|t_id		|'0'	|NOT NULL	|ZBX_SYNC
FIELD		|type		|t_integer	|'0'	|NOT NULL	|ZBX_SYNC
FIELD		|description	|t_varchar(100)	|''	|NOT NULL	|ZBX_SYNC
FIELD		|smtp_server	|t_varchar(255)	|''	|NOT NULL	|ZBX_SYNC
FIELD		|smtp_helo	|t_varchar(255)	|''	|NOT NULL	|ZBX_SYNC
FIELD		|smtp_email	|t_varchar(255)	|''	|NOT NULL	|ZBX_SYNC
FIELD		|exec_path	|t_varchar(255)	|''	|NOT NULL	|ZBX_SYNC
FIELD		|gsm_modem	|t_varchar(255)	|''	|NOT NULL	|ZBX_SYNC

TABLE|triggers|triggerid|ZBX_SYNC
FIELD		|triggerid	|t_id		|'0'	|NOT NULL	|ZBX_SYNC
FIELD		|expression	|t_varchar(255)	|''	|NOT NULL	|ZBX_SYNC
FIELD		|description	|t_varchar(255)	|''	|NOT NULL	|ZBX_SYNC
FIELD		|url		|t_varchar(255)	|''	|NOT NULL	|ZBX_SYNC
FIELD		|status		|t_integer	|'0'	|NOT NULL	|ZBX_SYNC
FIELD		|value		|t_integer	|'0'	|NOT NULL	|ZBX_SYNC
FIELD		|priority	|t_integer	|'0'	|NOT NULL	|ZBX_SYNC
FIELD		|lastchange	|t_integer	|'0'	|NOT NULL	|ZBX_SYNC
FIELD		|dep_level	|t_integer	|'0'	|NOT NULL	|ZBX_SYNC
FIELD		|comments	|t_blob		|	|		|ZBX_SYNC
FIELD		|error		|t_varchar(128)	|''	|NOT NULL	|ZBX_SYNC
FIELD		|templateid	|t_id		|'0'	|NOT NULL	|ZBX_SYNC
INDEX		|1		|status
INDEX		|2		|value

TABLE|trigger_depends|triggerdepid|ZBX_SYNC
FIELD		|triggerdepid	|t_id		|'0'	|NOT NULL	|ZBX_SYNC
FIELD		|triggerid_down	|t_id		|'0'	|NOT NULL	|ZBX_SYNC
FIELD		|triggerid_up	|t_id		|'0'	|NOT NULL	|ZBX_SYNC
INDEX		|1		|triggerid_down,triggerid_up
INDEX		|2		|triggerid_up

TABLE|users|userid|ZBX_SYNC
FIELD		|userid		|t_id		|'0'	|NOT NULL	|ZBX_SYNC
FIELD		|alias		|t_varchar(100)	|''	|NOT NULL	|ZBX_SYNC
FIELD		|name		|t_varchar(100)	|''	|NOT NULL	|ZBX_SYNC
FIELD		|surname	|t_varchar(100)	|''	|NOT NULL	|ZBX_SYNC
FIELD		|passwd		|t_char(32)	|''	|NOT NULL	|ZBX_SYNC
FIELD		|url		|t_varchar(255)	|''	|NOT NULL	|ZBX_SYNC
FIELD		|autologout	|t_integer	|'900'	|NOT NULL	|ZBX_SYNC
FIELD		|lang		|t_varchar(5)	|'en_gb'|NOT NULL	|ZBX_SYNC
FIELD		|refresh	|t_integer	|'30'	|NOT NULL	|ZBX_SYNC
FIELD		|type		|t_integer	|'0'	|NOT NULL	|ZBX_SYNC
INDEX		|1		|alias

TABLE|auditlog|auditid|0
FIELD		|auditid	|t_id		|'0'	|NOT NULL	|ZBX_SYNC
FIELD		|userid		|t_id		|'0'	|NOT NULL	|ZBX_SYNC
FIELD		|clock		|t_time		|'0'	|NOT NULL	|ZBX_SYNC
FIELD		|action		|t_integer	|'0'	|NOT NULL	|ZBX_SYNC
FIELD		|resourcetype	|t_integer	|'0'	|NOT NULL	|ZBX_SYNC
FIELD		|details	|t_varchar(128)	|'0'	|NOT NULL	|ZBX_SYNC
INDEX		|1		|userid,clock
INDEX		|2		|clock

TABLE|sessions|sessionid|0
FIELD		|sessionid	|t_varchar(32)	|''	|NOT NULL	|ZBX_SYNC
FIELD		|userid		|t_id		|'0'	|NOT NULL	|ZBX_SYNC
FIELD		|lastaccess	|t_integer	|'0'	|NOT NULL	|ZBX_SYNC

TABLE|rights|rightid|ZBX_SYNC
FIELD		|rightid	|t_id		|'0'	|NOT NULL	|ZBX_SYNC
FIELD		|groupid	|t_id		|'0'	|NOT NULL	|ZBX_SYNC
FIELD		|type		|t_integer	|'0'	|NOT NULL	|ZBX_SYNC
FIELD		|permission	|t_integer	|'0'	|NOT NULL	|ZBX_SYNC
FIELD		|id		|t_id		|	|		|ZBX_SYNC
INDEX		|1		|groupid

TABLE|service_alarms|servicealarmid|0
FIELD		|servicealarmid	|t_id		|'0'	|NOT NULL	|ZBX_SYNC
FIELD		|serviceid	|t_id		|'0'	|NOT NULL	|ZBX_SYNC
FIELD		|clock		|t_time		|'0'	|NOT NULL	|ZBX_SYNC
FIELD		|value		|t_integer	|'0'	|NOT NULL	|ZBX_SYNC
INDEX		|1		|serviceid,clock
INDEX		|2		|clock

TABLE|profiles|profileid|ZBX_SYNC
FIELD		|profileid	|t_id		|'0'	|NOT NULL	|ZBX_SYNC
FIELD		|userid		|t_id		|'0'	|NOT NULL	|ZBX_SYNC
FIELD		|idx		|t_varchar(64)	|''	|NOT NULL	|ZBX_SYNC
FIELD		|value		|t_varchar(255)	|''	|NOT NULL	|ZBX_SYNC
FIELD		|valuetype	|t_integer	|0	|NOT NULL	|ZBX_SYNC
UNIQUE		|1		|userid,idx

TABLE|screens|screenid|ZBX_SYNC
FIELD		|screenid	|t_id		|'0'	|NOT NULL	|ZBX_SYNC
FIELD		|name		|t_varchar(255)	|'Screen'|NOT NULL	|ZBX_SYNC
FIELD		|hsize		|t_integer	|'1'	|NOT NULL	|ZBX_SYNC
FIELD		|vsize		|t_integer	|'1'	|NOT NULL	|ZBX_SYNC

TABLE|screens_items|screenitemid|ZBX_SYNC
FIELD		|screenitemid	|t_id		|'0'	|NOT NULL	|ZBX_SYNC
FIELD		|screenid	|t_id		|'0'	|NOT NULL	|ZBX_SYNC
FIELD		|resourcetype	|t_integer	|'0'	|NOT NULL	|ZBX_SYNC
FIELD		|resourceid	|t_id		|'0'	|NOT NULL	|ZBX_SYNC
FIELD		|width		|t_integer	|'320'	|NOT NULL	|ZBX_SYNC
FIELD		|height		|t_integer	|'200'	|NOT NULL	|ZBX_SYNC
FIELD		|x		|t_integer	|'0'	|NOT NULL	|ZBX_SYNC
FIELD		|y		|t_integer	|'0'	|NOT NULL	|ZBX_SYNC
FIELD		|colspan	|t_integer	|'0'	|NOT NULL	|ZBX_SYNC
FIELD		|rowspan	|t_integer	|'0'	|NOT NULL	|ZBX_SYNC
FIELD		|elements	|t_integer	|'25'	|NOT NULL	|ZBX_SYNC
FIELD		|valign		|t_integer	|'0'	|NOT NULL	|ZBX_SYNC
FIELD		|halign		|t_integer	|'0'	|NOT NULL	|ZBX_SYNC
FIELD		|style		|t_integer	|'0'	|NOT NULL	|ZBX_SYNC
FIELD		|url		|t_varchar(255)	|''	|NOT NULL	|ZBX_SYNC

TABLE|usrgrp|usrgrpid|ZBX_SYNC
FIELD		|usrgrpid	|t_id		|'0'	|NOT NULL	|ZBX_SYNC
FIELD		|name		|t_varchar(64)	|''	|NOT NULL	|ZBX_SYNC
INDEX		|1		|name

TABLE|users_groups|id|ZBX_SYNC
FIELD		|id		|t_id		|'0'	|NOT NULL	|ZBX_SYNC
FIELD		|usrgrpid	|t_id		|'0'	|NOT NULL	|ZBX_SYNC
FIELD		|userid		|t_id		|'0'	|NOT NULL	|ZBX_SYNC
INDEX		|1		|usrgrpid,userid

TABLE|trends|itemid,clock|0
FIELD		|itemid		|t_id		|'0'	|NOT NULL	|ZBX_SYNC
FIELD		|clock		|t_time		|'0'	|NOT NULL	|ZBX_SYNC
FIELD		|num		|t_integer	|'0'	|NOT NULL	|ZBX_SYNC
FIELD		|value_min	|t_double(16,4)	|'0.0000'|NOT NULL	|ZBX_SYNC
FIELD		|value_avg	|t_double(16,4)	|'0.0000'|NOT NULL	|ZBX_SYNC
FIELD		|value_max	|t_double(16,4)	|'0.0000'|NOT NULL	|ZBX_SYNC

TABLE|images|imageid|ZBX_SYNC
FIELD		|imageid	|t_id		|'0'	|NOT NULL	|ZBX_SYNC
FIELD		|imagetype	|t_integer	|'0'	|NOT NULL	|ZBX_SYNC
FIELD		|name		|t_varchar(64)	|'0'	|NOT NULL	|ZBX_SYNC
FIELD		|image		|t_image	|''	|NOT NULL	|0
INDEX		|1		|imagetype,name

TABLE|hosts_templates|hosttemplateid|ZBX_SYNC
FIELD		|hosttemplateid	|t_id		|'0'	|NOT NULL	|ZBX_SYNC
FIELD		|hostid		|t_id		|'0'	|NOT NULL	|ZBX_SYNC
FIELD		|templateid	|t_id		|'0'	|NOT NULL	|ZBX_SYNC
UNIQUE		|1		|hostid,templateid

TABLE|history_log|id|0
FIELD		|id		|t_id		|'0'	|NOT NULL	|ZBX_SYNC
FIELD		|itemid		|t_id		|'0'	|NOT NULL	|ZBX_SYNC
FIELD		|clock		|t_time		|'0'	|NOT NULL	|ZBX_SYNC
FIELD		|timestamp	|t_time		|'0'	|NOT NULL	|ZBX_SYNC
FIELD		|source		|t_varchar(64)	|''	|NOT NULL	|ZBX_SYNC
FIELD		|severity	|t_integer	|'0'	|NOT NULL	|ZBX_SYNC
FIELD		|value		|t_history_log	|''	|NOT NULL	|ZBX_SYNC
INDEX		|1		|itemid,clock

TABLE|history_text|id|0
FIELD		|id		|t_id		|'0'	|NOT NULL	|ZBX_SYNC
FIELD		|itemid		|t_id		|'0'	|NOT NULL	|ZBX_SYNC
FIELD		|clock		|t_time		|'0'	|NOT NULL	|ZBX_SYNC
FIELD		|value		|t_history_text	|''	|NOT NULL	|ZBX_SYNC
INDEX		|1		|itemid,clock

TABLE|hosts_profiles|hostid|ZBX_SYNC
FIELD		|hostid		|t_id		|'0'	|NOT NULL	|ZBX_SYNC
FIELD		|devicetype	|t_varchar(64)	|''	|NOT NULL	|ZBX_SYNC
FIELD		|name		|t_varchar(64)	|''	|NOT NULL	|ZBX_SYNC
FIELD		|os		|t_varchar(64)	|''	|NOT NULL	|ZBX_SYNC
FIELD		|serialno	|t_varchar(64)	|''	|NOT NULL	|ZBX_SYNC
FIELD		|tag		|t_varchar(64)	|''	|NOT NULL	|ZBX_SYNC
FIELD		|macaddress	|t_varchar(64)	|''	|NOT NULL	|ZBX_SYNC
FIELD		|hardware	|t_blob		|''	|NOT NULL	|ZBX_SYNC
FIELD		|software	|t_blob		|''	|NOT NULL	|ZBX_SYNC
FIELD		|contact	|t_blob		|''	|NOT NULL	|ZBX_SYNC
FIELD		|location	|t_blob		|''	|NOT NULL	|ZBX_SYNC
FIELD		|notes		|t_blob		|''	|NOT NULL	|ZBX_SYNC

TABLE|autoreg|id|ZBX_SYNC
FIELD		|id		|t_id		|'0'	|NOT NULL	|ZBX_SYNC
FIELD		|priority	|t_integer	|'0'	|NOT NULL	|ZBX_SYNC
FIELD		|pattern	|t_varchar(255)	|''	|NOT NULL	|ZBX_SYNC
FIELD		|hostid		|t_id		|'0'	|NOT NULL	|ZBX_SYNC

TABLE|valuemaps|valuemapid|ZBX_SYNC
FIELD		|valuemapid	|t_id		|'0'	|NOT NULL	|ZBX_SYNC
FIELD		|name		|t_varchar(64)	|''	|NOT NULL	|ZBX_SYNC
INDEX		|1		|name

TABLE|mappings|mappingid|ZBX_SYNC
FIELD		|mappingid	|t_id		|'0'	|NOT NULL	|ZBX_SYNC
FIELD		|valuemapid	|t_id		|'0'	|NOT NULL	|ZBX_SYNC
FIELD		|value		|t_varchar(64)	|''	|NOT NULL	|ZBX_SYNC
FIELD		|newvalue	|t_varchar(64)	|''	|NOT NULL	|ZBX_SYNC
INDEX		|1		|valuemapid

TABLE|housekeeper|housekeeperid|0
FIELD		|housekeeperid	|t_id		|'0'	|NOT NULL	|ZBX_SYNC
FIELD		|tablename	|t_varchar(64)	|''	|NOT NULL	|ZBX_SYNC
FIELD		|field		|t_varchar(64)	|''	|NOT NULL	|ZBX_SYNC
FIELD		|value		|t_integer		|'0'	|NOT NULL	|ZBX_SYNC

TABLE|acknowledges|acknowledgeid|ZBX_SYNC
FIELD		|acknowledgeid	|t_id		|'0'	|NOT NULL	|ZBX_SYNC
FIELD		|userid		|t_id		|'0'	|NOT NULL	|ZBX_SYNC
FIELD		|eventid	|t_id		|'0'	|NOT NULL	|ZBX_SYNC
FIELD		|clock		|t_time		|'0'	|NOT NULL	|ZBX_SYNC
FIELD		|message	|t_varchar(255)	|''	|NOT NULL	|ZBX_SYNC
INDEX		|1		|userid
INDEX		|2		|eventid
INDEX		|3		|clock

TABLE|applications|applicationid|ZBX_SYNC
FIELD		|applicationid	|t_id		|'0'	|NOT NULL	|ZBX_SYNC
FIELD		|hostid		|t_id		|'0'	|NOT NULL	|ZBX_SYNC
FIELD		|name		|t_varchar(255)	|''	|NOT NULL	|ZBX_SYNC
FIELD		|templateid	|t_id		|'0'	|NOT NULL	|ZBX_SYNC
INDEX		|1		|templateid
UNIQUE		|2		|hostid,name

TABLE|items_applications|itemappid|ZBX_SYNC
FIELD		|itemappid	|t_id		|'0'	|NOT NULL	|ZBX_SYNC
FIELD		|applicationid	|t_id		|'0'	|NOT NULL	|ZBX_SYNC
FIELD		|itemid		|t_id		|'0'	|NOT NULL	|ZBX_SYNC
INDEX		|1		|applicationid,itemid

TABLE|help_items|itemtype,key_|0
FIELD		|itemtype	|t_integer	|'0'	|NOT NULL	|ZBX_SYNC
FIELD		|key_		|t_varchar(64)	|''	|NOT NULL	|ZBX_SYNC
FIELD		|description	|t_varchar(255)	|''	|NOT NULL	|ZBX_SYNC
