ifndef STUDIO_DIR
$(error STUDIO_DIR not specified)
endif

.PHONY: all

all: Svg2Avd.class

classpath := \
			 $(STUDIO_DIR)/lib/lib.jar \
			 $(STUDIO_DIR)/lib/util-8.jar \
			 $(STUDIO_DIR)/lib/module-intellij.libraries.guava.jar $(STUDIO_DIR)/lib/intellij.libraries.guava.jar \
			 $(STUDIO_DIR)/plugins/android/lib/android-base-common.jar \
			 $(STUDIO_DIR)/plugins/android/lib/sdk-common.jar
Svg2Avd.class: Svg2Avd.java
	javac --release 11 --class-path $(subst $() $(),:,$(classpath)) Svg2Avd.java
