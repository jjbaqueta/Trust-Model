package trustExperiment;

import fuzzyCognitiveMaps.model.FuzzyGraph;
import fuzzyCognitiveMaps.model.FuzzyUtil;
import fuzzyCognitiveMaps.services.BfsVisitor;
import fuzzyCognitiveMaps.services.GenerateDotFileVisitor;
import fuzzyCognitiveMaps.services.PropagateInputsVisitor;

public class Main {

	public static void main(String[] args) 
	{	
		FuzzyGraph fuzzyMap = FuzzyUtil.fuzzyMap1();
		
		// Starting the services
		PropagateInputsVisitor propagateVisitor = new PropagateInputsVisitor(FuzzyUtil.getInputsFuzzyMap1());
		GenerateDotFileVisitor dotVisitor = new GenerateDotFileVisitor();
		BfsVisitor bfsVisitor = new BfsVisitor();
		
		fuzzyMap.accept(propagateVisitor);
		fuzzyMap.accept(dotVisitor);
		fuzzyMap.accept(bfsVisitor);
		
//		String filename = "jfuzzy_files/trustOnMe.fcl";
//		FIS fis = FIS.load(filename, true);
//
//		if (fis == null) {
//			System.err.println("Can't load file: '" + filename + "'");
//			System.exit(1);
//		}
//
//		// Get default function block
//		FunctionBlock fb = fis.getFunctionBlock(null);
//
//		// Set inputs
//		fb.setVariable("trust", fuzzyMap.getOutput().getValue());
//
//		// Evaluate
//		fb.evaluate();
//
//		// Show output variable's chart
//		fb.getVariable("decision").defuzzify();
//
//		// Print ruleSet
//		System.out.println(fb);
//		System.out.println("Decision: " + fb.getVariable("decision").getValue());
	}
}
