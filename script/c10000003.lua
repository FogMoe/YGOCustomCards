-- 永续陷阱①：怪兽攻击表示召唤的场合把这个效果发动。那只怪兽变成守备表示。②：双方玩家若不支付600基本分则不能攻击宣言。③：只要这张卡在魔法与陷阱区域存在，场上的怪兽的守备力在战斗阶段内上升200。
local s,id,o=GetID()
function s.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(TIMING_SPSUMMON)
	e1:SetTarget(s.target1)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_POSITION)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTarget(s.target2)
	e2:SetOperation(s.operation)
	e2:SetLabel(1)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_ATTACK_COST)
	e3:SetRange(LOCATION_SZONE)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetTargetRange(1,1)
	e3:SetCost(s.atcost)
	e3:SetOperation(s.atop)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetRange(LOCATION_SZONE)
	e4:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e4:SetCode(EFFECT_UPDATE_DEFENSE)
	e4:SetCondition(s.con)
	e4:SetValue(200)
	c:RegisterEffect(e4)
end
function s.con(e)
	local ph=Duel.GetCurrentPhase()
	return ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE
end

function s.atcost(e,c,tp)
	local ct=Duel.GetFlagEffect(tp,id)
	return Duel.CheckLPCost(tp,600) and ct==0
end
function s.atop(e,tp,eg,ep,ev,re,r,rp)
	Duel.PayLPCost(tp,600)
end
function s.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	e:SetLabel(0)
	local res,teg,tep,tev,tre,tr,trp=Duel.CheckEvent(EVENT_SUMMON_SUCCESS,true)
	if res then
		local g=teg:Filter(s.filter1,nil)
		if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(id,0)) then
			Duel.SetTargetCard(g)
			Duel.SetOperationInfo(0,CATEGORY_POSITION,g,g:GetCount(),0,0)
			e:SetLabel(1)
			e:GetHandler():RegisterFlagEffect(0,RESET_CHAIN,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(id,1))
		end
	end
end
function s.filter1(c)
	return c:IsPosition(POS_FACEUP_ATTACK)
end
function s.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(s.filter1,1,nil) end
	local g=eg:Filter(s.filter1,nil)
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,g:GetCount(),0,0)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabel()==0 or not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if g:GetCount()>0 then
		Duel.ChangePosition(g,POS_FACEUP_DEFENSE,POS_FACEDOWN_DEFENSE,POS_FACEUP_DEFENSE,POS_FACEDOWN_DEFENSE)
	end
end