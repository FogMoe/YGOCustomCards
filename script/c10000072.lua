local s,id,o=GetID()
function s.initial_effect(c)
        		--defense attack
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_DEFENSE_ATTACK)
	c:RegisterEffect(e2)
    	--cannot direct attack
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_DIRECT_ATTACK)
	c:RegisterEffect(e1)
    	--tg
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_SET_AVAILABLE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(s.imval)
	e3:SetValue(s.imfilter)
	c:RegisterEffect(e3)
    	--atkdown
	local e9=Effect.CreateEffect(c)
	e9:SetCategory(CATEGORY_DEFCHANGE)
	e9:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e9:SetCode(EVENT_BATTLE_DESTROYING)
	e9:SetCountLimit(1)
	e9:SetOperation(s.atkop)
	c:RegisterEffect(e9)
end
function s.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_DEFENSE)
	e1:SetValue(-200)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
	c:RegisterEffect(e1)
end
function s.imval(e,c)
	return c~=e:GetHandler() and c:IsType(TYPE_MONSTER) and c:IsPosition(POS_FACEUP_DEFENSE)
end
function s.imfilter(e,re,rp)
	return aux.tgoval(e,re,rp)
end