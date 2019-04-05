import org.apache.lucene.analysis.TokenStream;
import org.apache.lucene.document.Document;
import org.apache.lucene.queryParser.MultiFieldQueryParser;
import org.apache.lucene.queryParser.ParseException;
import org.apache.lucene.queryParser.QueryParser;
import org.apache.lucene.search.Query;
import org.apache.lucene.search.ScoreDoc;
import org.apache.lucene.search.TopDocs;
import org.apache.lucene.search.highlight.Formatter;
import org.apache.lucene.search.highlight.*;
import org.apache.lucene.util.Version;
import org.wltea.analyzer.lucene.IKAnalyzer;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.StringReader;
import java.util.*;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import java.net.URL;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.Reader;
import java.net.URL;
import java.nio.charset.Charset;
import java.net.URLEncoder;

import org.json.JSONException;
import org.json.JSONObject;
import org.json.JSONArray;


public class CampusServer extends HttpServlet{

    public static final int PAGE_RESULT = 10;
    public static final String indexDir = "forIndex";
    private String[] field = new String[]{"title","url","anchor","content","h1","h2","h3","h4","h5","h6","strong"};
    private CampusSearcher search = null;
    private DidYouMeanSearcher meanSearcher = null;

    public CampusServer(){
        super();
        search = new CampusSearcher(indexDir + "/index");
        meanSearcher = new DidYouMeanSearcher("spellIndex/", null, null);
    }

    public ScoreDoc[] showList(ScoreDoc[] results, List<Map.Entry<Integer, Double>> infoIDs, int page){
        if(results == null || results.length < (page - 1) * PAGE_RESULT){
            return null;
        }
        int start = Math.max((page-1) * PAGE_RESULT, 0);
        int docNum = Math.min(results.length - start, PAGE_RESULT);
        ScoreDoc[] ret = new ScoreDoc[docNum];
        for(int i = 0;i < docNum;i++){
            ret[i] = results[infoIDs.get(start + i).getKey()];
        }
        return ret;
    }

    /*private IndexWriterConfig getConfig() {
        return new IndexWriterConfig(Version.LUCENE_35, new IKAnalyzer(true));
    }*/

    /*private String[] getSuggestions(SpellChecker spellchecker, String word, int numSug) throws IOException {
        return spellchecker.suggestSimilar(word, numSug);
    }*/

    /*public String[] search(String word, int numSug) {
        directory = new RAMDirectory();
        try {
            spellchecker = new SpellChecker(directory);
            spellchecker.indexDictionary(new PlainTextDictionary(new File("spell.txt")), getConfig(), true);
            return getSuggestions(spellchecker, word, numSug);
        } catch (IOException e) {
            e.printStackTrace();
            return null;
        }
    }*/

    public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        System.out.println("Working Directory = " +
                System.getProperty("user.dir"));
        long t1 = System.currentTimeMillis(); // 排序前取得当前时间
        response.setContentType("text/html;charset=utf-8");
        request.setCharacterEncoding("utf-8");
        String queryString = request.getParameter("query");
        String pageString = request.getParameter("page");

        int page = 1;

        if (pageString != null) {
            page = Integer.parseInt(pageString);
        }
        if (queryString == null || queryString.length() < 1) {
            System.out.println("null query");
            return;
            //request.getRequestDispatcher("/Image.jsp").forward(request, response);
        }

        //if(queryString.charAt(queryString.length()-1) != '~'){
        //    queryString += "~";
        //}

        System.out.println("doGet:" + queryString);
        //System.out.println(URLDecoder.decode(queryString,"utf-8"));
        //System.out.println(URLDecoder.decode(queryString,"gb2312"));
        String[] highlightTitles = null;
        String[] highlightURLs = null;
        String[] highlightContents = null;

        /*String[] searchWords = {"Java AND Lucene", "Java NOT Lucene", "JavaOR Lucene",

                "+Java +Lucene", "+Java -Lucene"};*/


        //Query query;

