import net.paoding.analysis.analyzer.PaodingAnalyzer;
import org.apache.lucene.analysis.Analyzer;
import org.apache.lucene.document.Document;
import org.apache.lucene.index.IndexReader;
import org.apache.lucene.search.IndexSearcher;
import org.apache.lucene.search.Query;
import org.apache.lucene.search.TopDocs;
import org.apache.lucene.store.FSDirectory;

import java.io.File;
import java.io.IOException;

public class CampusSearcher {

	private IndexReader reader;
	public IndexSearcher searcher;
	public Analyzer analyzer = null;
	//private float avgLength=1.0f;


	public CampusSearcher(String indexdir){
		analyzer = new PaodingAnalyzer();
		try{
			reader = IndexReader.open(FSDirectory.open(new File(indexdir)));
			searcher = new IndexSearcher(reader);
			//searcher.setSimilarity(new SimpleSimilarity());
		}catch(IOException e){
			e.printStackTrace();
		}
	}

	public TopDocs searchQuery(Query query, int maxnum){

		/*try {
			Term term=new Term(field,queryString);
			Query query=new SimpleQuery(term,avgLength);
			query.setBoost(1.0f);
			//Weight w=searcher.createNormalizedWeight(query);
			//System.out.println(w.getClass());
			TopDocs results = searcher.search(query, maxnum);
			System.out.println(results);
			return results;
		} catch (Exception e) {
			e.printStackTrace();
		}
		return null;*/

        /*StringBuffer sb = new StringBuffer();
        StringReader reader = new StringReader(queryString);
        TokenStream ts = this.analyzer.tokenStream(queryString, reader);

        TermAttribute termAtt = (TermAttribute) ts
                .addAttribute(TermAttribute.class);
        try {
            while (ts.incrementToken()) {
                sb.append(termAtt.term());
                sb.append(" ");
            }
        } catch (IOException e) {
            e.printStackTrace();
        }

        queryString += " " + sb.toString();*/

		//return sb.toString();

        /*StringReader r = new StringReader(queryString);
        IKSegmentation Ikseg= new IKSegmentation(r);
        Lexeme next;
        String s="";
        try {
            next=Ikseg.next();

            while (next!=null)
            {
                s=s+" "+next.getLexemeText();
                System.out.println(next.getLexemeText());
                next=Ikseg.next();
            }
        } catch (IOException e) {
            e.printStackTrace();
        }

        queryString += " " + s;
*/

		//String[] words = queryString.split("\\s+");



		//Query query=MultiFieldQueryParser.parse(words, field, occ, analyzer);
		//System.out.println("QueryParser :" + queryString);

		TopDocs topDocs = null;
		try {
			topDocs = searcher.search(query, maxnum);
		} catch (IOException e) {
			e.printStackTrace();
		}

		return topDocs;
	}

	public Document getDoc(int docID){
		try{
			return searcher.doc(docID);
		}catch(IOException e){
			e.printStackTrace();
		}
		return null;
	}
	
	/*public void loadGlobals(String filename){
		try{
			BufferedReader reader = new BufferedReader(new InputStreamReader(new FileInputStream(filename)));
			String line=reader.readLine();
			avgLength=Float.parseFloat(line);
			reader.close();
		}catch(IOException e){
			e.printStackTrace();
		}
	}*/
	
	/*public float getAvg(){
		return avgLength;
	}*/
	
	/*public static void main(String[] args){
		*//*ImageSearcher search=new ImageSearcher("forIndex/index");
		search.loadGlobals("forIndex/global.txt");
		System.out.println("avg length = "+search.getAvg());
		
		TopDocs results=search.searchQuery("宋祖德", 100);
		ScoreDoc[] hits = results.scoreDocs;
		for (int i = 0; i < hits.length; i++) { // output raw format
			Document doc = search.getDoc(hits[i].doc);
			System.out.println("doc=" + hits[i].doc + " score="
					+ hits[i].score+" picPath= "+doc.get("picPath"));
		}*//*
	}*/
}
