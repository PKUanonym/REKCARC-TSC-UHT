

import org.apache.lucene.index.IndexReader;
import org.apache.lucene.index.IndexWriterConfig;
import org.apache.lucene.search.spell.LuceneDictionary;
import org.apache.lucene.search.spell.PlainTextDictionary;
import org.apache.lucene.search.spell.SpellChecker;
import org.apache.lucene.store.Directory;
import org.apache.lucene.store.FSDirectory;
import org.apache.lucene.util.Version;

import java.io.File;
import java.io.IOException;
public class DidYouMeanIndexer {
    private SpellChecker spellChecker;
    public void createSpellIndex(String spellIndexPath, String idcFilePath)
            throws IOException {
        Directory spellIndexDir = FSDirectory.open(new File(spellIndexPath));
        SpellChecker spellChecker = new SpellChecker(spellIndexDir);
        IndexWriterConfig config = new IndexWriterConfig(Version.LUCENE_35, null);
        spellChecker.indexDictionary(new PlainTextDictionary(new File(idcFilePath)), config, false);
        // close
        spellIndexDir.close();
        spellChecker.close();
    }
    public void createSpellIndex(String oriIndexPath, String fieldName,
                                 String spellIndexPath) throws IOException {
        IndexReader oriIndex = IndexReader.open(FSDirectory.open(new File(oriIndexPath)));
        LuceneDictionary dict = new LuceneDictionary(oriIndex, fieldName);
        Directory spellIndexDir = FSDirectory.open(new File(spellIndexPath));
        spellChecker = new SpellChecker(spellIndexDir);
        IndexWriterConfig config = new IndexWriterConfig(Version.LUCENE_35, null);
        spellChecker.indexDictionary(dict, config, true);
    }
    public static void main(String[] args){
        DidYouMeanIndexer mySpellIndexer = new DidYouMeanIndexer();
        try {
            mySpellIndexer.createSpellIndex("spellIndex/", "input/spell.txt");
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}

