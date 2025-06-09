package com.util;

public class PasswordHashingException extends RuntimeException {

	private static final long serialVersionUID = -5855846713335298345L;

	public PasswordHashingException(String message) {
        super(message);
    }

    public PasswordHashingException(String message, Throwable cause) {
        super(message, cause);
    }
}