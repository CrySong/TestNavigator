#include <QPointF>
#include <QVariant>
#include <QFile>
#include <QString>
#include <QIODevice>
#include <QByteArray>
#include <QJsonDocument>
#include <QStringList>
#include <QRegularExpression>
#include "PointsFile.h"

PointsFile::PointsFile()
{
}

PointsFile::~PointsFile()
{
}

QString readFile(const QString fileName)
{
	QFile file;
	file.setFileName(fileName);
	file.open(QIODevice::ReadOnly | QIODevice::Text);
	QString val = file.readAll();
	file.close();

	return val;
}

QVariantList getSavedCoordinates(const QString content)
{
	QVariantList coordinates;

	QRegularExpression reExp(QString::fromStdString("\\d+.?\\d*"));
	QRegularExpressionMatchIterator i = reExp.globalMatch(content);
	while (i.hasNext())
	{
		QRegularExpressionMatch match = i.next();
		if (match.hasMatch())
		{
			auto cptr = match.captured(0);
			coordinates.push_back(cptr.toDouble());
		}
	}

	if (coordinates.count() != 4)
		throw std::exception("incorrect coordinates pair");

	return coordinates;
}

QVariantList PointsFile::load()
{
	if (!QFile::exists(_fileName))
		return QVariantList();

	QString content = readFile(_fileName);
	return getSavedCoordinates(content);
}

void saveFile(const QString fileName, const QString content)
{
	QFile file;
	file.setFileName(fileName);
	file.open(QIODevice::WriteOnly | QIODevice::Truncate | QIODevice::Text);
	file.write(content.toUtf8());
	file.close();
}

void PointsFile::save(double startX, double startY, double endX, double endY)
{
	auto content = QString("{{%1, %2}, {%3, %4}}").arg(startX).arg(startY).arg(endX).arg(endY);
	saveFile(_fileName, content);
}
