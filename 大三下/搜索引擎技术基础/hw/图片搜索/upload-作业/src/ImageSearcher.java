import java.io.*;
import java.io.IOException;

import org.apache.lucene.analysis.Analyzer;
import org.apache.lucene.analysis.standard.StandardAnalyzer;
import org.apache.lucene.document.Document;
import org.apache.lucene.index.IndexReader;
import org.apache.lucene.index.Term;
import org.apache.lucene.queryParser.ParseException;
import org.apache.lucene.queryParser.QueryParser;
import org.apache.lucene.search.BooleanClause.Occur;
import org.apache.lucene.search.BooleanQuery;
import org.apache.lucene.search.IndexSearcher;
import org.apache.lucene.search.Query;
import org.apache.lucene.search.ScoreDoc;
import org.apache.lucene.search.TermQuery;
import org.apache.lucene.search.TopDocs;
import org.apache.lucene.search.Weight;
import org.apache.lucene.store.FSDirectory;
import org.apache.lucene.util.Version;
import org.apache.lucene.analysis.TokenStream;  
import org.wltea.analyzer.lucene.IKAnalyzer;
import org.apache.lucene.analysis.tokenattributes.CharTermAttribute;

public class ImageSearcher {
	private IndexReader reader;
	private IndexSearcher searcher;
	private Analyzer analyzer;
	private float avgLength=1.0f;
	
	public ImageSearcher(String indexdir){
		analyzer = new IKAnalyzer();
		try{
			reader = IndexReader.open(FSDirectory.open(new File(indexdir)));
			searcher = new IndexSearcher(reader);
			searcher.setSimilarity(new SimpleSimilarity());
		}catch(IOException e){
			e.printStackTrace();
		}
	}
	
	public TopDocs searchQuery(String queryString,String field1, String field2,int maxnum){
		try {
			StringReader reader = new StringReader(queryString);
			TokenStream  tokenStream  = analyzer.tokenStream("", reader);  
	        tokenStream.reset();  
	        CharTermAttribute term = tokenStream.getAttribute(CharTermAttribute.class);  
			//final query
			BooleanQuery finalQuery = new BooleanQuery();
	        while(tokenStream.incrementToken()){
	        	String tmpQueryString = term.toString();
				Term term1=new Term(field1,tmpQueryString);
				Term term2 = new Term(field2, tmpQueryString);
				//Query query=new SimpleQuery(term,avgLength);
				Query query = new TermQuery(term1);
				query.setBoost(1.0f);
				Query query2 = new TermQuery(term2);
				query2.setBoost(1.0f);
				finalQuery.add(query, Occur.SHOULD);
				finalQuery.add(query2, Occur.SHOULD);
	        }
			
			//Weight w=searcher.createNormalizedWeight(query);
			//System.out.println(w.getClass());
			TopDocs results = searcher.search(finalQuery, maxnum);
			System.out.println(results);
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
			String line=reader.readLine();
			avgLength=Float.parseFloat(line);
			reader.close();
		}catch(IOException e){
			e.printStackTrace();
		}
	}
	
	public float getAvg(){
		return avgLength;
	}
	
	public static void main(String[] args){
		ImageSearcher search=new ImageSearcher("forIndex/index");
		search.loadGlobals("forIndex/global.txt");
		System.out.println("avg length = "+search.getAvg());
		
		TopDocs results=search.searchQuery("ËÎ×æµÂ", "abstract", "title", 100);
		ScoreDoc[] hits = results.scoreDocs;
		for (int i = 0; i < hits.length; i++) { // output raw format
			Document doc = search.getDoc(hits[i].doc);
			System.out.println("doc=" + hits[i].doc + " score="
					+ hits[i].score+" picPath= "+doc.get("picPath"));
		}
	}
}
