#!/bin/sh

java \
  -Xms${JAVA_MEMORY} \
  -Xmx${JAVA_MEMORY} \
  -XX:UseG1GC \
  -XX:G1HeapRegionSize=4M \
  -XX:+UnlockExperimentalVMOptions \
  -XX:+ParallelRefProcEnabled \
  -XX:+AlwaysPreTouch \
  -XX:MaxInlineLevel=15 \
  -jar velocity.jar