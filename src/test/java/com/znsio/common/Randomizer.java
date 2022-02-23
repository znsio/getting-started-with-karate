package com.znsio.common;

import org.apache.commons.lang3.RandomStringUtils;
import org.apache.commons.lang3.RandomUtils;

public class Randomizer {
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
}
