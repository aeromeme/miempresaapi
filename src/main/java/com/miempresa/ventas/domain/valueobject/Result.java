package com.miempresa.ventas.domain.valueobject;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Optional;
import java.util.function.Function;
import java.util.function.Consumer;

/**
 * Result Pattern implementation for domain operations.
 * Represents the result of an operation that can either succeed or fail.
 */
public class Result<T> {
    private final boolean success;
    private final T value;
    private final List<String> errors;
    
    private Result(boolean success, T value, List<String> errors) {
        this.success = success;
        this.value = value;
        this.errors = errors != null ? new ArrayList<>(errors) : new ArrayList<>();
    }
    
    // Factory methods for success
    public static <T> Result<T> success(T value) {
        return new Result<>(true, value, null);
    }
    
    public static Result<Void> success() {
        return new Result<>(true, null, null);
    }
    
    // Factory methods for failure
    public static <T> Result<T> failure(String error) {
        return new Result<>(false, null, Arrays.asList(error));
    }
    
    public static <T> Result<T> failure(List<String> errors) {
        return new Result<>(false, null, errors);
    }
    
    public static <T> Result<T> failure(String... errors) {
        return new Result<>(false, null, Arrays.asList(errors));
    }
    
    // Monadic operations
    public <U> Result<U> flatMap(Function<T, Result<U>> mapper) {
        if (!success) {
            return Result.failure(errors);
        }
        return mapper.apply(value);
    }
    
    public <U> Result<U> map(Function<T, U> mapper) {
        if (!success) {
            return Result.failure(errors);
        }
        return Result.success(mapper.apply(value));
    }
    
    public Result<T> filter(Function<T, Boolean> predicate, String errorMessage) {
        if (!success) {
            return this;
        }
        if (!predicate.apply(value)) {
            return Result.failure(errorMessage);
        }
        return this;
    }
    
    // Combine multiple results
    public static <T1, T2, R> Result<R> combine(
            Result<T1> result1, 
            Result<T2> result2, 
            Function<T1, Function<T2, R>> combiner) {
        
        List<String> allErrors = new ArrayList<>();
        
        if (!result1.isSuccess()) {
            allErrors.addAll(result1.getErrors());
        }
        if (!result2.isSuccess()) {
            allErrors.addAll(result2.getErrors());
        }
        
        if (!allErrors.isEmpty()) {
            return Result.failure(allErrors);
        }
        
        return Result.success(combiner.apply(result1.getValue()).apply(result2.getValue()));
    }
    
    // Side effects
    public Result<T> onSuccess(Consumer<T> action) {
        if (success && value != null) {
            action.accept(value);
        }
        return this;
    }
    
    public Result<T> onFailure(Consumer<List<String>> action) {
        if (!success) {
            action.accept(errors);
        }
        return this;
    }
    
    // Getters
    public boolean isSuccess() {
        return success;
    }
    
    public boolean isFailure() {
        return !success;
    }
    
    public T getValue() {
        if (!success) {
            throw new IllegalStateException("Cannot get value from failed result");
        }
        return value;
    }
    
    public Optional<T> getValueOptional() {
        return success ? Optional.ofNullable(value) : Optional.empty();
    }
    
    public List<String> getErrors() {
        return new ArrayList<>(errors);
    }
    
    public String getFirstError() {
        return errors.isEmpty() ? "" : errors.get(0);
    }
    
    public String getAllErrorsAsString() {
        return String.join("; ", errors);
    }
    
    // Match pattern
    public <U> U match(Function<T, U> onSuccess, Function<List<String>, U> onFailure) {
        return success ? onSuccess.apply(value) : onFailure.apply(errors);
    }
    
    @Override
    public String toString() {
        if (success) {
            return "Success(" + value + ")";
        } else {
            return "Failure(" + String.join(", ", errors) + ")";
        }
    }
}