import java.io.IOException;
import java.util.StringTokenizer;

// Requisite apache files
import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.fs.Path;
import org.apache.hadoop.io.IntWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Job;
import org.apache.hadoop.mapreduce.Mapper;
import org.apache.hadoop.mapreduce.Reducer;
import org.apache.hadoop.mapreduce.lib.input.FileInputFormat;
import org.apache.hadoop.mapreduce.lib.output.FileOutputFormat;

import java.util.Iterator;
import java.util.ArrayList;
import java.util.List;
import java.util.Arrays;
// This code comes from a tutorial from the official apache hadoop site:
// https://hadoop.apache.org/docs/stable/hadoop-mapreduce-client/hadoop-mapreduce-client-core/MapReduceTutorial.html
public class BeaverMart {

  public static class TokenizerMapper
       extends Mapper<Object, Text, Text, IntWritable>{

    private final static IntWritable one = new IntWritable(1);
    private Text word = new Text();

    // Maps a key to a text value,
    public void map(Object key, Text value, Context context
                    ) throws IOException, InterruptedException {

	// Split input into individual items
	List<String> tokens = new ArrayList<String>(Arrays.asList(value.toString().split(",")));

	// Store pairs that exist already
	List<String> duplicates = new ArrayList<String>();

	for(Iterator<String> i = tokens.iterator(); i.hasNext(); ) {
 		String item = i.next();
		List<String> others = tokens;
		for(Iterator<String> j = others.iterator(); j.hasNext(); ) {
			String item2 = j.next();
			if(item != item2 && !duplicates.contains(item2 + "," + item)) {
				String val = item + "," + item2;
				context.write(new Text(val), one);
				duplicates.add(val);
			}
		}

		//context.write(new Text(item), one);
	}
    }
  }

  // Combines and reduces the output of map
  public static class IntSumReducer
       extends Reducer<Text,IntWritable,Text,IntWritable> {
    private IntWritable result = new IntWritable();

    // Groups and Reduces the output of map
    public void reduce(Text key, Iterable<IntWritable> values,
                       Context context
                       ) throws IOException, InterruptedException {
      int sum = 0;
      for (IntWritable val : values) {
        sum += val.get();
      }
	
	result.set(sum);
      // For each key (word) write a value (number of times the word occurred)
      context.write(key, result);
    }
  }

  // Main function
  public static void main(String[] args) throws Exception {
    // Get a new hadoop configuration
    Configuration conf = new Configuration();

    // Set the job name as word count
    Job job = Job.getInstance(conf, "BeaverMart");
    job.setJarByClass(BeaverMart.class);
    job.setMapperClass(TokenizerMapper.class);
    job.setCombinerClass(IntSumReducer.class);
    job.setReducerClass(IntSumReducer.class);

    // Set the type of key value (text)
    job.setOutputKeyClass(Text.class);
    // Set the type of value (int)
    job.setOutputValueClass(IntWritable.class);

    //job.getCounters().findCounter(TaskCounter.MAP_INPUT_RECORDS).getValue();

    // Input file
    FileInputFormat.addInputPath(job, new Path(args[0]));

    // Output File
    FileOutputFormat.setOutputPath(job, new Path(args[1]));

    // if the job terminates, return true/false
    System.exit(job.waitForCompletion(true) ? 0 : 1);

    long records = job.getCounters().findCounter("org.apache.hadoop.mapred.Task$Counter", 
           "REDUCE_OUTPUT_RECORDS").getValue();

    System.out.print("Unique Records:" + records);

    


  }
}
