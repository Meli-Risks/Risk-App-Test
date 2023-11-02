import com.intuit.karate.junit5.Karate;

class KarateTest {

    @Karate.Test
    Karate runAllFeatures() {
        return Karate.run().tags("~@ignore").relativeTo(getClass());
    }
}

