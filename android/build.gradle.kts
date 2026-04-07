//buildscript {
//    ext.kotlin_version = '1.9.22'
//    repositories {
//        google()
//        mavenCentral()
//    }
//
//    dependencies {
//        classpath 'com.android.tools.build:gradle:8.1.4'
//        classpath "org.jetbrains.kotlin:kotlin-gradle-plugin:$kotlin_version"
//    }
//}
//
//allprojects {
//    repositories {
//        google()
//        mavenCentral()
//    }
//}
//
//rootProject.buildDir = '../build'
//subprojects {
//    project.buildDir = "${rootProject.buildDir}/${project.name}"
//}
//subprojects {
//    project.evaluationDependsOn(':app')
//}
//
//tasks.register('clean', Delete) {
//    delete rootProject.buildDir
//}
//
//
// android/build.gradle.kts
allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

// ← force all subprojects to use the same Kotlin version
subprojects {
    configurations.all {
        resolutionStrategy {
            force("org.jetbrains.kotlin:kotlin-stdlib:1.9.22")
            force("org.jetbrains.kotlin:kotlin-stdlib-jdk8:1.9.22")
            force("org.jetbrains.kotlin:kotlin-stdlib-jdk7:1.9.22")
            force("org.jetbrains.kotlin:kotlin-reflect:1.9.22")
            force("org.jetbrains.kotlin:kotlin-compiler-embeddable:1.9.22")
        }
    }
}

val newBuildDir: Directory = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    layout.buildDirectory.value(newSubprojectBuildDir)
}

subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}