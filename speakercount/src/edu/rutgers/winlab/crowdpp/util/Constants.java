/*
 * Copyright (c) 2012-2014 Chenren Xu, Sugang Li
 * Acknowledgments: Yanyong Zhang, Yih-Farn (Robin) Chen, Emiliano Miluzzo, Jun Li
 * Contact: lendlice@winlab.rutgers.edu
 *
 * This file is part of the Crowdpp.
 *
 * Crowdpp is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * Crowdpp is distributed in the hope that it will be useful, but 
 * WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. 
 * See the GNU General Public License for more details.
 * 
 * You should have received a copy of the GNU General Public License
 * along with the Crowdpp. If not, see <http://www.gnu.org/licenses/>.
 * 
 */

package edu.rutgers.winlab.crowdpp.util;

import java.io.File;
import java.util.Locale;

/**
 * The Constants class
 *
 * @author Chenren Xu
 */
public class Constants {

    /**
     * The constants for uploading to the Amazon S3 cloud storage
     */
    // Please register AWS and get your own ACCESS_KEY_ID and SECRET_KEY
    public static String ACCESS_KEY_ID = "Your ACCESS_KEY_ID";
    public static String SECRET_KEY = "Your SECRET_KEY";

    public static String dbBucket = (ACCESS_KEY_ID + ".crowdppDatabase").toLowerCase(Locale.US);
    public static String calBucket = (ACCESS_KEY_ID + ".crowdppCalibration").toLowerCase(Locale.US);

    /**
     * The phone identifier
     */
    public static String PHONE_ID;
    public static String dbName;

    /**
     * The file paths for logging
     */
    public static boolean log = true;
    public static String crowdppPath = FileProcess.getSdPath() + "/Crowdpp";
    public static String testPath = crowdppPath + "/test";
    public static String servicePath = crowdppPath + "/service";

    /**
     * The flags for raw data
     */
    public static boolean test_raw_keep = true;
    public static boolean test_feature_keep = true;
    public static boolean service_raw_keep = false;
    public static boolean service_feature_keep = false;

    /**
     * The parameters for speaker counting
     */
<<<<<<< HEAD
    public static double mfcc_dist_same_semi = 15.6;
    public static double mfcc_dist_diff_semi = 21.6;

    public static double mfcc_dist_same_un = 15.6;
    public static double mfcc_dist_diff_un = 21.6;
=======
    public static double mfcc_dist_same_semi;
    public static double mfcc_dist_diff_semi;

    public static double mfcc_dist_same_un;
    public static double mfcc_dist_diff_un;
>>>>>>> deb4eee798046ff3050e2fdc49aff179daa28237

    public static double pitch_male_upper = 160;
    public static double pitch_female_lower = 190;

    public static double pitch_rate_lower = 0.05;
    public static double pitch_mu_lower = 50;
    public static double pitch_mu_upper = 450;
    public static double pitch_sigma_upper = 100;

    public static double seg_duration_sec = 3;
    public static double cal_duration_sec_lower = 45;

    /**
     * The constructor initialize the parameters from the context
     */
    public Constants() {
        // we are using Apple macbook pro as the wav file is recorded by a macbook
        PHONE_ID = "AppleMacBookPro";

        dbName = PHONE_ID + ".db";

        // the value are derived from other device
        // located in MainActivity.java line 152-156
        // motoX
//        if (phone_type.equals("motorola_XT1058")) {
//            editor.putString("mfcc_dist_same_semi", "13");
//            editor.putString("mfcc_dist_diff_semi", "18");
//            editor.putString("mfcc_dist_same_un", "13");
//            editor.putString("mfcc_dist_diff_un", "18");
//        }
//        // nexus 4
//        else if (phone_type.equals("google_Nexus 4")) {
//            editor.putString("mfcc_dist_same_semi", "17");
//            editor.putString("mfcc_dist_diff_semi", "22");
//            editor.putString("mfcc_dist_same_un", "17");
//            editor.putString("mfcc_dist_diff_un", "22");
//        }
//        // s2
//        else if (phone_type.equals("samsung_SAMSUNG-SGH-I727")) {
//            editor.putString("mfcc_dist_same_semi", "18");
//            editor.putString("mfcc_dist_diff_semi", "25");
//            editor.putString("mfcc_dist_same_un", "18");
//            editor.putString("mfcc_dist_diff_un", "25");
//        }
//        // s3
//        else if (phone_type.equals("samsung_SAMSUNG-SGH-I747")) {
//            editor.putString("mfcc_dist_same_semi", "16");
//            editor.putString("mfcc_dist_diff_semi", "21");
//            editor.putString("mfcc_dist_same_un", "16");
//            editor.putString("mfcc_dist_diff_un", "21");
//        }
//        // s4
//        else if (phone_type.equals("samsung_SAMSUNG-SGH-I337")) {
//            editor.putString("mfcc_dist_same_semi", "14");
//            editor.putString("mfcc_dist_diff_semi", "24");
//            editor.putString("mfcc_dist_same_un", "14");
//            editor.putString("mfcc_dist_diff_un", "24");
//        }
//        // other devices
//        else {
//            editor.putString("mfcc_dist_same_semi", "15.6");
//            editor.putString("mfcc_dist_diff_semi", "21.6");
//            editor.putString("mfcc_dist_same_un", "15.6");
//            editor.putString("mfcc_dist_diff_un", "21.6");
//            Toast.makeText(this, "Your device is not recognized and the result might not be accurate...", Toast.LENGTH_SHORT).show();
//        }
<<<<<<< HEAD
=======
        mfcc_dist_same_semi = 14;
        mfcc_dist_diff_semi = 24;
        mfcc_dist_same_un = 14;
        mfcc_dist_diff_un = 24;
>>>>>>> deb4eee798046ff3050e2fdc49aff179daa28237
    }

