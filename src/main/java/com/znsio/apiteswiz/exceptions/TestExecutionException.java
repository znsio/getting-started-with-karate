package com.znsio.apiteswiz.exceptions;

public class TestExecutionException extends RuntimeException {
    public TestExecutionException(String failureMessage) {
        super(failureMessage);
    }
}
