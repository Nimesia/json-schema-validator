<!-- PROJECT LOGO -->
<br />
<div align="center">

  <h3 align="center">JsonSchemaValidator</h3>

  <p align="center">
   JSON Schema Validator for Lucee
  </p>
</div>



<!-- TABLE OF CONTENTS -->
<details>
  <summary>Table of Contents</summary>
  <ol>
    <li>
      <a href="#about-the-project">About The Project</a>
    </li>
    <li><a href="#usage">Usage</a></li>
  </ol>
</details>



<!-- ABOUT THE PROJECT -->
## About The Project

Validating json data could be a real pain without the right tools. With this validator you can check whether a json is compliant with your schema and save yourself lots of if statements and useless code. 


<!-- USAGE EXAMPLES -->
## Usage

The main class is JSONSchemaValidator.cfc, inside the core folder. 

The followings are the public methods you can use:


* validate
  The function validate will return an array of structures containing infos, messages, types and details of the errors.

  ```sh
  validate(required String json, required String schemaPath)
  ```
  
* getAllErrors
  getAllErrors will return errors as a flat array

  ```sh
  getAllErrors(required String json, required String schemaPath)
  ```
   
* addError
 addError lets you add custom errors 

  ```sh
  addError(required String type, required String message, String pointer, Struct details) 
  ```

