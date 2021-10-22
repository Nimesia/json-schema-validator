package it.nimesia;

import java.io.IOException;
import java.nio.charset.Charset;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.HashMap;

public class Main {

    public static void main(String[] args) throws IOException {

        String schema   = readFile("src/main/resources/schemas/loginSchema.json", StandardCharsets.US_ASCII );
        String json     = readFile("src/main/resources/json/login.json", StandardCharsets.US_ASCII );

        JSONSchemaValidator validator = new JSONSchemaValidator();

        ArrayList<HashMap<String,String>> errors = validator.getErrorDetails(json, schema);

        System.out.println(errors);

    }

    private static String readFile(String path, Charset encoding)
            throws IOException
    {
        byte[] encoded = Files.readAllBytes(Paths.get(path));
        return new String(encoded, encoding);
    }

}
