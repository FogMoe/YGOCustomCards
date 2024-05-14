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
	--atk/def
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_EQUIP)
	e3:SetCode(EFFECT_UPDATE_DEFENSE)
	e3:SetValue(s.atkval)
	c:RegisterEffect(e3)
		--Equip limit
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_SINGLE)
	e9:SetCode(EFFECT_EQUIP_LIMIT)
	e9:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e9:SetValue(s.eqlimit)
	c:RegisterEffect(e9)
    	--search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetOperation(s.extraop)
	c:RegisterEffect(e2)
end
function s.extraop(e,tp,eg,ep,ev,re,r,rp,tc,mat)
	local ct=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_GRAVE,0,nil,TYPE_EQUIP):GetClassCount(Card.GetCode)
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,nil)
	if ct>0 and #g>0 and Duel.SelectYesNo(tp,aux.Stringid(id,0)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local sg=g:Select(tp,1,ct,nil)
		Duel.HintSelection(sg)
		local res=Duel.Destroy(sg,REASON_EFFECT)
	end
end

function s.atkval(e,c)
	return Duel.GetMatchingGroupCount(s.filter,c:GetControler(),LOCATION_ONFIELD,0,nil)*100
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