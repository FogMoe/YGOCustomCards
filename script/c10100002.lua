function c10100002.initial_effect(c)
	c:SetUniqueOnField(1,0,10100002)
    	--atk
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10100002,1))
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(c10100002.atkcon)
	e1:SetTarget(c10100002.atktg)
	e1:SetOperation(c10100002.atkop)
	c:RegisterEffect(e1)
end
function c10100002.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	return (a:IsControler(tp) and a:IsSetCard(0x9cdd)) or (d and d:IsControler(tp) and d:IsFaceup() and d:IsSetCard(0x9cdd))
end
function c10100002.atkfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x9cdd)
end
function c10100002.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10100002.atkfilter,tp,LOCATION_MZONE,0,1,nil) end
end
function c10100002.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c10100002.atkfilter,tp,LOCATION_MZONE,0,nil)
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(200)
		tc:RegisterEffect(e1)
        local e2=e1:Clone()
	    e2:SetCode(EFFECT_UPDATE_DEFENSE)
	    tc:RegisterEffect(e2)
		tc=g:GetNext()
	end
end