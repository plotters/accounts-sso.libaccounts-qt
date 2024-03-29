include( ../common-project-config.pri )
include( ../common-vars.pri )

TARGET = accountstest
SOURCES += \
    accountstest.cpp
HEADERS += \
    accountstest.h
QT = \
    core \
    testlib \
    xml

greaterThan(QT_MAJOR_VERSION, 4) {
    LIBS += -laccounts-qt5
} else {
    LIBS += -laccounts-qt
}

QMAKE_RPATHDIR = $${QMAKE_LIBDIR}

#Check for the existence of aegis-crypto
system(pkg-config --exists aegis-crypto) :HAVE_AEGISCRYPTO=YES
contains(HAVE_AEGISCRYPTO, YES) {
    message("aegis-crypto detected...")
    DEFINES += HAVE_AEGISCRYPTO
}

include( ../common-installs-config.pri )

DATA_PATH = $${INSTALL_PREFIX}/share/libaccounts-qt-tests/

DEFINES += \
    SERVICES_DIR=\\\"$$DATA_PATH\\\" \
    SERVICE_TYPES_DIR=\\\"$$DATA_PATH\\\" \
    PROVIDERS_DIR=\\\"$$DATA_PATH\\\"

service.path = $$DATA_PATH
service.files += $${TOP_SRC_DIR}/tests/*.service
INSTALLS     += service

service-type.path = $$DATA_PATH
service-type.files += $${TOP_SRC_DIR}/tests/*.service-type
INSTALLS += service-type

provider.path = $$DATA_PATH
provider.files += $${TOP_SRC_DIR}/tests/*.provider
INSTALLS     += provider

testsuite.files = $${TOP_SRC_DIR}/tests/tests.xml
testsuite.path = $$DATA_PATH
INSTALLS += testsuite

QMAKE_EXTRA_TARGETS += check
check.depends = accountstest
check.commands = "TESTDIR=$${TOP_SRC_DIR}/tests $${TOP_SRC_DIR}/tests/accountstest.sh"
