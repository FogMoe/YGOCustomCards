local m=53718002
local cm=_G["c"..m]
cm.name="阳"
function cm.initial_effect(c)
	aux.AddCodeList(c,53718001)
	aux.AddCodeList(c,53718002)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(cm.stg)
	e1:SetOperation(cm.sop)
	c:RegisterEffect(e1)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,3))
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1)
	e3:SetCost(cm.cost)
	e3:SetTarget(cm.tg)
	e3:SetOperation(cm.op)
	c:RegisterEffect(e3)
end
function cm.stg(e,tp,eg,ep,ev,re,r,rp,chk)
	local b=Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_MZONE,0,1,nil)
	if chk==0 then return true end
	local op=0
	if b then op=Duel.SelectOption(tp,aux.Stringid(m,0),aux.Stringid(m,1))
	else op=Duel.SelectOption(tp,aux.Stringid(m,1))+1 end
	e:SetLabel(op)
	if op==0 then
		if Duel.GetFlagEffect(tp,m)==0 then e:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE+CATEGORY_SEARCH+CATEGORY_TOHAND) else e:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE) end
		e:SetProperty(0)
	else
		if Duel.GetFlagEffect(tp,m)==0 then e:SetCategory(CATEGORY_DAMAGE+CATEGORY_SEARCH+CATEGORY_TOHAND) else e:SetCategory(CATEGORY_DAMAGE) end
		e:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		Duel.SetTargetPlayer(1-tp)
		Duel.SetTargetParam(200)
		Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,200)
	end
end
function cm.thfilter(c)
	return c:IsCode(m-1) and c:IsAbleToHand()
end
function cm.sop(e,tp,eg,ep,ev,re,r,rp)
	local res=0
	if e:GetLabel()==0 then
		local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil)
		if #g>0 then
			res=1
			for tc in aux.Next(g) do
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_UPDATE_ATTACK)
				e1:SetValue(100)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				tc:RegisterEffect(e1)
				local e2=e1:Clone()
				e2:SetCode(EFFECT_UPDATE_DEFENSE)
				tc:RegisterEffect(e2)
			end
		end
	else
		local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
		if Duel.Damage(p,d,REASON_EFFECT)~=0 then res=1 end
	end
	if res==1 and Duel.GetFlagEffect(tp,m)==0 and Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(m,2)) then
		Duel.BreakEffect()
		Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,0,1)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil)
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function cm.cfilter(c)
	return c:IsCode(m-1) and c:IsAbleToDeckAsCost()
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_GRAVE,0,1,nil) and Duel.IsExistingMatchingCard(Card.IsAbleToDeckAsCost,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g1=Duel.SelectMatchingCard(tp,cm.cfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	local g2=Duel.SelectMatchingCard(tp,Card.IsAbleToDeckAsCost,tp,LOCATION_HAND,0,1,1,nil)
	g1:Merge(g2)
	Duel.SendtoDeck(g1,nil,2,REASON_COST)
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then Duel.SendtoHand(e:GetHandler(),nil,REASON_EFFECT) end
end
