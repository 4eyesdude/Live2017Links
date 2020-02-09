--エンジェルO７
function c120000303.initial_effect(c)
	--act limit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetRange(LOCATION_ONFIELD)
	e1:SetTargetRange(0,1)
	e1:SetCondition(c120000303.actcon)
	e1:SetValue(c120000303.aclimit)
	c:RegisterEffect(e1)
end
function c120000303.actcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsType(TYPE_MONSTER)
end
function c120000303.aclimit(e,re,tp)
	return re:IsActiveType(TYPE_MONSTER)
end
