--无亘帝皇龙
local cm,m,o=GetID()
function cm.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddCodeList(c,20000051)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CHANGE_BATTLE_DAMAGE)
	e1:SetCondition(cm.con1)
	e1:SetValue(aux.ChangeBattleDamage(1,DOUBLE_DAMAGE))
	c:RegisterEffect(e1)
end
--e1
function cm.con1(e)
	return e:GetHandler():GetSummonType()&SUMMON_TYPE_RITUAL == SUMMON_TYPE_RITUAL 
end