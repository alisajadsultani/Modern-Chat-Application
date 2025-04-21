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
    Q_INVOKABLE void setAboutMe(const QString &email, const QString &about_me);
    Q_INVOKABLE bool loginUser(const QString &email, const QString &password);
    Q_INVOKABLE QString getDisplayName(const QString &displayName);
    Q_INVOKABLE QString getAboutMe(const QString &email);
    Q_INVOKABLE QString getUserName(const QString &email);

private:
    QSqlDatabase db;

};

#endif // DATABASEMANAGER_H
