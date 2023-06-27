#ifndef POINTSFILE_H
#define POINTSFILE_H

#include <QObject>
#include <string>
#include <QPointF>
#include <QString>

class PointsFile : public QObject
{
    Q_OBJECT
public:
    PointsFile();
    ~PointsFile();

    QVariantList load();

public slots:
    void save(double, double, double, double);

private:
    const QString _fileName = QString::fromStdString("./routePoints.txt");
};
#endif