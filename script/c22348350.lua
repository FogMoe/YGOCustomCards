local m=22348350
local cm=_G["c"..m]
function cm.initial_effect(c)
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_HANDES+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCountLimit(1,22348350)
	e1:SetCost(aux.bfgcost)
	e1:SetTarget(c22348350.thtg)
	e1:SetOperation(c22348350.thop)
	c:RegisterEffect(e1)
	c22348350.bfg_effect=e1
	--atk/def up
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x970a))
	e2:SetValue(c22348350.val)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e3)
end
function c22348350.atkfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_ZOMBIE)
end
function c22348350.val(e,c)
	return Duel.GetMatchingGroupCount(c22348350.atkfilter,c:GetControler(),LOCATION_MZONE,LOCATION_MZONE,nil)*100
end
function c22348350.filter(c)
	return c:IsSetCard(0x970a)
end
function c22348350.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1)
		and Duel.IsExistingMatchingCard(c22348350.filter,tp,LOCATION_HAND,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_HAND)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c22348350.thop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.DiscardHand(tp,c22348350.filter,1,1,REASON_EFFECT)~=0 and Duel.Draw(tp,1,REASON_EFFECT)~=0 then
		local dc=Duel.GetOperatedGroup():GetFirst()
		Duel.ConfirmCards(1-tp,dc)
		if dc:IsSetCard(0x970a) then
			Duel.BreakEffect()
			Duel.Draw(tp,1,REASON_EFFECT)
		end
		Duel.ShuffleHand(tp)
	end
end
