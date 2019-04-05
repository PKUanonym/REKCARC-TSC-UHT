import net.paoding.analysis.analyzer.PaodingAnalyzer;
import org.apache.lucene.analysis.Analyzer;
import org.apache.lucene.document.Document;
import org.apache.lucene.document.Field;
import org.apache.lucene.index.IndexWriter;
import org.apache.lucene.index.IndexWriterConfig;
import org.apache.lucene.store.Directory;
import org.apache.lucene.store.FSDirectory;
import org.w3c.dom.NamedNodeMap;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import java.io.*;

import static org.apache.lucene.util.Version.LUCENE_35;

public class CampusIndexer {
    private Analyzer analyzer = null;
    private IndexWriter indexWriter = null;
    private int fieldNum = 11;
    private float averageLength[] = new float[fieldNum];

    public CampusIndexer(String indexDir){
        for(int i=0;i<fieldNum;i++){
            averageLength[i] = 1.0f;
        }
        try{
            analyzer = new PaodingAnalyzer();
            IndexWriterConfig iwc = new IndexWriterConfig(LUCENE_35, analyzer);
            Directory dir = FSDirectory.open(new File(indexDir));
            indexWriter = new IndexWriter(dir,iwc);
            indexWriter.setSimilarity(new SimpleSimilarity());
        }catch(IOException e){
            e.printStackTrace();
        }
    }

    public void saveGlobals(String filename){
        try{
            PrintWriter pw = new PrintWriter(new File(filename));
            for(int i=0;i<fieldNum;i++) {
                pw.println(averageLength[i]);
            }
            pw.close();
        }catch(IOException e){
            e.printStackTrace();
        }
    }


    public void indexSpecialFile(String filename){
        try{
            DocumentBuilderFactory dbf = DocumentBuilderFactory.newInstance();
            DocumentBuilder db = dbf.newDocumentBuilder();
            org.w3c.dom.Document doc = db.parse(new File(filename));
            NodeList nodeList = doc.getElementsByTagName("doc");
            int num = nodeList.getLength();

            //HashSet<String> spellWords = new HashSet<>();

            //Pattern p = Pattern.compile("[a-z]+|[A-Z]+|[0-9]+");

            for(int i = 0;i < num;i++){

                Node node = nodeList.item(i);
                NamedNodeMap map = node.getAttributes();

                Node title = map.getNamedItem("title");
                Node url = map.getNamedItem("url");
                Node pr = map.getNamedItem("pr");
                Node content = map.getNamedItem("docContent");
                Node anchor = map.getNamedItem("anchor");
                Node h1 = map.getNamedItem("h1");
                Node h2 = map.getNamedItem("h2");
                Node h3 = map.getNamedItem("h3");
                Node h4 = map.getNamedItem("h4");
                Node h5 = map.getNamedItem("h5");
                Node h6 = map.getNamedItem("h6");
                Node strong = map.getNamedItem("strong");

                String[] attr = new String[fieldNum];
                attr[0] = title.getNodeValue();
                attr[1] = url.getNodeValue();
                attr[2] = content.getNodeValue();
                attr[3] = anchor.getNodeValue();
                attr[4] = h1.getNodeValue();
                attr[5] = h2.getNodeValue();
                attr[6] = h3.getNodeValue();
                attr[7] = h4.getNodeValue();
                attr[8] = h5.getNodeValue();
                attr[9] = h6.getNodeValue();
                attr[10] = strong.getNodeValue();

                for(int j=0;j<fieldNum;j++){
                    averageLength[j] += attr[j].length();
                }

                //part1/2:获得spellchecker分词词库,重要代码不可删!
                /*String[] attr = new String[7];
                attr[0] = title.getNodeValue();
                attr[1] = h1.getNodeValue();
                attr[2] = content.getNodeValue();
                attr[3] = anchor.getNodeValue();
                attr[4] = strong.getNodeValue();

                //StringBuffer sb = new StringBuffer();


                for(int j=0;j<5;j++) {

                    StringReader reader = new StringReader(attr[j]);
                    TokenStream ts = this.analyzer.tokenStream(attr[j], reader);

                    TermAttribute termAtt = (TermAttribute) ts
                            .addAttribute(TermAttribute.class);
                    try {
                        while (ts.incrementToken()) {
                            //sb.append(termAtt.term());
                            //sb.append("\n");
                            //if(!spellWords.contains(termAtt.term()))

                            Matcher m = p.matcher(termAtt.term());
                            if(!m.find()) {
                                spellWords.add(termAtt.term());
                            }
                        }
                    } catch (IOException e) {
                        e.printStackTrace();
                    }
                }*/

                String new_title = content.getNodeValue().length() > 20 ?
                        content.getNodeValue().substring(0, 20) : content.getNodeValue();

                if(title.getNodeValue().equals("DOCX")){
                    title.setNodeValue(new_title + ".docx");
                }else if(title.getNodeValue().equals("PDF")){
                    title.setNodeValue(new_title + ".pdf");
                }

                Field titleField = new Field( "title", title.getNodeValue(), Field.Store.YES, Field.Index.ANALYZED);
                Field urlField = new Field( "url", url.getNodeValue(),Field.Store.YES, Field.Index.ANALYZED);
                Field prField = new Field( "pr", pr.getNodeValue(),Field.Store.YES, Field.Index.NO);
                Field contentField = new Field( "content" ,content.getNodeValue(),Field.Store.YES, Field.Index.ANALYZED);
                Field anchorField = new Field( "anchor" , anchor.getNodeValue(),Field.Store.YES, Field.Index.ANALYZED);
                Field h1Field = new Field( "h1", h1.getNodeValue(),Field.Store.YES, Field.Index.ANALYZED);
                Field h2Field = new Field( "h2", h2.getNodeValue(),Field.Store.YES, Field.Index.ANALYZED);
                Field h3Field = new Field( "h3", h3.getNodeValue(),Field.Store.YES, Field.Index.ANALYZED);
                Field h4Field = new Field( "h4", h4.getNodeValue(),Field.Store.YES, Field.Index.ANALYZED);
                Field h5Field = new Field( "h5", h5.getNodeValue(),Field.Store.YES, Field.Index.ANALYZED);
                Field h6Field = new Field( "h6", h6.getNodeValue(),Field.Store.YES, Field.Index.ANALYZED);
                Field strongField  =   new  Field( "strong" , strong.getNodeValue() ,Field.Store.YES, Field.Index.ANALYZED);

                Document document = new  Document();

                document.add(titleField);
                document.add(urlField);
                document.add(prField);
                document.add(contentField);
                document.add(anchorField);
                document.add(h1Field);
                document.add(h2Field);
                document.add(h3Field);
                document.add(h4Field);
                document.add(h5Field);
                document.add(h6Field);
                document.add(strongField);

                indexWriter.addDocument(document);

                if(i%10000==0){
                    System.out.println("process "+i);
                }
            }

            for(int j=0;j<fieldNum;j++){
                averageLength[j] /= indexWriter.numDocs();
            }
            System.out.println("total "+indexWriter.numDocs()+" documents");
            indexWriter.close();

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
        indexer.indexSpecialFile("input/new_data_delete.xml");
        indexer.saveGlobals("forIndex/global.txt");
    }
}
