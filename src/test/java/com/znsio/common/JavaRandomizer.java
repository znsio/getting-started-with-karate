package com.znsio.common;

import org.apache.commons.lang3.RandomStringUtils;
import org.apache.commons.lang3.RandomUtils;

import java.util.HashMap;

public class JavaRandomizer {
    public class Demo {
        HashMap<Integer, String> map;
        public Demo() {
            map = new HashMap<>();
        }

        public void set(int length, String str) {
            map.put(length, str);
        }

        public HashMap get() {
            System.out.println(map);
            return map;
        }
    }

    public String generateRandomAlphaNumericString(int additionalLength) {
        String randomAlphanumeric = RandomStringUtils.randomAlphanumeric(additionalLength);
        System.out.println("Generated: " + randomAlphanumeric);
        return randomAlphanumeric;
    }

    public int generateRandomNumberInRange(int min, int max) {
        int randomNumber = RandomUtils.nextInt(min, max);
        System.out.println("Generated: " + randomNumber);
        return randomNumber;
    }

    public HashMap getRandomStringFromJava(int length) {
//        return generateRandomAlphaNumericString(length);
        Demo demo = new Demo();
        demo.set(length, generateRandomAlphaNumericString(length));
        System.out.println("Received from Demo: " + length + ": " + demo.get());
        return demo.get();
    }
}
