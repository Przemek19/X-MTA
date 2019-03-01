--[[
X-MTA Gamemode
@author Pevo <pb.pb@onet.pl>
@copyright Pevo <pb.pb@onet.pl>
@license Dual GPLv3/MIT
]]--

local SQL

local data = {
  host = "127.0.0.1",
  user = "root",
  password = "",
  database = "XMTA",
}

local function connect()
	SQL = Connection("mysql", "dbname=" .. data.database .. ";host=" .. data.host, data.user, data.password, "share=1")
	if (not SQL) then
    outputServerLog("SQL CONNECTING - FAILED")
  else
    outputServerLog("SQL CONNECTING - SUCCESS")
		exec("SET NAMES utf8;")
	end
end

function query(...)
	local h = SQL:query(function(qh) qh:free() end, ...)
	if (not h) then
		return false
	end
	return h:poll(-1)
end

function exec(...)
	return SQL:exec(...)
end

connect()