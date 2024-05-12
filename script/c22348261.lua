--猩 红 庭 院 的 狂 宴
local m=22348261
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--must attack
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_SZONE)
	e1:SetTargetRange(0,LOCATION_MZONE)
	e1:SetCode(EFFECT_MUST_ATTACK)
	c:RegisterEffect(e1)
	--atk1
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_UPDATE_ATTACK)
	e4:SetRange(LOCATION_SZONE)
	e4:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e4:SetTarget(c22348261.atktg)
	e4:SetValue(c22348261.val)
	c:RegisterEffect(e4)
end
function c22348261.extg(e,c)
	return c:IsSetCard(0x570b)
end
function c22348261.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x570b)
end
function c22348261.actcon(e)
	local a=Duel.GetAttacker()
	local b=Duel.GetAttackTarget()
	return (a and c22348261.cfilter(a)) or (b and c22348261.cfilter(b))
end
function c22348261.atktg(e,c)
	return c:IsFaceup()
end
function c22348261.val(e,re,tp)
	local tp=Duel.GetTurnPlayer()
	local t1=Duel.GetBattledCount(1-tp)
	local t2=Duel.GetBattledCount(tp)
	local t=t1+t2
	return t*100
end
