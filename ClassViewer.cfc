<cfcomponent output="false" displayName="ClassViewer"
	hint="Gain even more introspection to complex objects and types in ColdFusion">
	<!--- Pseudo-constructor --->
	<cfscript>
		Class		= CreateObject("java", "java.lang.Class");
		Modifier	= CreateObject("java", "java.lang.reflect.Modifier");
	</cfscript>
	
	<cffunction name="viewClassByName" output="false" access="public" returnType="string"
		hint="Pass in the name of the object's class">
		<cfargument name="name" type="string" required="true" />
		<cfreturn viewClass(Class.forName(arguments.name)) />
	</cffunction>
	
	<cffunction name="viewObject" output="false" access="public" returnType="string"
		hint="Pass in an instance of an object">
		<cfargument name="obj" required="true" />
		<cfreturn viewClass(arguments.obj.getClass()) />
	</cffunction>
	
	<cffunction name="viewClass" output="false" access="public" returnType="string"
		hint="Pass in a class to view it's public constructors, methods and fields">
		<cfargument name="c" required="true" />
		<cfscript>
			var local = StructNew();
			// TODO: does this even work??
			if (arguments.c EQ JavaCast("null", 0)) {
				return "Error: Null Reference";
			}
			local.out = CreateObject("java", "java.lang.StringBuffer");
			local.out.append(Modifier.toString(arguments.c.getModifiers()));
			local.out.append(" class ");
			local.out.append(arguments.c.getName());
			local.out.append(chr(10)&chr(9));
			local.out.append(" extends ");
			local.out.append(arguments.c.getSuperclass().getName());
			local.out.append(chr(10)&chr(9));
			local.interfaces = arguments.c.getInterfaces();
			if (ArrayLen(local.interfaces) GT 0) {
				local.out.append(" implements ");
				for (local.i = 1; local.i LTE ArrayLen(local.interfaces); local.i = local.i +1) {
					if (local.i NEQ 1) {
						local.out.append(", ");
					}
					local.out.append(local.interfaces[local.i].getName());
				}
				local.out.append(chr(10));
			}
			local.out.append("{");
			local.out.append(chr(10)&chr(9));
			local.out.append(" /*** CONSTRUCTORS ***/");
			local.out.append(chr(10)&chr(9));
			local.constructors = arguments.c.getConstructors();
			for (local.c = 1; local.c LTE ArrayLen(local.constructors); local.c = local.c +1) {
				local.out.append(" ");
				local.out.append(viewConstructor(local.constructors[local.c]));
				local.out.append(chr(10)&chr(9));
				local.out.append(chr(10)&chr(9));
			}
			local.out.append(" /*** METHODS ***/");
			local.out.append(chr(10)&chr(9));
			local.methods = arguments.c.getMethods();
			for (local.m = 1; local.m LTE ArrayLen(local.methods); local.m = local.m + 1) {
				local.out.append(" ");
				local.out.append(viewMethod(local.methods[local.m]));
				local.out.append(chr(10)&chr(9));
				local.out.append(chr(10)&chr(9));
			}
			local.out.append(" /*** FIELDS ***/");
			local.out.append(chr(10)&chr(9));
			local.fields = arguments.c.getFields();
			for (local.f = 1; local.f LTE ArrayLen(local.fields); local.f = local.f + 1) {
				local.out.append(" ");
				local.out.append(Modifier.toString(local.fields[local.f].getModifiers()));
				local.out.append(" ");
				local.out.append(local.fields[local.f].getType().getName());
				local.out.append(" ");
				local.out.append(local.fields[local.f].getName());
				local.out.append(chr(10)&chr(9));
			}
			local.out.append(chr(10));
			local.out.append("}");
			return local.out.toString();
		</cfscript>
	</cffunction>
	
	<cffunction name="viewMethod" output="false" access="private" returnType="string"
		hint="Gather details of the given method">
		<cfargument name="m" required="true" />
		<cfscript>
			var local = StructNew();
			local.out = CreateObject("java", "java.lang.StringBuffer");
			local.out.append(Modifier.toString(arguments.m.getModifiers()));
			local.out.append(" ");
			local.out.append(arguments.m.getReturnType().getName());
			local.out.append(" ");
			local.out.append(arguments.m.getName());
			local.out.append("(");
			local.params = arguments.m.getParameterTypes();
			for (local.p = 1; local.p LTE ArrayLen(local.params); local.p = local.p + 1) {
				if (local.p NEQ 1) {
					local.out.append(", ");
				}
				local.out.append(local.params[local.p].getName());
			}
			local.out.append(")");
			local.exc = arguments.m.getExceptionTypes();
			if (ArrayLen(local.exc) GT 0) {
				local.out.append(chr(10)&chr(9)&chr(9));
				local.out.append(" throws ");
				for (local.e = 1; local.e LTE ArrayLen(local.exc); local.e = local.e + 1) {
					if (local.e NEQ 1) {
						local.out.append(", ");
					}
					local.out.append(local.exc[local.e].getName());
				}
			}
			return local.out.toString();
		</cfscript>
	</cffunction>
	
	<cffunction name="viewConstructor" output="false" access="private" returnType="string"
		hint="Gather details of the given constructor">
		<cfargument name="c" required="true" />
		<cfscript>
			var local = StructNew();
			local.out = CreateObject("java", "java.lang.StringBuffer");
			local.out.append(Modifier.toString(arguments.c.getModifiers()));
			local.out.append(" ");
			local.out.append(arguments.c.getName());
			local.out.append("(");
			local.params = arguments.c.getParameterTypes();
			for (local.p = 1; local.p LTE ArrayLen(local.params); local.p = local.p + 1) {
				if (local.p NEQ 1) {
					local.out.append(" ,");
				}
				local.out.append(local.params[local.p].getName());
			}
			local.out.append(")");
			return local.out.toString();
		</cfscript>
	</cffunction>
</cfcomponent>