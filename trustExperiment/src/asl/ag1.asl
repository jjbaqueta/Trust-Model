/* modules */

{ include("socialModule.asl") }	// rules and plans for agents make social evaluations

!start.

+!start : true
<-  .wait(100);
	!sendMyknowHow("CARRY", ag2);
	!computeTrust(ag2, "CARRY");
	!computeTrust(ag3, "CARRY");
	!getBestCandidates("CARRY")
.