package reputationAndImage.services;

import java.util.Set;

import reputationAndImage.model.Impression;
import reputationAndImage.model.Skill;
import reputationAndImage.model.TimeBB;

public class ImpressionAggregation 
{
	/**
	 * This method aggregates a set of impressions in a single impression. 
	 * @param impressions: a set of impressions.
	 * @param requestName: the name of requester agent.
	 * @param providerName: the name of provider agent.
	 * @param skill: the skill which the evaluation refers.
	 * @param criteria: a set of evaluation criteria.
	 * @return an impression resulting of aggregation operation.
	 */
	public static Impression run(Set<Impression> impressions, String requesterName, String providerName, 
			Skill skill, Set<String> criteria)
	{
		long aggrTime = System.currentTimeMillis() - TimeBB.start;
		
		double tj = fTj(impressions, aggrTime);
		double ti, aggrValue; 
		
		Impression resultImp = new Impression(requesterName, providerName,
				aggrTime, skill);
		
		for(String criterion : criteria)
		{
			aggrValue = 0;
			
			for(Impression imp : impressions)
			{
				ti = (((double) imp.getTime() / aggrTime) / tj);
				aggrValue += imp.getValue(criterion) * ti;
			}
			resultImp.insertRating(criterion, aggrValue);
		}
		return resultImp;
	}

	/**
	 * This method applies a time adjusting based on the time function f(t, tj). 
	 * The idea is reducing the effects of older ratings on the image and reputation computing.
	 * @param impressions: a set of impressions.
	 * @param aggrTime: time when the aggregation operation was started.
	 * @return time adjustment factor. 
	 */
	private static double fTj(Set<Impression> impressions, long aggrTime)
	{
		double tj = 0;
		
		for(Impression imp : impressions)
		{
			tj += (double) imp.getTime() / aggrTime;
		}
		return tj;
	}
}