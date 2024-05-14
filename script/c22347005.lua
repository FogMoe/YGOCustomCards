--沧涡龙 海龙
local m=22347005
local cm=_G["c"..m]
function cm.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c22347005.spcon)
	e1:SetOperation(c22347005.spop)
	c:RegisterEffect(e1)
	--counter
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c22347005.rccon)
	e2:SetOperation(c22347005.rcop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
end
function c22347005.spfilter(c)
	return c:IsRace(RACE_DRAGON) and c:IsLevelBelow(8)
end
function c22347005.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)>0
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c22347005.spfilter,tp,LOCATION_HAND,0,1,c)
end
function c22347005.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	local g=Duel.SelectMatchingCard(tp,c22347005.spfilter,tp,LOCATION_HAND,0,1,1,c)
	Duel.SendtoGrave(g,REASON_COST+REASON_DISCARD)
end
function c22347005.cfilter(c,tp)
	return c:IsSummonPlayer(tp) and c:IsFaceup() and c:IsRace(RACE_DRAGON)
end
function c22347005.rccon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c22347005.cfilter,1,e:GetHandler(),tp)
end
function c22347005.rcop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,22347005)
	Duel.Recover(tp,500,REASON_EFFECT)
end
