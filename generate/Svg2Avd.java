import com.android.ide.common.vectordrawable.Svg2Vector;

import java.io.IOException;
import java.nio.file.Path;

public class Svg2Avd {
	public static void main(String[] args) throws IOException {
		if (args.length < 1)
			throw new RuntimeException("Expected path to svg");
		Svg2Vector.parseSvgToXml(
			Path.of(args[0]),
			System.out
		);
	}
}
