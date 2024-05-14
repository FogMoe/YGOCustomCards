local s,id,o=GetID()
function s.initial_effect(c)
    c:SetUniqueOnField(1,0,id)
				--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_CONTINUOUS_TARGET)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
		--Equip limit
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_SINGLE)
	e9:SetCode(EFFECT_EQUIP_LIMIT)
	e9:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e9:SetValue(s.eqlimit)
	c:RegisterEffect(e9)
	--damage
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_EQUIP)
	e3:SetCode(EFFECT_BOTH_BATTLE_DAMAGE)
	e3:SetCondition(s.indcon)
	c:RegisterEffect(e3)
	--no damage
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_EQUIP)
	e4:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
	e4:SetCondition(s.damcon)
	e4:SetValue(1)
	c:RegisterEffect(e4)
	--damage double
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_EQUIP)
	e5:SetCode(EFFECT_CHANGE_BATTLE_DAMAGE)
	e5:SetCondition(s.damcon2)
	e5:SetValue(aux.ChangeBattleDamage(1,DOUBLE_DAMAGE))
	c:RegisterEffect(e5)
	--atk/def
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_EQUIP)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetValue(s.atkval)
	c:RegisterEffect(e2)
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_EQUIP)
	e7:SetCode(EFFECT_UPDATE_DEFENSE)
	e7:SetValue(s.defval)
	c:RegisterEffect(e7)
end
function s.indcon(e)
	return e:GetHandler():GetEquipTarget():IsDefensePos()
end
function s.atkval(e,c)
	if c:IsDefensePos() then return 0 else return -(c:GetBaseAttack()/2) end
end
function s.defval(e,c)
	if c:IsAttackPos() then return 0 else return c:GetAttack()/2 end
end
function s.damcon2(e)
	return e:GetHandler():GetEquipTarget():GetBattleTarget()~=nil
end
function s.damcon(e)
	return e:GetHandler():GetEquipTarget():GetControler()==e:GetHandlerPlayer() and e:GetHandler():GetEquipTarget():IsDefensePos()
end
function s.eqlimit(e,c)
	return c:IsType(TYPE_MONSTER)
end
function s.filter(c)
	return c:IsFaceup()
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and s.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(s.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,s.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Equip(tp,c,tc)
	end
end