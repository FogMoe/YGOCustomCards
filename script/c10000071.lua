local s,id,o=GetID()
function s.initial_effect(c)
    	--direct attack
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_DIRECT_ATTACK)
	e2:SetCondition(s.indcon)
	c:RegisterEffect(e2)
    		--defense attack
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_DEFENSE_ATTACK)
	c:RegisterEffect(e3)
    	--position change
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(id,1))
	e6:SetCategory(CATEGORY_POSITION)
	e6:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e6:SetCode(EVENT_BE_BATTLE_TARGET)
	e6:SetCondition(s.atcon)
	e6:SetOperation(s.posop)
	c:RegisterEffect(e6)
    	--damage
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(id,1))
	e7:SetCategory(CATEGORY_DAMAGE)
	e7:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e7:SetCode(EVENT_BATTLE_DAMAGE)
	e7:SetCondition(s.damcon)
	e7:SetTarget(s.damtg)
	e7:SetOperation(s.damop)
	c:RegisterEffect(e7)
end
function s.damcon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp and e:GetHandler():IsDefensePos()
		and Duel.GetAttacker()==e:GetHandler()
end
function s.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local ct=e:GetHandler():GetAttack()
	Duel.SetTargetParam(ct)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,ct)
end
function s.damop(e,tp,eg,ep,ev,re,r,rp)
	local ct=e:GetHandler():GetAttack()
	Duel.Damage(1-tp,ct,REASON_EFFECT)
end
function s.indcon(e)
	return e:GetHandler():IsDefensePos()
end
function s.posop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local atk=Duel.GetAttacker():GetAttack()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		Duel.ChangePosition(c,POS_FACEUP_DEFENSE,0,POS_FACEUP_ATTACK,0)
		Duel.SetLP(tp,Duel.GetLP(tp)-atk/2)
	end
end
function s.atcon(e)
	return e:GetHandler():IsAttackPos()
end