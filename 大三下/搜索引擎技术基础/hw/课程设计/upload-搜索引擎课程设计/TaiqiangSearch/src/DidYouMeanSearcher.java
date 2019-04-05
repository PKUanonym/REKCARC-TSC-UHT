
import org.apache.lucene.search.spell.LuceneDictionary;
import org.apache.lucene.search.spell.SpellChecker;
import org.apache.lucene.store.Directory;
import org.apache.lucene.store.FSDirectory;

import java.io.File;
import java.io.IOException;
import java.util.Iterator;

public class DidYouMeanSearcher {
    SpellChecker spellChecker = null;
    LuceneDictionary dict = null;
    public DidYouMeanSearcher(String spellCheckIndexPath, String oriIndexPath,
                              String fieldName) {
        Directory directory;
        try {
            directory = FSDirectory.open(new File(spellCheckIndexPath));
            spellChecker = new SpellChecker(directory);
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
    public void setAccuracy(double v) {
        spellChecker.setAccuracy((float)v);
    }
    public String[] search(String queryString, int suggestionsNumber) {
        String[] suggestions = null;
        try {
            suggestions = spellChecker.suggestSimilar(queryString, suggestionsNumber);
        } catch (IOException e) {
            e.printStackTrace();
        }
        return suggestions;
    }
    private boolean exist(String queryString) {
        Iterator<String> ite = dict.getWordsIterator();
        while (ite.hasNext()) {
            if (ite.next().equals(queryString))
                return true;
        }
        return false;
    }
    public static void main(String[] args){
        DidYouMeanSearcher meanSearcher = new DidYouMeanSearcher("spellIndex/", null, null);
        for (int i = 0; i < 10; i++)
        {
            System.out.println(meanSearcher.search("studnt", 10)[i]);
        }
    }
}
