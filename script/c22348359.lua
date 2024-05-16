--绰 影 废 墟 的 穿 刺 陷 阱
local m=22348359
local cm=_G["c"..m] 
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_POSITION+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCost(c22348359.cost)
	e1:SetTarget(c22348359.target)
	e1:SetOperation(c22348359.activate)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	
end
function c22348359.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function c22348359.handcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tp=e:GetHandler():GetControler()
	return Duel.GetFieldGroupCount(e:GetHandlerPlayer(),LOCATION_ONFIELD,0)==0 and Duel.IsExistingMatchingCard(c22348359.costfilter,tp,LOCATION_HAND,0,1,c)
end
function c22348359.filter(c,tp)
	return c:IsSummonPlayer(1-tp) and (c:IsAbleToGrave() or c:IsCanTurnSet())
end
function c22348359.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(c22348359.filter,1,nil,tp) end
	local g=eg:Filter(c22348359.filter,nil,tp)
	Duel.SetTargetCard(g)
end
function c22348359.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	local off=1
	local ops={}
	local opval={}
	if g:IsExists(Card.IsCanTurnSet,1,nil) then
		ops[off]=aux.Stringid(22348359,0)
		opval[off-1]=1
		off=off+1
	end
	if g:IsExists(Card.IsAbleToGrave,1,nil) then
		ops[off]=aux.Stringid(22348359,1)
		opval[off-1]=2
		off=off+1
	end
	local op=Duel.SelectOption(1-tp,table.unpack(ops))
	if opval[op]==1 then
		Duel.ChangePosition(g,POS_FACEDOWN_DEFENSE)


	elseif opval[op]==2 then
		Duel.SendtoGrave(g,REASON_RULE,1-tp)
	end
end


