package reputationAndImage.model;

import jason.asSemantics.Agent;
import jason.bb.DefaultBeliefBase;

/**
 * This class is used to set the time when a belief is added in the belief base (BB)
 */
public class TimeBB extends DefaultBeliefBase 
{
	public static long start;
	
	@Override
	public void init(Agent ag, String[] args) 
	{
		start = System.currentTimeMillis();
		super.init(ag,args);
	}
}