#
# Copyright (c) 2013 Ashley Diamond.
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions
# are met:
# 1. Redistributions of source code must retain the above copyright
#    notice, this list of conditions and the following disclaimer.
# 2. Redistributions in binary form must reproduce the above copyright
#    notice, this list of conditions and the following disclaimer in the
#    documentation and/or other materials provided with the distribution.
#
# THIS SOFTWARE IS PROVIDED BY THE AUTHOR AND CONTRIBUTORS ``AS IS'' AND
# ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
# ARE DISCLAIMED.  IN NO EVENT SHALL THE AUTHOR OR CONTRIBUTORS BE LIABLE
# FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
# DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
# OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
# HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
# LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
# OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
# SUCH DAMAGE.
#

go_remove() {
	BEFORE=`du -m -d 0 \${WORLDDIR} | awk '{ print $1 }'`

	DIRECTORY="$1"
	LIST="$2"

	cd ${WORLDDIR}/${DIRECTORY}

        for c in $LIST; do
		[ -n "$c" ] || continue

		firstChar=`echo $c | cut -c 1`
		[ "$firstChar" == "#"  ] && continue

		if [ -e $c ]; then
			echo "Removing $c"
			rm -r $c || echo "Error: Can't remove it!"
		else
			echo "Doesnt exist $c does not exist"
		fi
        done

	AFTER=`du -m -d 0 ${WORLDDIR} | awk '{ print $1 }'`
	echo "### Size before=" $BEFORE " size after=" $AFTER
}

main_remove() {

	BEFORE=`du -m -d 0 \${WORLDDIR} | awk '{ print $1 }'`

	find ${WORLDDIR}/usr/local -name *.a | xargs rm -rvRf

	AFTER=`du -m -d 0 ${WORLDDIR} | awk '{ print $1 }'`
	echo "### Size before=" $BEFORE " size after=" $AFTER

	# Move termcap.small file
	if [ -f ${WORLDDIR}/etc/termcap.small ]; then
		echo "Using termcap.small"
		mv ${WORLDDIR}/etc/termcap.small ${WORLDDIR}/usr/share/misc/termcap.db
	fi

	FILES_TO_REMOVE='
	#usr/local/share/gnome-doc-utils
	usr/local/share/emacs
	usr/local/share/gnome-about

	usr/share/misc/magic.mgc
	usr/share/zoneinfo
	usr/share/examples

	usr/sbin/tcpdump
	usr/sbin/burncd
	usr/sbin/cdcontrol
	usr/sbin/mptutil

	usr/sbin/wire-test

	usr/bin/nex

	usr/local/bin/pkg-config
	usr/local/bin/gtk-demo
	usr/local/bin/shadowtex
	usr/local/bin/mysqlaccess
	usr/local/bin/mysql_waitpid
	usr/local/bin/mysqlbinlog
	usr/local/bin/mysqlslap
	usr/local/bin/mysqlcheck
	usr/local/bin/mysqldump
	usr/local/bin/mysqlimport
	usr/local/bin/mysqladmin

	boot/pxeboot

	#usr/local/share/compiz/reflection.png
	usr/local/sbin/pkg-static
	'

	go_remove "./" "$FILES_TO_REMOVE"

	# usr/local/share/gnome/help 7.5MB
	FOLDERS_TO_REMOVE='
	usr/local/share/ghostscript/*/doc
	usr/local/share/ghostscript/*/examples
	usr/local/share/doc
	usr/local/share/examples
	usr/local/lib/python2*/test
	#usr/local/share/gnome/help
	usr/local/lib/libffi-*/include

	usr/local/share/licenses
	usr/local/lib/perl5/*/Pod
	usr/local/share/gtk-doc
	'
	
	go_remove "./" "$FOLDERS_TO_REMOVE"

	FOLDERS='
	share/xsl/docbook/RELEASE-NOTES.html
	share/xsl/docbook/RELEASE-NOTES.pdf
	share/xsl/docbook/RELEASE-NOTES.txt
	share/xsl/docbook/RELEASE-NOTES.xml
	lib/perl5/5.*/perl/man
	share/xsl/docbook/manpages
	'

	go_remove "usr/local" "$FOLDERS"
}

remove_kernel_modules() {

MODULES_TO_REMOVE='
# in kernel
cpufreq.ko
miibus.ko
random.ko
tmpfs.ko
unionfs.ko
ahci.ko
aac.ko 
accf_data.ko
accf_dns.ko
accf_http.ko
agp.ko

amr.ko 
amr_cam.ko 
amr_linux.ko 
blank_saver.ko
carp.ko
cbb.ko
ciss.ko 
daemon_saver.ko
dragon_saver.ko
fade_saver.ko
fdc.ko
fire_saver.ko
geom_raid.ko
geom_raid3.ko
green_saver.ko
hpt27xx.ko 
hptmv.ko 
hptrr.ko 
ida.ko 
if_bxe.ko
iir.ko 
ipfw.ko
ipfw_nat.ko
ips.ko 
ipw_monitor.ko
isci.ko
ispfw.ko
linprocfs.ko
logo_saver.ko
mach64.ko
mfi.ko 
mfi_linux.ko 
mly.ko
mps.ko.symbols
mvs.ko
pccard.ko
rain_saver.ko
safe.ko
savage.ko
sfxge.ko 
sfxge.ko.symbols 
snake_saver.ko
splash_txt.ko
sppp.ko
star_saver.ko
systrace.ko
systrace_freebsd32.ko
systrace_linux32.ko
twa.ko 
twe.ko 
tws.ko 
uipaq.ko
uvisor.ko
vxge.ko 
warp_saver.ko
'

	DIRECTORY='boot/kernel'

	go_remove "$DIRECTORY" "$MODULES_TO_REMOVE" 
}

