import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.lucene.document.Document;
import org.apache.lucene.search.ScoreDoc;
import org.apache.lucene.search.TopDocs;

import java.util.*;

import java.math.*;
import java.net.*;
import java.io.*;


public class ImageServer extends HttpServlet{
	public static final int PAGE_RESULT=10;
	public static final String indexDir="forIndex";
	public static final String picDir="";
	private ImageSearcher search=null;
	public ImageServer(){
		super();
		System.out.println("haha");
		search=new ImageSearcher(new String(indexDir+"/index"));
		search.loadGlobals(new String(indexDir+"/global.txt"));
	}
	
	public ScoreDoc[] showList(ScoreDoc[] results,int page){
		if(results==null || results.length<(page-1)*PAGE_RESULT){
			return null;
		}
		int start=Math.max((page-1)*PAGE_RESULT, 0);
		int docnum=Math.min(results.length-start,PAGE_RESULT);
		ScoreDoc[] ret=new ScoreDoc[docnum];
		for(int i=0;i<docnum;i++){
			ret[i]=results[start+i];
		}
		return ret;
	}
	
	public void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		response.setContentType("text/html;charset=utf-8");
		request.setCharacterEncoding("utf-8");
		String queryString=request.getParameter("query");
		String pageString=request.getParameter("page");
		int page=1;
		if(pageString!=null){
			page=Integer.parseInt(pageString);
		}
		if(queryString==null){
			System.out.println("null query");
			//request.getRequestDispatcher("/Image.jsp").forward(request, response);
		}else{
			System.out.println(queryString);
			System.out.println(URLDecoder.decode(queryString,"utf-8"));
			System.out.println(URLDecoder.decode(queryString,"gb2312"));
			String[] tags=null;
			String[] paths=null;
			TopDocs results=search.searchQuery(queryString, "abstract", "title", 100);
			if (results != null) {
				ScoreDoc[] hits = showList(results.scoreDocs, page);
				if (hits != null) {
					tags = new String[hits.length];
					paths = new String[hits.length];
					for (int i = 0; i < hits.length && i < PAGE_RESULT; i++) {
						Document doc = search.getDoc(hits[i].doc);
						System.out.println("doc=" + hits[i].doc + " score="
								+ hits[i].score + " picPath= "
								+ doc.get("picPath")+ " tag= "+doc.get("abstract") + " title= " + doc.get("title"));
						tags[i] = doc.get("abstract");
						paths[i] = picDir + doc.get("picPath");
					}

				} else {
					System.out.println("page null");
				}
			}else{
				System.out.println("result null");
			}
			request.setAttribute("currentQuery",queryString);
			request.setAttribute("currentPage", page);
			request.setAttribute("imgTags", tags);
			request.setAttribute("imgPaths", paths);
			request.getRequestDispatcher("/imageshow.jsp").forward(request,
					response);
		}
	}

	public void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		this.doGet(request, response);
	}
}
