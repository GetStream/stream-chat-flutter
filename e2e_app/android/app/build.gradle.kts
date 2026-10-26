plugins {
    id("com.android.application")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "io.getstream.chat.e2e_app"
    // The SDK's plugins need a newer compile SDK than Flutter's default.
    compileSdk = maxOf(flutter.compileSdkVersion, 36)
    // GitHub's Ubuntu runners preinstall a few NDKs, but not Flutter's default, so every CI
    // job used to download one mid-build (a failure point, and 1-2 min per job). Use the newest
    // preinstalled NDK there; a newer NDK also serves plugins that ask for an older one.
    ndkVersion = System.getenv("ANDROID_NDK_LATEST_HOME")?.let { File(it).name } ?: flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    defaultConfig {
        applicationId = "io.getstream.chat.e2e_app"
        minSdk = maxOf(flutter.minSdkVersion, 24)
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            // Never published, so the debug keys do.
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

kotlin {
    compilerOptions {
        jvmTarget = org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_17
    }
}

flutter {
    source = "../.."
}
