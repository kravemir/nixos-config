# Profiles

Profiles to be reused for different machines

## Development profile

To use [Gradle toolchains support](https://docs.gradle.org/current/userguide/toolchains.html), add following to `~/.gradle/gradle.properties`:

```
org.gradle.java.installations.auto-download=false
org.gradle.java.installations.fromEnv=JAVA_TOOLCHAIN_NIX_JDK11,JAVA_TOOLCHAIN_NIX_JDK17,JAVA_TOOLCHAIN_NIX_JDK8
```


