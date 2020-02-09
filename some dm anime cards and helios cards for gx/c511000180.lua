--闇からの奇襲
function c511000180.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c511000180.condition)
	e1:SetTarget(c511000180.target)
	e1:SetOperation(c511000180.operation)
	c:RegisterEffect(e1)
	if not c511000180.global_check then
		c511000180.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SUMMON_SUCCESS)
		ge1:SetOperation(c511000180.checkop1)
		Duel.RegisterEffect(ge1,0)
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_SPSUMMON_SUCCESS)
		ge2:SetOperation(c511000180.checkop1)
		Duel.RegisterEffect(ge2,0)
		local ge3=Effect.CreateEffect(c)
		ge3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge3:SetCode(EVENT_SSET)
		ge3:SetOperation(c511000180.checkop2)
		Duel.RegisterEffect(ge3,0)
	end
end
function c511000180.checkop1(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	while tc do
		if tc:GetFlagEffect(511000180)==0 then
			tc:RegisterFlagEffect(511000180,RESET_PHASE+PHASE_END+RESET_SELF_TURN,0,2)
		end
		tc=eg:GetNext()
	end
end
function c511000180.checkop2(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	while tc do
		if tc:GetFlagEffect(511000180)==0 then
			tc:RegisterFlagEffect(511000180,RESET_PHASE+PHASE_END+RESET_SELF_TURN,0,2)
		end
		tc=eg:GetNext()
	end
end
function c511000180.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN2
end
function c511000180.filter1(c)
	return c:IsStatus(STATUS_SUMMON_TURN+STATUS_SPSUMMON_TURN)
end
function c511000180.filter2(c,tp,turn)
	return c:GetPreviousControler()==tp and c:GetTurnID()==turn and c:IsType(TYPE_MONSTER) and c:GetPreviousLocation()==LOCATION_MZONE and c:GetFlagEffect(511000180)~=0
end
function c511000180.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c511000180.filter1,tp,LOCATION_ONFIELD,0,1,nil)
			or Duel.IsExistingMatchingCard(c511000180.filter2,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_EXTRA,0,1,nil,tp,Duel.GetTurnCount()) end 
end
function c511000180.filter3(c)
	return c:IsStatus(STATUS_SET_TURN)
end
function c511000180.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g1=Duel.GetMatchingGroup(c511000180.filter1,tp,LOCATION_ONFIELD,0,nil)
	local tc1=g1:GetFirst()
	while tc1 do
		tc1:RegisterFlagEffect(511000180,RESET_PHASE+PHASE_END+RESET_SELF_TURN,0,2)
		tc1=g1:GetNext()
	end
	local g2=Duel.GetMatchingGroup(c511000180.filter3,tp,LOCATION_SZONE,0,nil)
	local tc2=g2:GetFirst()
	while tc2 do
		tc2:RegisterFlagEffect(511000180,RESET_PHASE+PHASE_END+RESET_SELF_TURN,0,2)
		tc2=g2:GetNext()
	end
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetCode(EFFECT_SKIP_TURN)
		e1:SetTargetRange(0,1)
		e1:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
		Duel.RegisterEffect(e1,tp)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_CANNOT_EP)
		Duel.RegisterEffect(e2,tp)
		local e3=e1:Clone()
		e3:SetCode(EFFECT_CANNOT_BP)
		Duel.RegisterEffect(e3,tp)
		local e4=Effect.CreateEffect(e:GetHandler())
		e4:SetType(EFFECT_TYPE_FIELD)
		e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e4:SetTargetRange(1,0)
		e4:SetCode(EFFECT_SKIP_DP)
		if Duel.GetTurnPlayer()==tp and Duel.GetCurrentPhase()==PHASE_BATTLE then
			e4:SetCondition(c511000180.skipcon)
			e4:SetLabel(Duel.GetTurnCount())
			e4:SetReset(RESET_PHASE+PHASE_BATTLE+RESET_SELF_TURN,2)
		else
			e4:SetReset(RESET_PHASE+PHASE_BATTLE+RESET_SELF_TURN)
		end
		Duel.RegisterEffect(e4,tp)
		local e5=e4:Clone()
		e5:SetCode(EFFECT_SKIP_SP)
		Duel.RegisterEffect(e5,tp)
		local e6=e4:Clone()
		e6:SetCode(EFFECT_SKIP_M1)
		Duel.RegisterEffect(e6,tp)
		local e7=Effect.CreateEffect(c)
		e7:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e7:SetCode(EVENT_PHASE+PHASE_BATTLE_START)
		e7:SetCountLimit(1)
		e7:SetTarget(c511000180.sptg)
		e7:SetOperation(c511000180.spop)
		e7:SetReset(RESET_PHASE+PHASE_END+RESET_SELF_TURN,2)
		Duel.RegisterEffect(e7,tp)
		--cannot attack
		local e8=Effect.CreateEffect(c)
		e8:SetType(EFFECT_TYPE_FIELD)
		e8:SetCode(EFFECT_CANNOT_ATTACK)
		e8:SetProperty(EFFECT_FLAG_OATH)
		e8:SetTargetRange(LOCATION_MZONE,0)
		e8:SetTarget(c511000180.ftarget)
		e8:SetReset(RESET_PHASE+PHASE_END+RESET_SELF_TURN,2)
		Duel.RegisterEffect(e8,tp)
		--cannot trigger
		local e9=Effect.CreateEffect(c)
		e9:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e9:SetCode(EVENT_ADJUST)
		e9:SetCountLimit(2)
		e9:SetOperation(c511000180.actop)
		e9:SetReset(RESET_PHASE+PHASE_END+RESET_SELF_TURN,2)
		Duel.RegisterEffect(e9,tp)
