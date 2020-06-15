// Get impressions based on the itself opinion (target's image)
getSelfImpressions(Impressions, Provider, Skill) 
:-	.findall(imp(Requester, Provider, Time, Skill, Criteria, Values), 
		imp(Requester, Provider, Time, Skill, Criteria, Values)[source(self)], 
		Impressions).

// Get the agent's image
getMyImage(Image, Provider, Skill)
:-	.findall(img(Requester, Provider, Time, Skill, Criteria, Value),
		img(Requester, Provider, Time, Skill, Criteria, Value)[source(self)],
		Image).
		
// Get the agent's reputation
getReputationOf(Reputation, Provider, Skill)
:-	.findall(rep(Requester, Provider, Time, Skill, Criteria, Value),
		rep(Requester, Provider, Time, Skill, Criteria, Value)[source(_)],
		Reputation).
		
// Get the agent's references
getReferenceOf(Reference, Provider, Skill)
:-	.findall(ref(Requester, Provider, Time, Skill, Criteria, Value),
		ref(Requester, Provider, Time, Skill, Criteria, Value)[source(_)],
		Reference).

// Get the images that came from other agents (target's reputation)
getThirdPartImages(Images, Provider, Skill) 
:-	.findall(img(Requester, Provider, Time, Skill, Criteria, Values), 
		img(Requester, Provider, Time, Skill, Criteria, Values)[source(S)] & S \== self, 
		Images).

// Get all impressions where the agent played the role of provider
getMyknowHow(Impressions, Skill)
:-	.my_name(Provider) &
	.findall(imp(Requester, Provider, Time, Skill, Criteria, Values), 
			imp(Requester, Provider, Time, Skill, Criteria, Values)[source(S)] & S \== self, 
			Impressions).

// Get the most trustworthy candidate for a given skill
getCandidatesFor(Skill, Candidates)
:-	.findall(trust(Provider, Value),
		trust(Provider, Skill, Value)[source(_)],
		Candidates).



!start.

+!start : true
<-  .wait(100);
	!sendMyknowHow("CARRY", ag2);
	!computeTrust(ag2, "CARRY");
	!computeTrust(ag3, "CARRY");
	!getBestCandidates("CARRY")
.





+!getBestCandidates(Skill)
:	getCandidatesFor(Skill, Candidates)
<-	!theMostTrustworthy(Candidates, MaxValue, BestProvider);
	.print(Candidates);
	.print("best provider: ", BestProvider, ", best value: ", MaxValue).
	
+!theMostTrustworthy([trust(Provider, Value)|T], MaxValue, BestProvider)
:	T == []
<-	MaxValue = Value;
	BestProvider = Provider.

+!theMostTrustworthy([trust(Provider, Value)|T], MaxValue, BestProvider)
:	T \== []
<-	!theMostTrustworthy(T, MaxValue, BestProvider);
	if (MaxValue < Value)
	{
		MaxValue = Value;
		BestProvider = Provider;
	}.

+!theMostTrustworthy([], MaxValue, BestProvider).

+!evaluateProvider(Provider, Skill, Criteria, Values):	true
<-	.my_name(Requester);
	reputationAndImage.actions.addImpression(Requester, Provider, Skill, Criteria, Values, ImpReference);
	.send(Provider, tell, ImpReference).

+!computeImage(Provider, Skill, Criteria)
: 	getSelfImpressions(Impressions, Provider, Skill) 
<-	.my_name(Requester);	
	reputationAndImage.actions.addImage(Impressions, Requester, Provider, Skill, Criteria).
	
+!computeReputation(Provider, Skill, Criteria)
: 	getThirdPartImages(Images, Provider, Skill)
<-	.my_name(Requester);
	reputationAndImage.actions.addReputation(Images, Requester, Provider, Skill, Criteria).

+!sendMyknowHow(Skill, Target)
:	getMyknowHow(Impressions, Skill)
<-	.send(Target, tell, ref(Impressions)).

+!sendImage(Provider, Target, Skill)
:	getMyImage(Image, Provider, Skill)
<- 	.send(Target, tell, Image).

+!computeTrust(Provider, Skill)
:	getMyImage(Image, Provider, Skill) &
	getReputationOf(Reputation, Provider, Skill) &
	getReferenceOf(Reference, Provider, Skill)
<-	.my_name(Requester);
	reputationAndImage.actions.computeTrust(Requester, Provider, Skill, Image, Reputation, Reference).

+imp(_,Provider,_,Skill,Criteria,_)[source(self)]: true
<-	!computeImage(Provider, Skill, Criteria).

+img(_,Provider,_,Skill,Criteria,_)[source(S)]
:	S \== self
<-	!computeReputation(Provider, Skill, Criteria).

+ref(List)[source(S)]: true
<-	.my_name(Requester);
	reputationAndImage.actions.knowhowAnalysis(Requester, S, List);
	-ref(_)[source(S)]. 