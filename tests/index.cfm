<h1>Tests JSONSchemaValidator</h1>

<cffile action="read" file="#ExpandPath('./tests.json')#" variable="result">

<cfset tests = DeserializeJSON( result )>

<cfset count = 1>
<cfloop index="test" array="#tests#">

    <cfset fileSchema =  ExpandPath( "schema/#test.schema#" )>
    <cfset json = SerializeJSON( test.data )>
    <cfset validator = new core.JSONSchemaValidator()>

    <cffile file="#fileSchema#" action="read" variable="schema">
    
    <cfset errors = validator.validate( json, fileSchema )>

    <cfset validateErrors = ArrayLen( errors )>
    <cfset allErrors = ArrayLen( validator.getAllErrors( json, fileSchema ) )>
    
    <cfset matching = validateErrors EQ allErrors>
    <cfset passed = test.errors EQ validateErrors>

    <cfoutput>

        <h2>Test #count# (#test.schema#)</h2>

        DATA: <textarea style="width:100%;height:50px">#json#</textarea>
        <br>
        SCHEMA: <textarea style="width:100%;height:150px">#schema#</textarea>
        <br>
        Expected errors: #test.errors#<br>
        errorDetails: #validateErrors#, allErrors: #allErrors#, <b style="color: #(matching ? 'green' : 'red')#">matching: #matching# </b>, <b style="color: #(matching ? 'green' : 'red')#">passed: #passed#</b><br>
        <br>
        <hr style="border-bottom: 1px Black solid;">
        <br>

    </cfoutput>
    
    <cfset count++>

</cfloop>
