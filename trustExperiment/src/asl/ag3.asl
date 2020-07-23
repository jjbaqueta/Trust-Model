/* modules */

{ include("socialModule.asl") }	// rules and plans for agents make social evaluations

!initialImps.

+!initialImps : true
<-  !evaluateProvider(ag1, "CARRY", ["v1","v2","v3"], [1.0,1.0,1.0]);
	!evaluateProvider(ag1, "CARRY", ["v1","v2","v3"], [1.0,1.0,1.0]);
	!evaluateProvider(ag1, "CARRY", ["v1","v2","v3"], [1.0,1.0,1.0]);
	!sendImage(ag1, ag2, "CARRY");
	!test.

+!test: true
<-	!evaluateProvider(ag1, "CARRY", ["v1","v2","v3"], [1.0,1.0,1.0]);		
	!sendImage(ag1, ag2, "CARRY");
	
	!evaluateProvider(ag2, "CARRY", ["v1","v2","v3"], [0.2,0.5,0.9]);
	!evaluateProvider(ag2, "CARRY", ["v1","v2","v3"], [0.8,0.9,0.8]);
	!sendImage(ag2, ag2, "CARRY");
	!sendImage(ag2, ag2, "CARRY");
	!sendImage(ag2, ag2, "CARRY");
	!computeTrust(ag1, "CARRY");
	!computeTrust(ag2, "CARRY");
	!getBestCandidates("CARRY").