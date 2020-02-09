--ヘリオス・トリス・メギストス
function c120000029.initial_effect(c)
	--atk/def
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_SET_ATTACK)
	e1:SetValue(c120000029.value)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_SET_DEFENCE)
	c:RegisterEffect(e2)
	--special summon
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CHAIN_UNIQUE)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetLabel(0)
	e3:SetTarget(c120000029.target)
	e3:SetOperation(c120000029.operation)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
    e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e4:SetRange(LOCATION_MZONE)
    e4:SetCode(EFFECT_UPDATE_ATTACK)
	e4:SetLabelObject(e3)
    e4:SetValue(c120000029.val)
    c:RegisterEffect(e4)
	--chain attack
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_EXTRA_ATTACK)
	e5:SetValue(1)
	e5:SetCondition(c120000029.atcon)
	c:RegisterEffect(e5)
end
function c120000029.filter(c)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER)
end
function c120000029.value(e,c)
	return Duel.GetMatchingGroupCount(c120000029.filter,c:GetControler(),LOCATION_REMOVED,0,nil)*300
end
function c120000029.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and e:GetHandler():IsType(TYPE_MONSTER)
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c120000029.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end	
	if e:GetHandler() then
		Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP)
		e:SetLabel(e:GetLabel()+1)
		e:GetHandler():CompleteProcedure()
	end
end
function c120000029.val(e,c)
	return e:GetLabelObject():GetLabel()*500
end
function c120000029.atcon(e)
	return Duel.GetFieldGroupCount(e:GetHandlerPlayer(),0,LOCATION_MZONE)>0
end