    /**
     * Flag for calibration done or not
     */
    public static boolean calibration() {
        File mfccFile = new File(crowdppPath + "/" + Constants.PHONE_ID + ".wav" + ".jstk.mfcc.txt");
        File pitchFile = new File(crowdppPath + "/" + Constants.PHONE_ID + ".wav" + ".YIN.pitch.txt");
        if (mfccFile.exists() && pitchFile.exists())
            return true;
        else
            return false;
    }

    /**
     * The text for UI
     */
    public static String hello_msg = "Crowd++ is a mobile application that learns your social life through your conversation - with strong privacy protection. "
            + "It records how many people you talk to and how engaged your are in your conversations without analyzing its verbal content."
            + "To enable Crowd++ to accurately distinguish you from other speakers, please go through the calibration process first and then enable the service in the \"Home\" tab. \n\n"
            + "You can check the results in \"Social Diary\" tab and adjust your preferences in the \"Settings\" tab. \n\n"
            + "Privacy provisions: please note that your conversation data will be deleted and will NOT be uploaded anywhere. "
            + "We only collect your social log data (speaker count, your speech percentage and location data) and will keep it anonymous and confidential. \n\n"
            + "If you have any other questions, please refer to \"Help\" in menu.";

    public static String FAQ = "Q: What is calibration?\n"
            + "A: Crowd++ takes your sample voice data to distinguish your voice from others' so as to estimate number of speakers as well as your speech percentage in a conversation.\n\n"
            + "Q: How will you dispose my conversation data?\n"
            + "A: We will delete your raw conversation data as soon as we estimate the number of speakers.\n\n"
            + "Q: What does \"Period\", \"Interval\" and \"Duration\" mean in the \"Setting\" tab?\n"
            + "A: For example, if you set \"9 to 10\" for \"Period\", \"15 Min\" for \"Interval\", \"5 Min\" for \"Duration\", Crowd++ service will run at 9:00-9:05, 9:15-9:20, 9:30-9:35, 9:45-9:50.\n\n"
            + "Q: What type of data and where it will be uploaded?\n"
            + "A: For each conversation, we collect the start and ending point, estimated speak count, your speech percentage and your location. This data will be uploaded to Amazon S3 bucket rent by the project developers at Rutgers University.\n\n"
            + "Q: Where can I find more information about Crowd++?\n"
            + "A: You can either check our project page or contact us in the \"Setting\" tab.";

    public static String cal_dialog = "Please follow the instructions below: \n\n"
            + "1. Move to a quiet room and hold the phone away from your face.\n\n"
            + "2. After you press \"OK\", you will see a text.\n\n"
            + "3. Read the text at your normal speed and press the \"Calibration\" button when you finish. You are expected to read for 1 minute.\n\n"
            + "4. You can press \"OK\" to start now.\n";

    public static String cal_text = "The most direct form of social interaction occurs through the spoken language and conversations.	"
            + "Given its importance, for decades scientists have proposed diverse methodologies to analyze the audio "
            + "recorded during people��s conversations	to distill the various attributes that characterize this "
            + "particular social interaction. In addition to the content of a conversation,"
            + "several types of contextual clues have also received attention including speaker identification, "
            + "conversation turn-taking, and characterization of a social setting. We, however, note that one of the most "
            + "important contextual attributes of a conversation, namely, speaker count, has been largely overlooked. "
            + "Speaker count specifies the number of people that participate in a conversation, which is one of the primary "
            + "metrics to evaluate a social setting: how crowded is a restaurant, how interactive	is a lecture, "
            + "or how socially active is a person. In this project, we aim to accurately extract this attribute from "
            + "recorded audio data directly on smartphones,	without any supervision, and in different use cases.";

}
