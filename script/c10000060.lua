local s,id,o=GetID()
function s.initial_effect(c)
    c:EnableReviveLimit()
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_DECK)
	e1:SetCondition(s.spcon)
    e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_DUEL)
	c:RegisterEffect(e1)
--
    local e9=Effect.CreateEffect(c)
    e9:SetType(EFFECT_TYPE_SINGLE)
    e9:SetCode(EFFECT_CANNOT_ATTACK)
    c:RegisterEffect(e9)
    --no battle damage
    local e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_SINGLE)
    e5:SetCode(EFFECT_NO_BATTLE_DAMAGE)
    c:RegisterEffect(e5)
    --atk limit
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_FIELD)
    e4:SetRange(LOCATION_MZONE)
    e4:SetTargetRange(0,LOCATION_MZONE)
    e4:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
    e4:SetValue(s.atlimit)
    e4:SetCondition(s.indcon)
    c:RegisterEffect(e4)
    	--leave
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_LEAVE_FIELD_P)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetOperation(s.leaveop)
	c:RegisterEffect(e2)
end
function s.leaveop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsFacedown() then return end
	local effp=e:GetHandler():GetControler()
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SKIP_TURN)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	if Duel.GetTurnPlayer()==effp then
		e1:SetLabel(Duel.GetTurnCount())
		e1:SetCondition(s.skipcon)
		e1:SetReset(RESET_PHASE+PHASE_END+RESET_SELF_TURN,2)
	else
		e1:SetReset(RESET_PHASE+PHASE_END+RESET_SELF_TURN,1)
	end
	Duel.RegisterEffect(e1,effp)
end
function s.skipcon(e)
	return Duel.GetTurnCount()~=e:GetLabel()
end

function s.cfilter(c)
	return c:IsFaceup() and c:IsAttackAbove(3000)
end
function s.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(s.cfilter,tp,0,LOCATION_MZONE,1,nil)
end
function s.indcon(e)
return e:GetHandler():IsDefensePos() and e:GetHandler():IsDefenseAbove(3000)
end
function s.atlimit(e,c)
return c~=e:GetHandler() and c:IsDefensePos()
end