remove_include_files() {

	BEFORE=`du -m -d 0 \${WORLDDIR} | awk '{ print $1 }'`

	cd ${WORLDDIR}/usr/local/include
	#ignore_list="python2.7"
	#find . -maxdepth 1 ! -name python2.7 | xargs rm -rvRf
	mv python2.7 ../
	rm -rf ./*
	mv ../python2.7 .

	AFTER=`du -m -d 0 ${WORLDDIR} | awk '{ print $1 }'`
	echo "### Size before=" $BEFORE " size after=" $AFTER
}

remove_os_include_files() {

	BEFORE=`du -m -d 0 \${WORLDDIR} | awk '{ print $1 }'`

	rm -r ${WORLDDIR}/usr/include/*

	AFTER=`du -m -d 0 ${WORLDDIR} | awk '{ print $1 }'`
	echo "### Size before=" $BEFORE " size after=" $AFTER
}

remove_dotla_files() {

	BEFORE=`du -m -d 0 \${WORLDDIR} | awk '{ print $1 }'`

	cd ${WORLDDIR}/usr
	find . -name *.la -type f | xargs rm -rvRf

	AFTER=`du -m -d 0 ${WORLDDIR} | awk '{ print $1 }'`
	echo "### Size before=" $BEFORE " size after=" $AFTER
}

remove_linux() {
	LINUX='
	share/man
	share/doc
	lib/locale/locale-archive.tmpl
	kerberos
	include
	X11R6/include
	'
	go_remove "compat/linux/usr" "$LINUX"
}

remove_compiz() {
	COMPIZ='
	compiz-3d.schemas
	compiz-addhelper.schemas
	compiz-animation.schemas
	compiz-animationaddon.schemas
	compiz-annotate.schemas
	compiz-atlantis.schemas
	compiz-bench.schemas
	compiz-bicubic.schemas
	compiz-blur.schemas
	compiz-clone.schemas
	compiz-colorfilter.schemas
	compiz-commands.schemas
	compiz-core.schemas
	compiz-crashhandler.schemas
	compiz-cube.schemas
	compiz-cubeaddon.schemas
	compiz-cubemodel.schemas
	compiz-dbus.schemas
	compiz-decoration.schemas
	compiz-elements.schemas
	compiz-expo.schemas
	compiz-extrawm.schemas
	compiz-ezoom.schemas
	compiz-fade.schemas
	compiz-fadedesktop.schemas
	compiz-fakeargb.schemas
	compiz-firepaint.schemas
	compiz-fs.schemas
	compiz-gconf.schemas
	compiz-gears.schemas
	compiz-glib.schemas
	compiz-gnomecompat.schemas
	compiz-grid.schemas
	compiz-group.schemas
	compiz-imgjpeg.schemas
	compiz-ini.schemas
	compiz-inotify.schemas
	compiz-kconfig.schemas
	compiz-kdecompat.schemas
	compiz-loginout.schemas
	compiz-mag.schemas
	compiz-maximumize.schemas
	compiz-mblur.schemas
	compiz-minimize.schemas
	compiz-mousepoll.schemas
	compiz-move.schemas
	compiz-mswitch.schemas
	compiz-neg.schemas
	compiz-notification.schemas
	compiz-obs.schemas
	compiz-opacify.schemas
	compiz-place.schemas
	compiz-png.schemas
	compiz-put.schemas
	compiz-reflex.schemas
	compiz-regex.schemas
	compiz-resize.schemas
	compiz-resizeinfo.schemas
	compiz-ring.schemas
	compiz-rotate.schemas
	compiz-scale.schemas
	compiz-scaleaddon.schemas
	compiz-scalefilter.schemas
	compiz-screenshot.schemas
	compiz-session.schemas
	compiz-shelf.schemas
	compiz-shift.schemas
	compiz-showdesktop.schemas
	compiz-showmouse.schemas
	compiz-snap.schemas
	compiz-snow.schemas
	compiz-splash.schemas
	compiz-staticswitcher.schemas
	compiz-svg.schemas
	compiz-switcher.schemas
	compiz-text.schemas
	compiz-thumbnail.schemas
	compiz-tile.schemas
	compiz-titleinfo.schemas
	compiz-trailfocus.schemas
	compiz-video.schemas
	compiz-vpswitch.schemas
	compiz-wall.schemas
	compiz-wallpaper.schemas
	compiz-water.schemas
	compiz-widget.schemas
	compiz-winrules.schemas
	compiz-wobbly.schemas
	compiz-workarounds.schemas
	compiz-zoom.schemas'

	go_remove "usr/local/relocated/gconf/schemas" "$COMPIZ"

}
