local s,id,o=GetID()
function s.initial_effect(c)
		--damage
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_TO_HAND)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(s.damcon1)
	e2:SetOperation(s.damop1)
	c:RegisterEffect(e2)
	--dam
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,2))
	e4:SetCategory(CATEGORY_DAMAGE)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_PLAYER_TARGET)
	e4:SetCode(EVENT_CHANGE_POS)
	e4:SetCountLimit(1)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTarget(s.damtg)
	e4:SetOperation(s.damop)
	c:RegisterEffect(e4)
	--indes
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e3:SetValue(1)
	e3:SetCondition(s.tgcon)
	c:RegisterEffect(e3)
	local e9=e3:Clone()
	e9:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	c:RegisterEffect(e9)
	--tograve
	local e8=Effect.CreateEffect(c)
	e8:SetDescription(aux.Stringid(id,0))
	e8:SetCategory(CATEGORY_TOGRAVE+CATEGORY_DAMAGE)
	e8:SetType(EFFECT_TYPE_QUICK_F)
	e8:SetRange(LOCATION_MZONE)
	e8:SetCode(EVENT_BECOME_TARGET)
	e8:SetCountLimit(1)
	e8:SetCondition(s.spcon2)
	e8:SetTarget(s.thtg)
	e8:SetOperation(s.thop)
	c:RegisterEffect(e8)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		Duel.SendtoGrave(e:GetHandler(),REASON_EFFECT)
		Duel.Damage(1-tp,700,REASON_EFFECT)
	end
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGrave() end
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,700)
end
function s.damop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.SendtoGrave(e:GetHandler(),REASON_EFFECT) and e:GetHandler():IsRelateToEffect(e) then
		Duel.BreakEffect()
		Duel.Damage(1-tp,700,REASON_EFFECT)
	end
end
function s.spcon2(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsContains(e:GetHandler()) and rp==1-tp
end

function s.cfilter(c)
	return c:IsFaceup()
end
function s.tgcon(e)
	return Duel.IsExistingMatchingCard(s.cfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,e:GetHandler())
end
function s.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(800)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,800)
end
function s.damop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end

function s.damcon1(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(Card.IsControler,1,nil,1-tp)
end
function s.damop1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,id)
	Duel.Damage(1-tp,300,REASON_EFFECT)
end