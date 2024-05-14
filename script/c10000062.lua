local s,id,o=GetID()
function s.initial_effect(c)
	--spsummon proc
	local e9=Effect.CreateEffect(c)
	e9:SetDescription(aux.Stringid(id,0))
	e9:SetType(EFFECT_TYPE_FIELD)
	e9:SetCode(EFFECT_SPSUMMON_PROC)
	e9:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SPSUM_PARAM)
	e9:SetRange(LOCATION_HAND)
	e9:SetTargetRange(POS_FACEUP_DEFENSE,0)
	e9:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	e9:SetCondition(s.spcon)
	c:RegisterEffect(e9)
		--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCountLimit(1)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(s.atkcon)
	e2:SetOperation(s.adchange)
	c:RegisterEffect(e2)
		--defense attack
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_DEFENSE_ATTACK)
	c:RegisterEffect(e3)
end
function s.cfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsFaceup()
end
function s.spcon(e,c)
	if c==nil then return true end
	return Duel.GetMatchingGroupCount(s.cfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,nil)==0
		and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
end
function s.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1
end
function s.adchange(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local batk=c:GetBaseAttack()
	local bdef=c:GetBaseDefense()
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_SET_BASE_ATTACK_FINAL)
	e2:SetValue(bdef)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE+RESET_PHASE+PHASE_END,2)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_SET_BASE_DEFENSE_FINAL)
	e3:SetValue(batk)
	c:RegisterEffect(e3)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)	
	e1:SetValue(c:GetDefense()/2)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e1)
	if c:IsRelateToEffect(e) then
		local e5=Effect.CreateEffect(c)
		e5:SetType(EFFECT_TYPE_SINGLE)
		e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e5:SetCode(EFFECT_CANNOT_ATTACK)
		e5:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e5)
	end
end