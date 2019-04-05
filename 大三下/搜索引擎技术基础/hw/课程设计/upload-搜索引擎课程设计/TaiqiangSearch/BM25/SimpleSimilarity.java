
import org.apache.lucene.index.FieldInvertState;
import org.apache.lucene.search.Similarity;


public class SimpleSimilarity extends Similarity {

	@Override
	public float computeNorm(String field, FieldInvertState state) {
		final int numTerms;
	    if (discountOverlaps)
	      numTerms = state.getLength() - state.getNumOverlap();
	    else
	      numTerms = state.getLength();
	    return state.getBoost() * ((float) (1.0 / Math.sqrt(numTerms)));
	}

	@Override
	public float queryNorm(float sumOfSquaredWeights) {
		return 1.0f;
	}

	@Override
	public float tf(float freq) {
		return freq;
	}

	@Override
	public float sloppyFreq(int distance) {
		return 1.0f;
	}

	@Override
	public float idf(int docFreq, int numDocs) {
		float result = (numDocs - docFreq + 0.5f);
		result = result / (docFreq + 0.5f);
		return (float) Math.log(result);
	}

	@Override
	public float coord(int overlap, int maxOverlap) {
		return 1.0f;
	}

	// Default true
	protected boolean discountOverlaps = true;

	public void setDiscountOverlaps(boolean v) {
		discountOverlaps = v;
	}

	public boolean getDiscountOverlaps() {
		return discountOverlaps;
	}
}
