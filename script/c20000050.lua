--无亘帝皇龙
xpcall(function() dofile("expansions/script/c20000000.lua") end,function() dofile("script/c20000000.lua") end)
local cm,m,o=GetID()
function cm.initial_effect(c)
	c:EnableReviveLimit()
	fucf.AddCode(c, 51)
	fuef.S(c,EFFECT_CHANGE_BATTLE_DAMAGE):Func(aux.ChangeBattleDamage(1,DOUBLE_DAMAGE),"con1")
end
--e1
function cm.con1(e)
	return e:GetHandler():GetSummonType()&SUMMON_TYPE_RITUAL == SUMMON_TYPE_RITUAL 
end