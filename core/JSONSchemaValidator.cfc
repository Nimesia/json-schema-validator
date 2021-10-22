/**
 * JSONSchemaValidator class
 * @author Alessio De Padova <alessio.de.padova95@gmail.com>
 * @since 19/10/2021
 */

component accessors="true" {

    property name="validator";
    property name="errors" type="bean.Error[]";

    public JSONSchemaValidator function init(){

        var validator = createObject("java", "it.nimesia.JSONSchemaValidator", "./libs/").init();

        setValidator( validator );
        
        setErrors([]);

        return this;
        
    }

    public Array function validate( required String json, required String schemaPath)  {

        var schema;

        cffile( action="read", file=arguments.schemaPath, variable="schema" );   
      
        var errors = getValidator()
                        .getErrorDetails(arguments.json, schema);

        for (var error in errors) {

            var details = deserializeJSON( error['toJSON'] );
            traverseJSON( details = [details] );
         
        }

        return getErrors();

    }

    public Array function getAllErrors( required String json, required String schemaPath)  {

        cffile( action="read" file=arguments.schemaPath variable="schema" );   
      
        var errors =  getValidator()
                        .getAllErrors(arguments.json, schema);

        return errors;


    }

    public function addError(required String type, String message, String pointer, Struct details) {
        
        arrayAppend( getErrors(), createError(argumentCollection = arguments) );

    }

    public function isValidSchema(required string schema) {

       return getValidator()
                    .isWellformedJSONSchema(arguments.schema);
                    
    }

    public function isValidJSON(required string json){

        return getValidator()
                    .isWellformedJSON(arguments.json);

    }

    /*
        private methods
    */

    private void function traverseJSON(required Array details) {

        for (var detail in arguments.details) {

            if (arrayLen(detail['causingExceptions'])) {

                traverseJSON(detail['causingExceptions'] )

            } else {

                arrayAppend( getErrors(), extractErrors(detail));
            }
            
        }
        
    }
    
    private Struct function extractErrors(required Struct error) {

        var curError =  arguments.error;
        var details = getViolationDetails(curError);

       return createError( 
                    type    =   curError['keyword'],
                    message =   curError['message'], 
                    pointer =   getPointer( error = curError ),
                    details =   details
                )
 
    }

    private bean.Error function createError(required String type, String message, String pointer, Struct details={}) {

        var obj = new bean.Error();

        obj.setMessage( arguments.message );
        obj.setType( arguments.type );
        obj.setPointer( arguments.pointer );
        obj.setDetails( arguments.details );

        return obj;

    }

    private String function getPointer(required Struct error) {

        var message = 'required key';
        var pointer = arguments.error['pointerToViolation'];

        if ( left( arguments.error['message'], len(message) ) EQ message ) {
            
            pointer = REMatch( "(\[(.*?)\])", arguments.error['message'] )[1]
                        .replace( '[', '/')
                        .replace(']', '' );

        } 

        return pointer.Replace('##', '');
    }

    private Struct function getViolationDetails(required Struct error) {
        var message = arguments.error.message;

        var expected = '';
        var found = '';

        var stringList = listToArray( message, " ", false, true );

        switch (arguments.error.keyword) {
            case 'minLength':
            case 'type':
            case 'maxLength':
                expected = stringList[3]
                                .replace(',', '');
                found = stringList[5];
                break;

            case 'multipleOf':
                expected = stringList[1];
                found = stringList[7];
                break;

            case 'format': 
                expected = 'Email format';
                found = stringList[1]
                            .replace('[', '')
                            .replace(']', '');
                break;

            default:
                expected = '';
                found = '';
                break;
            
        }

        return { "expected": expected, "found": found };
    }
   
}