        /*for(int i = 0; i < searchWords.length; i++){

            query = QueryParser.parse(searchWords[i], "title", language);

            Hits results = search.searchQuery(query);

            System.out.println(results.length() + "search results for query " +searchWords[i]);
        }*/
        Map<String, Float> boosts = new HashMap<>();
        MultiFieldQueryParser parser = null;
        //url正则表达式
        String pattern = "([a-zA-Z0-9\\.\\-]+(\\:[a-zA-Z0-9\\.&amp;%\\$\\-]+)*@)?((25[0-5]|2[0-4][0-9]|[0-1]{1}[0-9]{2}|[1-9]{1}[0-9]{1}|[1-9])\\.(25[0-5]|2[0-4][0-9]|[0-1]{1}[0-9]{2}|[1-9]{1}[0-9]{1}|[1-9]|0)\\.(25[0-5]|2[0-4][0-9]|[0-1]{1}[0-9]{2}|[1-9]{1}[0-9]{1}|[1-9]|0)\\.(25[0-5]|2[0-4][0-9]|[0-1]{1}[0-9]{2}|[1-9]{1}[0-9]{1}|[0-9])|([a-zA-Z0-9\\-]+\\.)*[a-zA-Z0-9\\-]+\\.[a-zA-Z]{2,4})(\\:[0-9]+)?(/[^/][a-zA-Z0-9\\.\\,\\?\\'\\/\\+&amp;%\\$#\\=~_\\-@]*)*$";
        String regex = "~|-|NOT|AND|OR|\\*|\\.|\\?|\\+|\\$|\\^|\\[|\\]|\\(|\\)|\\{|\\}|\\||\\/";
        Pattern r = Pattern.compile(pattern);
        Matcher m = r.matcher(queryString);
        int flag = 1;
        if (m.find()) {
            flag = 1;
            boosts.clear();
            boosts.put("url", 1.0f);
            System.out.println("m.find");
            parser = new MultiFieldQueryParser(
                    Version.LUCENE_35,
                    new String[]{"url"},
                /*new StandardAnalyzer(Version.LUCENE_35),
                boosts );*/
                    search.analyzer,
                    boosts);
        } else {
            flag = 0;
            boosts.clear();
            boosts.put("title", 5.0f);
            boosts.put("url", 5.0f);
            boosts.put("content", 0.2f);
            boosts.put("anchor", 1.0f);
            boosts.put("h1", 1.2f);
            boosts.put("h2", 1.0f);
            boosts.put("h3", 0.8f);
            boosts.put("h4", 0.6f);
            boosts.put("h5", 0.4f);
            boosts.put("h6", 0.2f);
            boosts.put("strong", 0.8f);

            parser = new MultiFieldQueryParser(
                    Version.LUCENE_35,
                    field,
                /*new StandardAnalyzer(Version.LUCENE_35),
                boosts );*/
                    search.analyzer,
                    boosts);
            //queryString += "~";
        }

        /**用MultiFieldQueryParser类实现对同一关键词的跨域搜索
         * */
        //MultiFieldQueryParser

        meanSearcher.setAccuracy(0.65);
        int new_query_flag = 0;
        String[] querySplit = queryString.replaceAll(regex, "").split("[\\s]+");

        String new_queryString = "";
        meanSearcher.setAccuracy(0.6);
        for (String tmp : querySplit){
            if(!meanSearcher.spellChecker.exist(tmp)) {
                String[] suggest = meanSearcher.search(tmp, 1);
                if (suggest.length > 0 && suggest[0].length() > 1) {
                    if (suggest[0].equals(tmp)) {
                        new_queryString += tmp + " ";
                    } else {
                        new_query_flag = 1;
                        new_queryString += suggest[0] + " ";
                    }
                }
            }
            else {
                new_queryString += tmp + " ";
            }
            //meanSearcher
            //String[] suggest = search(queryString, 5);
        }

        if(new_query_flag == 1 && new_queryString.length() > 0){
            new_queryString = new_queryString.substring(0, new_queryString.length()-1);
            System.out.println("suggestions:");
            //for (String s : suggest) {
            System.out.println(new_queryString);
            request.setAttribute("suggest", new_queryString);
            //queryString = new_queryString;
        }
        else{
            request.setAttribute("suggest", null);
        }
        Query query = null;
        try {
            query = parser.parse(queryString);
            //queryString = queryString.replaceAll("~","");
        } catch (ParseException e) {
            e.printStackTrace();
        }

