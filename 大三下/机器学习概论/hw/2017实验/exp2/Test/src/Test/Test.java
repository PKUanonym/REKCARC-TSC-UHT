package Test;
import java.io.File;
import weka.classifiers.Classifier;
import weka.classifiers.bayes.NaiveBayes;
import weka.classifiers.trees.J48;
import weka.core.Instances;
import weka.core.converters.ArffLoader;
import weka.filters.Filter;
import weka.filters.unsupervised.attribute.Remove;


/**
 * Created by steven on 2017/5/7.
 */
public class Test {
    public static void main(String[] args) {
        System.out.println("hhh");
        Classifier cModel = (Classifier) new NaiveBayes();

    }
}
