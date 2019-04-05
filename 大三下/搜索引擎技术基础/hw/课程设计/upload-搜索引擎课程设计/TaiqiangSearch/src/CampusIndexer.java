import net.paoding.analysis.analyzer.PaodingAnalyzer;
import org.apache.lucene.analysis.Analyzer;
import org.apache.lucene.document.Document;
import org.apache.lucene.document.Field;
import org.apache.lucene.index.IndexWriter;
import org.apache.lucene.index.IndexWriterConfig;
import org.apache.lucene.store.Directory;
import org.apache.lucene.store.FSDirectory;

import org.json.*;

import java.io.*;

import static org.apache.lucene.util.Version.LUCENE_35;

public class CampusIndexer {
    private Analyzer analyzer = null;
    public IndexWriter indexWriter = null;
    //private float averageLength = 1.0f;

    public CampusIndexer(String indexDir){
        try{
            analyzer = new PaodingAnalyzer();
            IndexWriterConfig iwc = new IndexWriterConfig(LUCENE_35, analyzer);
            Directory dir = FSDirectory.open(new File(indexDir));
            indexWriter = new IndexWriter(dir,iwc);
            //indexWriter.setSimilarity(new SimpleSimilarity());
        }catch(IOException e){
            e.printStackTrace();
        }
    }

    /*public void saveGlobals(String filename){
        try{
            PrintWriter pw = new PrintWriter(new File(filename));
            pw.println(averageLength);
            pw.close();
        }catch(IOException e){
            e.printStackTrace();
        }
    }*/


    public void indexSpecialFile(String filename){
        try{

            JSONTokener jsonTokener = new JSONTokener(new FileReader(new File(filename)));
            JSONArray jsonArray = new JSONArray(jsonTokener);
            int num = jsonArray.length();
            System.out.println(num);


            for(int i = 0;i < num;i++){
                JSONObject obj = jsonArray.getJSONObject(i);

                String title = obj.getString("title");
                String url = obj.getString("url");
                String pr = obj.getString("pr");
                String content = obj.getString("docContent");
                String anchor, h1, h2, h3, h4, h5, h6, strong;
                if(obj.has("anchor"))
                {
                    anchor = obj.getString("anchor");
                    h1 = obj.getString("h1");
                    h2 = obj.getString("h2");
                    h3 = obj.getString("h3");
                    h4 = obj.getString("h4");
                    h5 = obj.getString("h5");
                    h6 = obj.getString("h6");
                    strong = obj.getString("strong");
                }
                else
                {
                    anchor = null;
                    h1 = null;
                    h2 = null;
                    h3 = null;
                    h4 = null;
                    h5 = null;
                    h6 = null;
                    strong = null;
                }

                if (content != null) {
                    String new_title = content.length() > 20 ?
                            content.substring(0, 20) : content;

                    if (title.equals("DOCX")) {
                        title = new_title + ".docx";
                    } else if (title.equals("PDF")) {
                        title = new_title + ".pdf";
                    }
                }

                Document document = new  Document();

                if (title != null) {
                    Field titleField = new Field("title", title, Field.Store.YES, Field.Index.ANALYZED);
                    document.add(titleField);
                }
                if (url != null) {
                    Field urlField = new Field( "url", url,Field.Store.YES, Field.Index.ANALYZED);
                    document.add(urlField);
                }
                if (pr != null) {
                    Field prField = new Field( "pr", pr ,Field.Store.YES, Field.Index.NO);
                    document.add(prField);
                }
                if (content != null) {
                    Field contentField = new Field( "content" ,content,Field.Store.YES, Field.Index.ANALYZED);
                    document.add(contentField);
                }
                if (anchor != null) {
                    Field anchorField = new Field( "anchor" , anchor,Field.Store.YES, Field.Index.ANALYZED);
                    document.add(anchorField);
                }
                if (h1 != null) {
                    Field h1Field = new Field( "h1", h1,Field.Store.YES, Field.Index.ANALYZED);
                    document.add(h1Field);
                }
                if (h2 != null) {
                    Field h2Field = new Field( "h2", h2,Field.Store.YES, Field.Index.ANALYZED);
                    document.add(h2Field);
                }
                if (h3 != null) {
                    Field h3Field = new Field( "h3", h3,Field.Store.YES, Field.Index.ANALYZED);
                    document.add(h3Field);
                }
                if (h4 != null) {
                    Field h4Field = new Field( "h4", h4,Field.Store.YES, Field.Index.ANALYZED);
                    document.add(h4Field);
                }
                if (h5 != null) {
                    Field h5Field = new Field( "h5", h5,Field.Store.YES, Field.Index.ANALYZED);
                    document.add(h5Field);
                }
                if (h6 != null) {
                    Field h6Field = new Field( "h6", h6,Field.Store.YES, Field.Index.ANALYZED);
                    document.add(h6Field);
                }
                if (strong != null) {
                    Field strongField  =   new  Field( "strong" , strong,Field.Store.YES, Field.Index.ANALYZED);
                    document.add(strongField);
                }

                indexWriter.addDocument(document);

                if(i%100==0){
                    System.out.println("process "+i);
                }
            }

            System.out.println("total "+indexWriter.numDocs()+" documents");

            //part2/2:获得spellchecker分词词库,重要代码不可删!
            /*BufferedWriter fileWriter =
                    new BufferedWriter(
                            new OutputStreamWriter(
                                    new FileOutputStream(
                                            new File("input/spell.txt"))));
            //HashSet hs = new HashSet(spellWords);
            System.out.println("hs.size()" + spellWords.size());
            Iterator<String> iterator=spellWords.iterator();
            while(iterator.hasNext()){
                //System.out.println(iterator.next());
                fileWriter.write(iterator.next()+" ");
            }
            fileWriter.close();*/

        }catch(Exception e){
            e.printStackTrace();
        }
    }
    public static void main(String[] args) {
        CampusIndexer indexer=new CampusIndexer("forIndex/index");
        for (int i = 0; i < 29; i++)
        {
            indexer.indexSpecialFile("input/index" + i + ".json");
        }
        try
        {
            indexer.indexWriter.close();
        }
        catch (Exception e)
        {
            e.printStackTrace();
        }
//        indexer.indexSpecialFile("index_merge.xml");
//        indexer.indexSpecialFile("input/new_data_delete.xml");
        //indexer.saveGlobals("forIndex/global.txt");
    }
}
