local m=22348355
local cm=_G["c"..m]
function cm.initial_effect(c)
	--th
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCountLimit(1,22348355)
	e1:SetCost(aux.bfgcost)
	e1:SetTarget(c22348355.thtg)
	e1:SetOperation(c22348355.thop)
	c:RegisterEffect(e1)
end
function c22348355.thfilter(c)
	return c:IsSetCard(0x970a) and c:IsAbleToHand() and not c:IsCode(22348355) and c:IsFaceup()
end
function c22348355.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c22348355.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c22348355.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c22348355.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c22348355.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end