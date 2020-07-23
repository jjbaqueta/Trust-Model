package reputationAndImage.model;

/**
 * This class implements the skill enum.
 * It is used to define the agents' specializations.
 */

public enum Skill 
{
	CARRY(1),
	DELIVER(2),
	CHARGE(3);
	
	private Integer id;
	
	private Skill(Integer id) 
	{
		this.id = id;
	}
	
	public Integer getId()
	{
		return this.id;
	}
}