--一决龙战
local m=22347004
local cm=_G["c"..m]
function cm.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c22347004.target)
	e1:SetOperation(c22347004.activate)
	c:RegisterEffect(e1)
end
function c22347004.filter1(c)
	return c:IsFaceup() and c:IsRace(RACE_DRAGON+RACE_WARRIOR) and Duel.IsExistingMatchingCard(c22347004.filter2,tp,LOCATION_MZONE,LOCATION_MZONE,1,c,c:GetAttack())
end
function c22347004.filter2(c,atk)
	return c:GetAttack()<atk and c:IsFaceup()
end
function c22347004.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c22347004.filter1(chkc) and chkc:IsControler(tp) end
	if chk==0 then return Duel.IsExistingTarget(c22347004.filter1,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c22347004.filter1,tp,LOCATION_MZONE,0,1,1,nil)
	local sg=Duel.GetMatchingGroup(c22347004.filter2,tp,LOCATION_MZONE,LOCATION_MZONE,Duel.GetFirstTarget(),Duel.GetFirstTarget():GetAttack())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,1,0,0)
end
function c22347004.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,c22347004.filter2,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,tc,tc:GetAttack())
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		Duel.Destroy(g,REASON_EFFECT)
	end
end

