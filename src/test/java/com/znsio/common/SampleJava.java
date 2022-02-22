package com.znsio.common;

import org.apache.commons.lang3.RandomStringUtils;

public class SampleJava {
    public String generateRandomAlphaNumericString(int additionalLength) {
        String randomAlphanumeric = RandomStringUtils.randomAlphanumeric(additionalLength);
        System.out.println("Generated: " + randomAlphanumeric);
        return randomAlphanumeric;
    }
}
