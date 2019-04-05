import net.paoding.analysis.analyzer.PaodingAnalyzer;
import org.apache.lucene.analysis.Analyzer;
import org.apache.lucene.document.Document;
import org.apache.lucene.index.IndexReader;
import org.apache.lucene.search.IndexSearcher;
import org.apache.lucene.search.Query;
import org.apache.lucene.search.TopDocs;
import org.apache.lucene.store.FSDirectory;

import java.io.*;

public class CampusSearcher {

	private IndexReader reader;
	public IndexSearcher searcher;
	public Analyzer analyzer = null;
	public float avgLength[] = new float[11];


	public CampusSearcher(String indexdir){
		analyzer = new PaodingAnalyzer();
		try{
			reader = IndexReader.open(FSDirectory.open(new File(indexdir)));
			searcher = new IndexSearcher(reader);
			searcher.setSimilarity(new SimpleSimilarity());
		}catch(IOException e){
			e.printStackTrace();
		}
	}

	public TopDocs searchQuery(Query query, int maxnum){

		/*TopDocs topDocs = null;
		try {
			topDocs = searcher.search(query, maxnum);
		} catch (IOException e) {
			e.printStackTrace();
		}
		return topDocs;*/

		try {

			//Weight w=searcher.createNormalizedWeight(query);
			//System.out.println(w.getClass());
			TopDocs results = searcher.search(query, maxnum);
			System.out.println(results.getMaxScore());
			return results;
		} catch (Exception e) {
			e.printStackTrace();
		}
		return null;

	}

	public Document getDoc(int docID){
		try{
			return searcher.doc(docID);
		}catch(IOException e){
			e.printStackTrace();
		}
		return null;
	}
	
	public void loadGlobals(String filename){
		try{
			BufferedReader reader = new BufferedReader(new InputStreamReader(new FileInputStream(filename)));
            String line = null;
            int counter = 0;
			while((line=reader.readLine())!=null) {
                avgLength[counter] = Float.parseFloat(line);
                System.out.print("[searcher] avgLength:"+avgLength[counter]+" ");
                counter++;
            }
            reader.close();
		}catch(IOException e){
			e.printStackTrace();
		}
	}
	
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
