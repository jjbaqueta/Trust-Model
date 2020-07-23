/* modules */

{ include("socialModule.asl") }	// rules and plans for agents make social evaluations

!initialImps.

+!initialImps : true
<-  
	!evaluateProvider(ag1, "CARRY", ["v1","v2","v3"], [0.1,-0.1,0.4]);
	!evaluateProvider(ag1, "CARRY", ["v1","v2","v3"], [0.3,-0.2,0.4]);
	!evaluateProvider(ag1, "CARRY", ["v1","v2","v3"], [0.4,-0.5,0.4]);
	.wait(100);
	!sendMyknowHow("CARRY", ag1);
	!computeTrust(ag1, "CARRY");
	!computeTrust(ag3, "CARRY");
	!getBestCandidates("CARRY")
.