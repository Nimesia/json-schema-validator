package it.nimesia;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import org.everit.json.schema.Schema;
import org.everit.json.schema.SchemaException;
import org.everit.json.schema.loader.SchemaLoader;
import org.everit.json.schema.ValidationException;

import org.json.JSONException;
import org.json.JSONObject;
import org.json.JSONTokener;

public class JSONSchemaValidator {

    /**
     * Get all validation errors in a flat list of strings.
     *
     * @param json JSON document to validate
     * @param schema JSON schema
     * @return list of validation errors
     */
    public static ArrayList<String> getAllErrors(String json, String schema) {
        ArrayList<String> errors = new ArrayList<>();
        try {
            JSONObject rawSchema = new JSONObject(new JSONTokener(schema));
            Schema loadedSchema = SchemaLoader.load(rawSchema);
            loadedSchema.validate(new JSONObject(json));
        } catch (ValidationException ex) {
            errors.addAll(ex.getAllMessages());
        }
        return errors;
    }

    /**
     * Get the top-level validation errors in a list of hash maps.
     * Nested errors are embedded in the toJSON element of the hash map.
     * Keys correspond to the methods available in ValidationException:
     * getMessage, getErrorMessage, getKeyword, getPointerToViolation,
     * getSchemaLocation, getViolatedSchema and toJSON.
     *
     * @param json JSON document to validate
     * @param schema JSON schema
     * @return list of hashmaps with top-level validation errors
     */
    public static ArrayList<HashMap<String,String>> getErrorDetails(String json, String schema) {
        ArrayList<HashMap<String,String>> errors = new ArrayList<>();
        try {
            JSONObject rawSchema = new JSONObject(new JSONTokener(schema));
            Schema loadedSchema = SchemaLoader.load(rawSchema);
            loadedSchema.validate(new JSONObject(json));
        } catch (ValidationException ex) {
            List<ValidationException> excepts = new ArrayList<>();
            if ( ex.getCausingExceptions().toArray().length == 0) {
                excepts.add(ex);
            } else {
                excepts = ex.getCausingExceptions();
            }
            for (ValidationException vex : excepts) {
                HashMap<String,String> h = new HashMap<>();
                h.put("getMessage", vex.getMessage());
                h.put("getErrorMessage", vex.getErrorMessage());
                h.put("getKeyword", vex.getKeyword());
                h.put("getPointerToViolation", vex.getPointerToViolation());
                h.put("getSchemaLocation", vex.getSchemaLocation());
                h.put("getViolatedSchema", vex.getViolatedSchema().toString());
                h.put("toJSON", vex.toJSON().toString());
                errors.add(h);
            }
        }
        return errors;
    }

    /**
     * Check whether the given JSON is well formed.
     *
     * @param json JSON document to check
     * @return true if json is a well formed JSON, false otherwise
     */
    public static Boolean isWellformedJSON(String json) {
        if (json == null) {
            return Boolean.FALSE;
        }
        try {
            JSONObject obj = new JSONObject(json);
        } catch (JSONException ex) {
            return Boolean.FALSE;
        }
        return Boolean.TRUE;
    }

    /**
     * Check whether the given JSON schema is well formed.
     *
     * @param schema JSON schema document to check
     * @return true if schema is a well formed JSON schema, false otherwise
     */
    public static Boolean isWellformedJSONSchema(String schema) {
        if (!isWellformedJSON(schema)) {
            return Boolean.FALSE;
        }
        if (schema == null) {
            return Boolean.FALSE;
        }
        try {
            JSONObject rawSchema = new JSONObject(new JSONTokener(schema));
            Schema loadedSchema = SchemaLoader.load(rawSchema);
        } catch (SchemaException ex) {
            return Boolean.FALSE;
        }
        return Boolean.TRUE;
    }

}
