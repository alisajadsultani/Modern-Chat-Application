#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include "databasemanager.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);
    QQmlApplicationEngine engine;

    // Create instances of DatabaseManager and NetworkManager
    DataBaseManager dbManager;

    // Register them in QML
    engine.rootContext()->setContextProperty("dbManager", &dbManager);

    // Load Main.qml
    engine.load(QUrl(QStringLiteral("file:///C:/Projects_with_GUI/Chat_Application/Main.qml")));

    if (engine.rootObjects().isEmpty())
        return -1;

    QObject::connect(&engine, &QQmlApplicationEngine::objectCreationFailed, &app, []() {
        QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);

    return app.exec();
}
