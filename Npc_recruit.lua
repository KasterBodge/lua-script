local npcid = 80048

local T = {
	["Menu"] = {
		{"『招募代码』", 1},
		{"『招募详情』", 2},
		{"『招募选项』", 2},
	}
}

function Recruit(event, player, object)
    player:GossipClearMenu()
	for _, v in ipairs(T["Menu"]) do
		player:GossipMenuAddItem(0, v[1], 0, v[2])
	end
	player:GossipSendMenu(1, object)
end

function RecruitSelect(event, player, unit, sender, intid, code)
    local accountId = player:GetAccountId()
    if(intid == 0)then
	    player:GossipComplete()
	    return
	elseif(intid == 1) then
        local result = CharDBQuery("select recruit_code from custom_account_extend where account_id = " .. accountId)
        local recruitCode = ""
        if(result == nil) then
            recruitCode = "ZMCD" .. accountId
            CharDBExecute("insert into custom_account_extend (account_id, recruit_code, created_at, updated_at) values (" .. accountId ..", '" .. recruitCode .. "', now(), now() )")
        else
            recruitCode = result:GetString(0)
        end
        player:GossipClearMenu()
        player:GossipMenuAddItem(0,"您的招募代码是：|cFF0000CC" .. recruitCode .. "|R", 1, 1)
        player:GossipMenuAddItem(0,"【返回】", 1, 3)
        player:GossipSendMenu(1, unit)
    elseif(intid == 2) then
        local result = CharDBQuery("SELECT count(*),sum(cost_anchor_currency) AS recruits FROM custom_recruit cr LEFT JOIN custom_account_extend cae ON cae.account_id = cr.recruit_account_id where cr.account_id = " .. accountId .. " GROUP BY cr.account_id")
        local recruits = 0
        local cost = 0
        if(result ~= nil) then
            recruits = result:GetString(0)
            cost = result:GetString(1)
        end
        player:GossipClearMenu()
        player:GossipMenuAddItem(0,"您招募的玩家人数：|cff0000ff" .. recruits .. "人|r", 1, 2)
        player:GossipMenuAddItem(0,"您招募的玩家消费总数：|cff0000ff" .. cost .."公正徽章|r", 1, 2)
        player:GossipMenuAddItem(0,"【返回】", 1, 3)
        player:GossipSendMenu(1, unit)
    elseif(intid == 3) then
        Recruit(event, player, unit)
    end
    
end

RegisterCreatureGossipEvent(npcid, 1, Recruit)
RegisterCreatureGossipEvent(npcid, 2, RecruitSelect)
