package com.github.raonigabriel.graal;

import java.io.IOException;
import java.io.InputStream;
import java.nio.charset.StandardCharsets;

import org.apache.commons.io.IOUtils;

public class HelloResources {

	// Notice that static fields are evaluated during AOT compilation.
	// Also notice that "com.oracle.graalvm.isaot" system property is injected by Graal during AOT.
	// If we run this on JVM, this property does not exists and thus, evaluates to false.
	// This mechanic can also be used to easily add env vars to the native build.
	private static final boolean IS_NATIVE = Boolean.getBoolean("com.oracle.graalvm.isaot");

	// By running "java -jar hello-resources.jar", we´ll use JVM, and resources come from classpath.  
	// But after AOT compilation, there will be no classpath. Therefore, we must embed the resource.
	public static void main(String[] args) throws IOException {
		try (InputStream is = HelloResources.class.getResourceAsStream("/message.txt")) {
			// Just a small call to 3rd party lib (commons-io) to read the InputStream
			String format = IOUtils.toString(is, StandardCharsets.UTF_8);
			System.out.println(String.format(format, IS_NATIVE ?  "Native" : "Java"));
		}
	}

}