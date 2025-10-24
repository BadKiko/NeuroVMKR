cmake_minimum_required(VERSION 3.16)

project(NeuroVMKR VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_AUTORCC ON)

# Подключаем Qt6 Quick и QuickControls2
find_package(Qt6 REQUIRED COMPONENTS Quick QuickControls2)

qt_standard_project_setup(REQUIRES 6.8)

qt_add_executable(appNeuroVMKR
    icons.qrc
    main.cpp
)

qt_add_qml_module(appNeuroVMKR
    URI NeuroVMKR
    VERSION 1.0
    QML_FILES
        Main.qml
        FileLoadPage.qml
        FileMovePage.qml
        components/FileDragDrop.qml
    RESOURCES
    icons.qrc
)

set_target_properties(appNeuroVMKR PROPERTIES
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

# Линкуем с Qt Quick и Qt QuickControls2
target_link_libraries(appNeuroVMKR
    PRIVATE Qt6::Quick Qt6::QuickControls2
)

include(GNUInstallDirs)
install(TARGETS appNeuroVMKR
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
