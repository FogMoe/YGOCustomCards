--蝎子莱莱 超级变换形态
function c55664014.initial_effect(c)
--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_MACHINE),4,2)
	c:EnableReviveLimit()
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetDescription(aux.Stringid(55664014,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCost(c55664014.descost)
	e1:SetTarget(c55664014.destg)
	e1:SetOperation(c55664014.desop)
	c:RegisterEffect(e1)
end
function c55664014.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c55664014.filter(c)
	return c:IsFaceup()
end
function c55664014.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and c55664014.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c55664014.filter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c55664014.filter,tp,0,LOCATION_MZONE,1,1,nil)
	if Duel.GetLP(1-tp)>1000 then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	end
end
function c55664014.desop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsChainDisablable(0) and Duel.CheckLPCost(1-tp,1000)
		and Duel.SelectYesNo(1-tp,aux.Stringid(55664014,1)) then
		Duel.PayLPCost(1-tp,1000)
		Duel.NegateEffect(0)
		return
	end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end

