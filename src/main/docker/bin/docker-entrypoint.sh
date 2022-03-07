#!/usr/bin/env bash
#
# Copyright 2016 Confluent Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.


# Override this section from the script to include the com.sun.management.jmxremote.rmi.port property.
if [ -z "$KAFKA_JMX_OPTS" ]; then
  export KAFKA_JMX_OPTS="-Dcom.sun.management.jmxremote=true -Dcom.sun.management.jmxremote.authenticate=false  -Dcom.sun.management.jmxremote.ssl=false "
fi

# The JMX client needs to be able to connect to java.rmi.server.hostname.
# The default for bridged n/w is the bridged IP so you will only be able to connect from another docker container.
# For host n/w, this is the IP that the hostname on the host resolves to.

echo "Starting - Kafka Connect"
# If you have more that one n/w configured, hostname -i gives you all the IPs,
# the default is to pick the first IP (or network).
export KAFKA_JMX_HOSTNAME=${KAFKA_JMX_HOSTNAME:-$(hostname -i | cut -d" " -f1)}

if [ "$KAFKA_JMX_PORT" ]; then
  # This ensures that the "if" section for JMX_PORT in kafka launch script does not trigger.
  export JMX_PORT=$KAFKA_JMX_PORT
  export KAFKA_JMX_OPTS="$KAFKA_JMX_OPTS -Djava.rmi.server.hostname=$KAFKA_JMX_HOSTNAME -Dcom.sun.management.jmxremote.local.only=false -Dcom.sun.management.jmxremote.rmi.port=$JMX_PORT -Dcom.sun.management.jmxremote.port=$JMX_PORT"
fi

echo "===> Launching ${COMPONENT} ... "
# Add external jars to the classpath
# And this also makes sure that the CLASSPATH does not start with ":/etc/..."
# because this causes the plugin scanner to scan the entire disk.
export CLASSPATH="/usr/share/java/kafka/*"
export KAFKA_OPTS="${JAVA_OPTIONS} -javaagent:/usr/local/lib/jmx_prometheus_javaagent-0.3.1.jar=7071:/config-volume/jmx.yml"
export KAFKA_HEAP_OPTS="${JAVA_HEAP_OPTIONS}"
echo "===> Launching connect distributed  ... "


./config-volume/run.sh
exec connect-distributed /connect-config/connect-distributed.properties
