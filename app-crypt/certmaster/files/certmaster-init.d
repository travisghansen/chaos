#!/sbin/runscript

depend() {
	need net
}

start() {
	ebegin "Starting certmaster"
	start-stop-daemon --start --background --make-pidfile \
	                  --pidfile /var/run/certmaster.pid   \
			  --exec /usr/bin/certmaster
	eend $? "Failed to start certmaster"
}

stop() {
	ebegin "Stopping certmaster"
	start-stop-daemon --stop --quiet --pidfile /var/run/certmaster.pid
	eend $? "Failed to stop certmaster"
}

