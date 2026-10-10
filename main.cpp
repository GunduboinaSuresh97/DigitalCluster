#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>

#include "vehicledata.h"


int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);
    VehicleData vehicleData;

    QQmlApplicationEngine engine;
    engine.rootContext()->setContextProperty(
        "vehicleData",
        &vehicleData
        );
    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);

    engine.loadFromModule("DigitalCluster", "Main");

    return QGuiApplication::exec();
}
