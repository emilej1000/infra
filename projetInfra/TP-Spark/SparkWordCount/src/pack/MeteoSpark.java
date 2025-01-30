package pack;


import org.apache.spark.SparkConf;
import org.apache.spark.api.java.JavaPairRDD;
import org.apache.spark.api.java.JavaRDD;
import org.apache.spark.api.java.JavaSparkContext;
import org.apache.spark.api.java.function.PairFunction;

import scala.Tuple2;

public class MeteoSpark {

    public static void main(String[] args) { 
	    String filePath = "../spark-subject/meteosample.txt"; 
	    String outputFile = "output"; 

	    SparkConf conf = new SparkConf().setAppName("Meteo"); 
	    JavaSparkContext sc = new JavaSparkContext(conf); 
	    
	    long t1 = System.currentTimeMillis(); 

	    JavaRDD<String> lines = sc.textFile(filePath);

        // Mapper pour extraire l'année et la température
        JavaPairRDD<String, Float> yearTemperature = lines.mapToPair((PairFunction<String, String, Float>) line -> {
            String[] parts = line.split(":");
            String year = parts[2].trim(); // L'année
            Float temperature = Float.parseFloat(parts[3].trim()); // La température
            return new Tuple2<>(year, temperature);
        });

        // Réduire pour obtenir la température maximale par année
        JavaPairRDD<String, Float> maxTemperatureByYear = yearTemperature.reduceByKey(Math::max);


        // Écrire les résultats dans un fichier
        maxTemperatureByYear.saveAsTextFile(outputFile);

        


	    
	    
	    long t2 = System.currentTimeMillis(); 
	    
	    System.out.println("======================"); 
	    System.out.println("time in ms :"+(t2-t1)); 
	    System.out.println("======================"); 

        // Arrêter le contexte Spark
        sc.close();

	} 
    
}
