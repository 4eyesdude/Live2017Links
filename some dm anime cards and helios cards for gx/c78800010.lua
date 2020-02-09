--魔法を打ち消す結界
function c78800010.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DISABLE+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c78800010.target)
	e1:SetOperation(c78800010.activate)
	c:RegisterEffect(e1)
end
function c78800010.filter(c)
	return c:IsFaceup() and c:IsType(TYPE_SPELL)
end
function c78800010.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c78800010.filter,tp,0,LOCATION_ONFIELD,1,nil,e,tp) end
	local sg=Duel.GetMatchingGroup(c78800010.filter,tp,0,LOCATION_ONFIELD,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,sg,sg:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,sg:GetCount(),0,0)
end
function c78800010.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local sg=Duel.GetMatchingGroup(c78800010.filter,tp,0,LOCATION_ONFIELD,nil,e,tp)
	local tc=sg:GetFirst()
	while tc do
	--disable
	local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		tc:RegisterEffect(e2)
		Duel.Destroy(sg,REASON_EFFECT)
		tc=sg:GetNext()
	end			
end