        //创建高亮器对象：需要一些辅助类对象作为参数
        Formatter formatter = new SimpleHTMLFormatter("<span style=\"color:#dd4b39;\">", "</span>");
        //被高亮文本前后加的标签前后缀
        Scorer scorer = null;//创建一个Scorer对象，传入一个Lucene的条件对象Query
        try {

            scorer = new QueryScorer(new QueryParser(Version.LUCENE_35, "concent", new IKAnalyzer())
                    .parse(queryString.replaceAll(regex,"")));
            //scorer = new QueryScorer(parser.parse(queryString));
            //System.out.println("123:"+queryString);

        } catch (ParseException e) {
            e.printStackTrace();
        }
        //正式创建高亮器对象
        Highlighter highlighter = new Highlighter(formatter, scorer);
        //设置被高亮的文本返回的摘要的文本大小
        Fragmenter fragmenter = new SimpleFragmenter(100);//默认是50个字符
        //让大小生效
        highlighter.setTextFragmenter(fragmenter);

        TopDocs results = search.searchQuery(query, 1000);//Math.abs(new Random().nextInt())%300 + 500);

        int totalNum = 0;

        if (results != null) {
            totalNum = results.scoreDocs.length;
            Map<Integer, Double> prMap = new HashMap<>();
            for(int i = 0;i < totalNum;i++){
                double s = results.scoreDocs[i].score + results.scoreDocs[i].score * 10000 * Double.parseDouble(search.getDoc(results.scoreDocs[i].doc).get("pr"));
                String url_tmp = ((String)(search.getDoc(results.scoreDocs[i].doc).get("url")));
                String title_tmp = ((String)(search.getDoc(results.scoreDocs[i].doc).get("title")));
                if(url_tmp.contains("index.html") && flag == 0){
                    s *= 2.0;
                }
                if(title_tmp.contains(".docx") || title_tmp.equals(".pdf")){
                    s*=2.0;
                }
//                s *= 100.0/((url_tmp.length()+10)*(title_tmp.length()+10));
                results.scoreDocs[i].score = (float) s;
                prMap.put(i, s);
            }

            List<Map.Entry<Integer, Double>> infoIds = new ArrayList<>(prMap.entrySet());

            //排序
            Collections.sort(infoIds, (Comparator<Map.Entry<Integer, Double>>) (o1, o2) -> {
                //return (o2.getValue() - o1.getValue());
                return -(o1.getValue()).compareTo(o2.getValue());
            });

            //infoIds.get(i)

            ScoreDoc[] hits = showList(results.scoreDocs, infoIds, page);

            if (hits != null) {
                highlightTitles = new String[hits.length];
                highlightURLs = new String[hits.length];
                highlightContents = new String[hits.length];
                for (int i = 0; i < hits.length && i < PAGE_RESULT; i++) {
                    Document doc = search.getDoc(hits[i].doc);
                    System.out.println("doc=" + hits[i].doc + " score="
                            + hits[i].score + " url= "
                            + doc.get("url")+ " title= "+doc.get("title"));
                    //titles[i] = doc.get("title");
                    highlightURLs[i] = doc.get("url");
                    String hcontent = doc.get("content");
                    String htitle = doc.get("title");
                    /*if (hurl != null) {
                        TokenStream tokenStream = search.analyzer.tokenStream("url", new StringReader(hurl));
                        try {
                            highlightURLs[i] = highlighter.getBestFragment(tokenStream, hurl);
                        } catch (InvalidTokenOffsetsException e) {
                            e.printStackTrace();
                        }
                    }*/
                    //highlightContents[i] = hcontent;

                    if(htitle.contains(".docx")){
                        htitle = "[DOCX] "+ htitle;
                    }else if(htitle.contains(".pdf")){
                        htitle = "[PDF] "+ htitle;
                    }

                    if(htitle.length() < 30){
                        highlightTitles[i] = htitle;
                    }else{

                        Pattern pp = Pattern.compile("[a-zA-Z]+");
                        Matcher mm = pp.matcher(htitle);

                        if (mm.find()) {
                            highlightTitles[i] = htitle;
                        } else {

                            highlightTitles[i] = htitle.substring(0, 30);
                            highlightTitles[i] = highlightTitles[i] + "...";
                        }
                    }


                    if (hcontent != null && hcontent.length() > 1 ) {
                        TokenStream tokenStream = new IKAnalyzer().tokenStream("content", new StringReader(hcontent));
                        try {
                            highlightContents[i] = highlighter.getBestFragment(tokenStream, hcontent);
                            if(highlightContents[i] == null){
                                highlightContents[i] = hcontent.length()>100?hcontent.substring(0,100):hcontent;
                            }
                        } catch (InvalidTokenOffsetsException e) {
                            e.printStackTrace();
                        }
                    }
                    else{
                        highlightContents[i] = "";
                    }

                    /*TokenStream title_tokenStream = new PaodingAnalyzer().tokenStream("title", new StringReader(htitle));
                    try {
                        highlightTitles[i] = highlighter.getBestFragment(tokenStream, htitle);
                        if(highlightTitles[i]== null || highlightTitles[i].length()<1){
                            highlightTitles[i]="";
                        }
                        *//*if(highlightContents[i] == null || highlightContents[i].length() < 10){
                            if(hcontent.length() > 80) {
                                highlightContents[i] = hcontent.substring(0,80);
                            }else if(hcontent.length() < 2){
                                highlightContents[i] = null;
                            }
                        }*//*
                    } catch (InvalidTokenOffsetsException e) {
                        e.printStackTrace();
                    }*/
                    //}
                    /*if (htitle != null) {
                        TokenStream tokenStream = search.analyzer.tokenStream("title", new StringReader(htitle));
                        try {
                            highlightTitles[i] = highlighter.getBestFragment(tokenStream, htitle);
                            if(highlightTitles[i] == null){
                                highlightTitles[i] = htitle;
                            }
                        } catch (InvalidTokenOffsetsException e) {
                            e.printStackTrace();
                        }
                    }*/
                }

            } else {
                System.out.println("page null");
            }
        }else{
            System.out.println("result null");
        }

