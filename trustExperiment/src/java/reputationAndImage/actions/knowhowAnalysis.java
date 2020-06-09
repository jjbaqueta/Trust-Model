package reputationAndImage.actions;

import java.util.Set;
import java.util.TreeSet;

import jason.asSemantics.DefaultInternalAction;
import jason.asSemantics.TransitionSystem;
import jason.asSemantics.Unifier;
import jason.asSyntax.ListTerm;
import jason.asSyntax.Literal;
import jason.asSyntax.NumberTerm;
import jason.asSyntax.StringTerm;
import jason.asSyntax.Structure;
import jason.asSyntax.Term;
import reputationAndImage.model.Impression;
import reputationAndImage.model.Mnemonic;
import reputationAndImage.model.Skill;
import reputationAndImage.model.TimeBB;
import reputationAndImage.services.ImpressionAggregation;
import reputationAndImage.services.ImpressionConverter;

/**
 * This class implements an action executed by an agent.
 * Action: evaluation about the knowhow of a given agent.
 */
public class knowhowAnalysis extends DefaultInternalAction
{
	private static final long serialVersionUID = 1L;
	
	/**
	 * Action's arguments (from args parameter):
	 * args[0]: agent's name (provider).
	 * args[1]: references of the agent considering its work history (impressions).
	 */
	@Override
	public Object execute(TransitionSystem ts,	Unifier un, Term[] args) throws Exception 
	{	
		String providerName = args[0].toString();
		ListTerm list = (ListTerm) args[1];
		Set<Impression> references = new TreeSet<Impression>();
		
		for(Term imp : list)
			references.add(Impression.parserBeleif((Structure) imp));
		
		Impression impTemp = (Impression) references.toArray()[0];
		Impression referenceValue = ImpressionAggregation.run(references, 
				impTemp.getRequesterName(), impTemp.getProviderName(), 
				impTemp.getSkill(), impTemp.getCriteria());
		return true;
		
//		Literal reference = ImpressionConverter.run(impression, Mnemonic.IMPRESSION);
//		ts.getAg().addBel((Literal) reference.clone());
//		
//		return un.unifies(reference, args[5]);
	}
	
	/*
	 * This method computes the reliability of subjective reputation 
	 * @param subjectiveRep Subjective reputation from criterion selected.
	 * @param currentTime Time instant used during the computation of subjective reputation.
	 * @param ratings List of impressions considered to compute the subjective reputation.
	 * @return how much reliable is the subjective reputation for each evaluated criterion
	 */
//	public double[] computeReliability(double[] subjectiveRep, long currentTime, List<Rating> ratings)
//	{
//		// Computing population average
//		double averagePrice = 0, averageQuality = 0, averageDelivery = 0;
//		
//		double[] reliabilities = new double[criteria.size()];		// Stores reliability degree for each subjective reputation value
//		double[] deviations = computeDeviation(subjectiveRep, currentTime, ratings);
//		double ni = computeNi(ratings);
//		
//		for(Rating rating : ratings)
//		{
//			averagePrice += (double) rating.getScores().get(criteria.get(0).getName());
//			averageQuality += (double) rating.getScores().get(criteria.get(1).getName());
//			averageDelivery += (double) rating.getScores().get(criteria.get(2).getName());
//		}
//		averagePrice /= ratings.size();
//		averageQuality /= ratings.size();
//		averageDelivery /= ratings.size();
//		
//		// Computing reliability
//		reliabilities[0] = (1 - averagePrice) * ni + averagePrice * deviations[0];
//		reliabilities[1] = (1 - averageQuality) * ni + averageQuality * deviations[1];
//		reliabilities[2] = (1 - averageDelivery) * ni + averageDelivery * deviations[2];
//		
//		return reliabilities;
//	}
//	
//	/*
//	 * This method computes the importance level of impressions list.
//	 * The intimate level of interactions (ITM) is adopted in order to minimize the effects from ratings with low occurrence levels.
//	 * @param impressions List of impressions considered to compute the subjective reputation.
//	 * @return how much expressive is the list of impressions
//	 */
//	private static double computeNi(List<Rating> ratings)
//	{	
//		// Number of impressions used to calculate the reputation.
//		int cardinality = ratings.size();
//	
//		/*
//		 * Computing Ni
//		 * If the rating cardinality is below the ITM, the importance of impressions is reduced (to a value less than 1).
//		 * Otherwise, the importance level is defined as 1. 
//		 */
//		if(cardinality <= ITM)
//			return Math.sin(Math.PI/(2 * ITM) * cardinality);
//		else
//			return 1;
//}
}
