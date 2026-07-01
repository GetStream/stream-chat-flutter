package io.getstream.chat.android.flutter.sample;

import androidx.test.platform.app.InstrumentationRegistry;

import org.junit.runner.RunWith;
import org.junit.runners.Parameterized;

import pl.leancode.patrol.PatrolJUnitRunner;

// Patrol e2e entry point: enumerates the Dart `patrolTest` cases and runs each
// as a parameterized JUnit test against MainActivity. Do not edit by hand.
@RunWith(Parameterized.class)
public class MainActivityTest {
    @Parameterized.Parameters(name = "{0}")
    public static Object[] testCases() {
        PatrolJUnitRunner instrumentation =
                (PatrolJUnitRunner) InstrumentationRegistry.getInstrumentation();
        instrumentation.setUp(MainActivity.class);
        instrumentation.waitForPatrolAppService();
        return instrumentation.listDartTests();
    }

    public MainActivityTest(String dartTestName) {
        this.dartTestName = dartTestName;
    }

    private final String dartTestName;

    @org.junit.Test
    public void runDartTest() {
        PatrolJUnitRunner instrumentation =
                (PatrolJUnitRunner) InstrumentationRegistry.getInstrumentation();
        instrumentation.runDartTest(dartTestName);
    }
}
