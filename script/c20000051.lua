--无亘帝皇之显现
local cm,m,o=GetID()
function cm.initial_effect(c)
	aux.AddRitualProcEqual(c,cm.rf)
end
--e1
function cm.rf(c)
	return c:IsType(TYPE_RITUAL) and c:IsSetCard(0xbfd0)
end