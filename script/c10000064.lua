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
	--pos
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,0))
	e3:SetCategory(CATEGORY_POSITION)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(s.postg)
	e3:SetOperation(s.posop)
	c:RegisterEffect(e3)
	--atk down
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsPosition,POS_ATTACK))
	e2:SetValue(-600)
	c:RegisterEffect(e2)
	--Def
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_UPDATE_DEFENSE)
	e4:SetRange(LOCATION_SZONE)
	e4:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e4:SetTarget(aux.TargetBoolFunction(Card.IsPosition,POS_FACEUP_DEFENSE))
	e4:SetValue(500)
	c:RegisterEffect(e4)
		--Equip limit
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_SINGLE)
	e9:SetCode(EFFECT_EQUIP_LIMIT)
	e9:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e9:SetValue(s.eqlimit)
	c:RegisterEffect(e9)
end
function s.val(e,c)
	local r=c:GetPosition()
	if bit.band(r,POS_FACEUP_ATTACK)>0 then return -600
	elseif bit.band(r,POS_FACEUP_DEFENSE)>0 then return 500
	else return 0 end
end

function s.postg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ec=e:GetHandler():GetEquipTarget()
	if chk==0 then return ec and ec:IsAttackPos() and ec:IsCanChangePosition() end
end
function s.posop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ChangePosition(e:GetHandler():GetEquipTarget(),POS_FACEUP_DEFENSE)
end

function s.eqlimit(e,c)
	return c:IsType(TYPE_MONSTER) and c:IsFaceup()
end
function s.filter(c)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER)
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