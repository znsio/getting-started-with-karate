package com.znsio.exceptions;

public class TestDataException extends RuntimeException {
    public TestDataException(String failureMessage) {
        super(failureMessage);
    }
    public TestDataException(String failureMessage, Exception e) {
        super(failureMessage, e);
    }
}
