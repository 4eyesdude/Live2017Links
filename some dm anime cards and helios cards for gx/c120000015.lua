--トゥーン・ワールド
--アンダーソン.
function c120000015.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--change type
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_ADD_TYPE)
	e2:SetValue(TYPE_TOON)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_ONFIELD,0)
	c:RegisterEffect(e2)
	--indes 1
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(LOCATION_ONFIELD,0)
	e3:SetTarget(aux.TargetBoolFunction(Card.IsType,TYPE_TOON))
	e3:SetValue(c120000015.indval)
	c:RegisterEffect(e3)
	--no damage
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
	e4:SetRange(LOCATION_SZONE)
	e4:SetTargetRange(LOCATION_ONFIELD,0)
	e4:SetTarget(aux.TargetBoolFunction(Card.IsType,TYPE_TOON))
	e4:SetValue(c120000015.indval)
	c:RegisterEffect(e4)
	--indes 2
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(120000015,0))
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e5:SetRange(LOCATION_SZONE)
	e5:SetTargetRange(LOCATION_ONFIELD,0)
	e5:SetCode(EVENT_DAMAGE_STEP_END)
	e5:SetCondition(c120000015.condition)
	e5:SetTarget(c120000015.target)
	e5:SetOperation(c120000015.operation)
	c:RegisterEffect(e5)
end
function c120000015.indval(e,c)
	return not c:IsType(TYPE_TOON)
end
function c120000015.condition(e,tp,eg,ep,ev,re,r,rp)
	return tp==Duel.GetTurnPlayer()
end
function c120000015.filter(c)
	return c:IsFaceup() and c:IsLocation(LOCATION_ONFIELD) and c:IsType(TYPE_TOON) and c:GetAttackedCount()>0
end
function c120000015.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c120000015.filter,tp,LOCATION_ONFIELD,0,1,nil) end
end
function c120000015.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local sg=Duel.GetMatchingGroup(c120000015.filter,tp,LOCATION_ONFIELD,0,nil,e)
	local tc=sg:GetFirst()
	while tc do
		--battle
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
		e1:SetValue(1)
		e1:SetCondition(c120000015.econ)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1,true)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_IMMUNE_EFFECT)
		e2:SetValue(1)
		e2:SetCondition(c120000015.econ)
		e2:SetValue(c120000015.indval2)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e2,true)
		--Direct attack
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_FIELD)
		e3:SetCode(EFFECT_DIRECT_ATTACK)
		e3:SetRange(LOCATION_MZONE)
		e3:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
		e3:SetCondition(c120000015.econ)
		e3:SetTarget(c120000015.dirtg)
		e3:SetReset(RESET_EVENT+0x47c0000)
		tc:RegisterEffect(e3,true)	 
		tc:RegisterFlagEffect(15259703,RESET_EVENT+0x1fe0000,0,1)
		tc=sg:GetNext()
	end
end
function c120000015.cfilter(c)
	return c:IsFaceup() and c:IsCode(15259703) and not c:IsStatus(STATUS_DISABLED)
end
function c120000015.econ(e)
	return Duel.IsExistingMatchingCard(c120000015.cfilter,0,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
		or Duel.IsEnvironment(15259703)
end
function c120000015.indval2(e,te)
	return te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end
function c120000015.dirfil(c)
	return c:GetFlagEffect(15259703)==0
end
function c120000015.dirtg(e,c)
	return not Duel.IsExistingMatchingCard(c120000015.dirfil,c:GetControler(),0,LOCATION_MZONE,1,nil)
end
