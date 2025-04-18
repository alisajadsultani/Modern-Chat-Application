#ifndef DATABASEMANAGER_H
#define DATABASEMANAGER_H

#include <QObject>
#include <QSqlDatabase>
#include <QSqlQuery>
#include <QSqlError>
#include <QDebug>

class DataBaseManager : public QObject
{
    Q_OBJECT
public:
    explicit DataBaseManager(QObject *parent = nullptr);
    ~DataBaseManager();

    Q_INVOKABLE bool registerUser(const QString &email, const QString &displayName, const QString &userName, const QString &password);
    Q_INVOKABLE bool loginUser(const QString &email, const QString &password);
    Q_INVOKABLE QString getDisplayName(const QString &displayName);

private:
    QSqlDatabase db;

};

#endif // DATABASEMANAGER_H
