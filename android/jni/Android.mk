include $(CLEAR_VARS)
LOCAL_PATH := $(ROOT_PATH)../../boost_1_66_0
LOCAL_MODULE := boost
# 需要编译哪个库，自行把libs目录下的cpp加进来即可。
LOCAL_SRC_FILES += \
  libs/filesystem/src/path.cpp \
  libs/filesystem/src/path_traits.cpp \
  libs/filesystem/src/operations.cpp \
  libs/filesystem/src/codecvt_error_category.cpp \
  libs/filesystem/src/portability.cpp \
  libs/filesystem/src/utf8_codecvt_facet.cpp \
  \
  libs/date_time/src/gregorian/date_generators.cpp \
  libs/date_time/src/gregorian/greg_month.cpp \
  libs/date_time/src/gregorian/greg_weekday.cpp \
  libs/date_time/src/gregorian/gregorian_types.cpp \
  libs/date_time/src/posix_time/posix_time_types.cpp \
  \
  libs/system/src/error_code.cpp \
  \
  libs/thread/src/future.cpp \
  libs/thread/src/pthread/once.cpp \
  libs/thread/src/pthread/once_atomic.cpp \
  libs/thread/src/pthread/thread.cpp
# 如果要把boost集成到动态库里，-fPIC是必须的，不然会有链接错误。原因请自行Google
LOCAL_CFLAGS += -fPIC -frtti -fexceptions
include $(BUILD_STATIC_LIBRARY)