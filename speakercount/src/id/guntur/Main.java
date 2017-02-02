package id.guntur;

import edu.rutgers.winlab.crowdpp.audio.MFCC;
import edu.rutgers.winlab.crowdpp.audio.SpeakerCount;
import edu.rutgers.winlab.crowdpp.audio.Yin;
import edu.rutgers.winlab.crowdpp.util.FileProcess;

import java.io.IOException;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;

public class Main {

    private static int speaker_count;
    private static double percentage = -1;

    public static void main(String[] args) {
        // write your code here
//        System.out.println("Working Directory = " +
//                System.getProperty("user.dir"));

        // Get the wav file
        String filename = null;
        if(args.length > 0) {
            filename = args[0];
        } else {
            filename = "audio/1.wav";
//            System.out.println("No arguments received, using default audio filename...");
        }

        // extract the feature
        try {
            Yin.writeFile(filename);
//            System.out.println("SpeakerCountTask: Finish YIN");
            MFCC.writeFile(filename);
//            System.out.println("SpeakerCountTask: Finish MFCC");
        } catch (Exception e) {
            e.printStackTrace();
        }
        String[] tst_files = new String[2];
        tst_files[0] = filename + ".jstk.mfcc.txt";
        tst_files[1] = filename + ".YIN.pitch.txt";

        // unsupervised speaker counting without calibration data
        try {
            speaker_count = SpeakerCount.unsupervised(tst_files);
            percentage = -1;
        } catch (IOException e) {
            e.printStackTrace();
        }

        // log the test record
        // Constants.log is set to be true default
        if (true) {
            String log = filename + "\tspeaker count:\t" + Integer.toString(speaker_count) + "\tspeach percentage:\t"
                    + Double.toString(percentage) + "\n";

            File sdFile = new File("log.txt");
            FileOutputStream fos;
            try {
                fos = new FileOutputStream(sdFile, true);
                fos.write(log.getBytes());
                fos.close();
            } catch (FileNotFoundException e) {
                e.printStackTrace();
            } catch (IOException e) {
                e.printStackTrace();
            }
        }

        // remove the file
        FileProcess.deleteFile(tst_files[0]);   // mfcc
        FileProcess.deleteFile(tst_files[1]);   // yin

//        System.out.println("Speaker count: " + speaker_count);
        System.out.println(speaker_count + " speaker(s)");
    }
}