        /*int seq=0;
        for(ScoreDoc doc : results.scoreDocs) {//获取查找的文档的属性数据
            seq++;
            int docID = doc.doc;
            Document document = search.searcher.doc(docID);
            //String str = "序号：" + seq + ",ID:" + document.get("id") + ",姓名：" + document.get("name") + "，性别：";

        }*/

        long t2 = System.currentTimeMillis(); // 排序前取得当前时间
        String[] recommendation = getRecommendation(queryString);

        request.setAttribute("totalNum", totalNum);
        request.setAttribute("currentQuery",queryString);
        request.setAttribute("currentPage", page);
        request.setAttribute("titles", highlightTitles);
        request.setAttribute("urls", highlightURLs);
        request.setAttribute("contents", highlightContents);
        request.setAttribute("times", t2-t1);
        request.setAttribute("recommendation", recommendation);
        //request.setAttribute("queryString", queryString);
        request.getRequestDispatcher("/CampusShow.jsp").forward(request,
                response);

    }

    public void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        this.doGet(request, response);
    }

    private String readAll(Reader rd) throws IOException {
        StringBuilder sb = new StringBuilder();
        int cp;
        while ((cp = rd.read()) != -1) {
            sb.append((char) cp);
        }
        return sb.toString();
    }

    private String[] getRecommendation(String query)
    {
        String url = query;
        String[] result = new String[10];
        try
        {
            url = URLEncoder.encode(url, "UTF-8");
            InputStream is = new URL("http://localhost:5000/recommend?query=" + url).openStream();
            BufferedReader rd = new BufferedReader(new InputStreamReader(is, Charset.forName("UTF-8")));
            String jsonText = readAll(rd);
            System.out.println(jsonText);
            JSONArray recommendArray = new JSONArray(jsonText);
            for (int i = 0; i < recommendArray.length(); i++)
            {
                result[i] = recommendArray.getString(i);
            }
        }
        catch (Exception e)
        {
            e.printStackTrace();
            return result;
        }
        return result;
    }

}
