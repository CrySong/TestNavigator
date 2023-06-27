#include <QtGui/QGuiApplication>
#include <QtQml/QQmlApplicationEngine>
#include <QQmlContext>
#include "PointsFile.h"


void loadCoordinates(PointsFile& pointsFile, QQmlContext* context)
{
    QVariantList coordinates = pointsFile.load();

    bool hasSavedPoints = coordinates.count() == 4;

    QVariant startX;
    QVariant startY;
    QVariant endX;
    QVariant endY;

    if (hasSavedPoints)
    {
        startX = coordinates.at(0);
        startY = coordinates.at(1);
        endX = coordinates.at(2);
        endY = coordinates.at(3);
    }

    context->setContextProperty("hasSavedPoints", hasSavedPoints);
    context->setContextProperty("startX", startX);
    context->setContextProperty("startY", startY);
    context->setContextProperty("endX", endX);
    context->setContextProperty("endY", endY);
}

int main(int argc, char *argv[])
{
#if defined(Q_OS_WIN)
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
#endif

    QGuiApplication app(argc, argv);
    qmlRegisterInterface<PointsFile>("PointsFile");

    QQmlApplicationEngine engine;
    PointsFile pointsFile;
    QVariantList coordinates = pointsFile.load();

    QQmlContext* context = engine.rootContext();
    context->setContextProperty("pointsFile", &pointsFile);
    loadCoordinates(pointsFile, context);


    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));
    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();
}
