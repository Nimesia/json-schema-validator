component accessors="true"{

	property name="message" type="String" default="";
	property name="type" type="String" default="";
	property name="pointer" type="String" default="";
	property name="details" type="Struct";

    public Error function init(){
        return this;
    }

}
