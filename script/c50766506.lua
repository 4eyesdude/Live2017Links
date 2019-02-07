--忍法 分身の術
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,0x1c0)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
	--Destroy
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetOperation(s.desop)
	c:RegisterEffect(e2)
end
function s.cfilter(c,e,tp,ft)
	local lv=c:GetLevel()
	return lv>0 and c:IsSetCard(0x2b)
		and (ft>0 or (c:IsControler(tp) and c:GetSequence()<5)) and (c:IsControler(tp) or c:IsFaceup())
		and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_DECK,0,1,nil,lv,e,tp)
end
function s.spfilter(c,lv,e,tp)
	return c:IsLevelBelow(lv) and c:IsSetCard(0x2b) and
		(c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_ATTACK) or c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE))
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if chk==0 then return ft>-1 and Duel.CheckReleaseGroupCost(tp,s.cfilter,1,false,nil,nil,e,tp,ft) end
	local rg=Duel.SelectReleaseGroupCost(tp,s.cfilter,1,1,false,nil,nil,e,tp,ft)
	e:SetLabel(rg:GetFirst():GetLevel())
	Duel.Release(rg,REASON_COST)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function s.spfilter2(c,e,tp)
	return c:IsSetCard(0x2b) and
		(c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_ATTACK) or c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE))
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<=0 then return end
	local c=e:GetHandler()
	local slv=e:GetLabel()
	local sg=Duel.GetMatchingGroup(s.spfilter2,tp,LOCATION_DECK,0,nil,e,tp)
	sg:Remove(Card.IsLevelAbove,nil,slv+1)
	if #sg==0 then return end
	local cg=Group.CreateGroup()
	repeat
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tc=sg:Select(tp,1,1,nil):GetFirst()
		sg:RemoveCard(tc)
		slv=slv-tc:GetLevel()
		local spos=0
		if tc:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_ATTACK) then spos=spos+POS_FACEUP_ATTACK end
		if tc:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE) then spos=spos+POS_FACEDOWN_DEFENSE end
		Duel.SpecialSummonStep(tc,0,tp,tp,false,false,spos)
		if tc:IsFacedown() then cg:AddCard(tc) end
		c:SetCardTarget(tc)
		sg:Remove(Card.IsLevelAbove,nil,slv+1)
		ft=ft-1
	until ft<=0 or #sg==0 or not Duel.SelectYesNo(tp,aux.Stringid(id,0))
	Duel.SpecialSummonComplete()
	Duel.ConfirmCards(1-tp,cg)
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetHandler():GetCardTarget():Filter(Card.IsLocation,nil,LOCATION_MZONE)
	Duel.Destroy(g,REASON_EFFECT)
end