end
function c511000180.ftarget(e,c)
	return not c:IsStatus(STATUS_SUMMON_TURN+STATUS_SPSUMMON_TURN)
end
function c511000180.skipcon(e)
	return Duel.GetTurnCount()~=e:GetLabel()
end
function c511000180.filter4(c)
	return c:IsType(TYPE_MONSTER) and c:GetFlagEffect(511000180)~=0
end
function c511000180.filter5(c,tp,turn)
	return c:IsType(TYPE_MONSTER) and c:GetTurnID()==turn-2 and c:GetFlagEffect(511000180)~=0
end
function c511000180.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c511000180.filter4,tp,LOCATION_ONFIELD,0,1,nil)
			or Duel.IsExistingMatchingCard(c511000180.filter5,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_EXTRA,0,1,nil,tp,Duel.GetTurnCount()) end
end
function c511000180.spop(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetMatchingGroup(c511000180.filter4,tp,LOCATION_ONFIELD,0,nil,tp,Duel.GetTurnCount())
	local tc1=g1:GetFirst()
	while tc1 do
		tc1:SetStatus(STATUS_SUMMON_TURN,true)
		tc1=g1:GetNext()
	end	
	if Duel.GetLocationCount(tp,LOCATION_MZONE)==0 then return end
	local g2=Duel.GetMatchingGroup(c511000180.filter5,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_EXTRA,0,nil,tp,Duel.GetTurnCount())
	local tc2=g2:GetFirst()
	while tc2 do
		Duel.MoveToField(tc2,tp,tp,LOCATION_MZONE,POS_FACEUP,true)
		tc2:SetStatus(STATUS_SUMMON_TURN,true)
		tc2=g2:GetNext()	
	end
	local sk=Duel.GetTurnPlayer()
	Duel.SkipPhase(sk,PHASE_MAIN2,RESET_PHASE+PHASE_MAIN2,1)
end
function c511000180.filter6(c,tp,turn)
	return c:IsFacedown() and c:GetTurnID()==turn-2 and c:GetFlagEffect(511000180)~=0
end
function c511000180.actop(e,tp,eg,ep,ev,re,r,rp)
	local g3=Duel.GetMatchingGroup(c511000180.filter6,tp,LOCATION_SZONE,0,nil,tp,Duel.GetTurnCount())
	local tc3=g3:GetFirst()
	while tc3 do
		tc3:SetStatus(STATUS_SET_TURN,true)
		tc3=g3:GetNext()
	end
end