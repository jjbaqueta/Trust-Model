// Get impressions based on the itself opinion (target's image)
getSelfImpressions(Impressions, Provider, Skill) 
:-	.findall(imp(Requester, Provider, Time, Skill, Criteria, Values), 
		imp(Requester, Provider, Time, Skill, Criteria, Values)[source(self)], 
		Impressions).

// Get the agent's image
getMyImage(Image, Provider, Skill)
:-	.findall(img(Requester, Provider, Time, Skill, Criteria, Value),
		img(Requester, Provider, Time, Skill, Criteria, Value)[source(self)],
		Images) & Image = Images[0].

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

!initialImps.

+!initialImps : true
<-  !evaluateProvider(ag1, "CARRY", ["v1","v2","v3"], [0.1,-0.1,0.4]);
	!evaluateProvider(ag1, "CARRY", ["v1","v2","v3"], [0.3,-0.2,0.4]);
	!evaluateProvider(ag1, "CARRY", ["v1","v2","v3"], [0.4,-0.5,0.4]);
	!computeImage(ag1, "CARRY", ["v1","v2","v3"]);
	.wait(100);
	!sendMyknowHow("CARRY", ag1).





+!evaluateProvider(Provider, Skill, Criteria, Values):	true
<-	.my_name(Requester);
	reputationAndImage.actions.addImpression(Requester, Provider, Skill, Criteria, Values, ImpReference);
	.send(Provider, tell, ImpReference).

+!computeImage(Provider, Skill, Criteria)
: 	getSelfImpressions(Impressions, Provider, Skill) 
<-	.my_name(Requester);	
	reputationAndImage.actions.addImage(Impressions, Requester, Provider, Skill, Criteria).

+!sendMyknowHow(Skill, Target)
:	getMyknowHow(Impressions, Skill)
<-	.send(Target, tell, ref(Impressions)).

+!sendImage(Provider, Target, Skill)
:	getMyImage(Image, Provider, Skill)
<- 	.send(Target, tell, Image).

+img(_,Provider,_,Skill,Criteria,_)[source(S)]
:	S \== self
<-	!computeReputation(Provider, Skill, Criteria).

+!computeReputation(Provider, Skill, Criteria)
: 	getThirdPartImages(Images, Provider, Skill)
<-	.my_name(Requester);
	reputationAndImage.actions.addReputation(Images, Requester, Provider, Skill, Criteria).