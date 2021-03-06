################################################################################
#
# MAME2010
#
################################################################################
# Version.: Commits on Nov 7, 2019
LIBRETRO_MAME2010_VERSION = d3151837758eade73c85c28c20e7d2a8706f30c6
LIBRETRO_MAME2010_SITE = $(call github,libretro,mame2010-libretro,$(LIBRETRO_MAME2010_VERSION))
LIBRETRO_MAME2010_LICENSE = MAME

LIBRETRO_MAME2010_EXTRA_ARGS = VRENDER=soft emulator

ifeq ($(BR2_x86_64),y)
	LIBRETRO_MAME2010_EXTRA_ARGS += ARCH=x86_64 PTR64=1
endif

ifeq ($(BR2_x86_i586),y)
	LIBRETRO_MAME2010_EXTRA_ARGS += PTR64=0
endif

ifeq ($(BR2_arm),y)
	LIBRETRO_MAME2010_EXTRA_ARGS += ARM_ENABLED=1 PTR64=0
endif

ifeq ($(BR2_aarch64),y)
	LIBRETRO_MAME2010_EXTRA_ARGS += ARM_ENABLED=1 PTR64=1
endif

define LIBRETRO_MAME2010_BUILD_CMDS
	mkdir -p $(@D)/obj/mame/cpu/ccpu
	$(TARGET_CONFIGURE_OPTS) $(MAKE) CXX="$(TARGET_CXX)" CC="$(TARGET_CC)" LD="$(TARGET_CC)" -C $(@D)/ -f Makefile platform="$(LIBRETRO_PLATFORM)" $(LIBRETRO_MAME2010_EXTRA_ARGS)
endef

define LIBRETRO_MAME2010_INSTALL_TARGET_CMDS
	$(INSTALL) -D $(@D)/mame2010_libretro.so \
		$(TARGET_DIR)/usr/lib/libretro/mame0139_libretro.so

	# Bios
    # Need to think of another way to use these files.
    # They take up a lot of space on tmpfs.
	mkdir -p $(TARGET_DIR)/usr/share/batocera/datainit/bios/mame2010/samples
	$(INSTALL) -D $(@D)/metadata/* \
		$(TARGET_DIR)/usr/share/batocera/datainit/bios/mame2010
endef

$(eval $(generic-package))
