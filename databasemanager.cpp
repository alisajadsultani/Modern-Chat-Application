#include "databasemanager.h"

DataBaseManager::DataBaseManager(QObject *parent) : QObject(parent) {
    db = QSqlDatabase::addDatabase("QPSQL");
    db.setHostName("localhost");
    db.setDatabaseName("User_information");
    db.setUserName("postgres");
    db.setPassword("BossDaddy@123");
    db.setPort(3999);

    if (!db.open()) {
        qDebug() << "Database connection failed:" << db.lastError().text();
    } else {
        qDebug() << "Database connected successfully!";
    }
}

bool DataBaseManager::registerUser(const QString &email, const QString &displayName, const QString &userName, const QString &password) {
    if (!db.isOpen()) {
        qDebug() << "Database is not open";
        return false;
    }

    QSqlQuery query;
    query.prepare("INSERT INTO users (email, display_name, username, password) VALUES (:email, :display_name, :username, :password)");
    query.bindValue(":email", email);
    query.bindValue(":display_name", displayName);
    query.bindValue(":username", userName);
    query.bindValue(":password", password);

    if (!query.exec()) {
        qDebug() << "Error inserting user:" << query.lastError().text();
        return false;
    }

    return true;
}

bool DataBaseManager::loginUser(const QString &email, const QString &password) {
    if (!db.isOpen()) {
        qDebug() << "Database is not open";
        return false;
    }

    QSqlQuery query;
    query.prepare("SELECT * FROM Users WHERE email = :email AND password = :password");
    query.bindValue(":email", email);
    query.bindValue(":password", password);

    if(query.exec() && query.next()) {
        return true;
    } else {
        qDebug() << "Error finding user";
        return false;
    }
}

QString DataBaseManager::getDisplayName(const QString &email) {
    if (!db.isOpen()) {
        qDebug() << "Database is not open";
        return "";
    }
    QSqlQuery query;
    query.prepare("SELECT display_name FROM Users WHERE email = :email");
    query.bindValue(":email", email);

    if (!query.exec()) {
        qDebug() << "Query execution failed:" << query.lastError().text();
        return "Unknown User";
    }


    if (query.next()) {
        QString displayName = query.value(0).toString();
        qDebug() << "Display Name Retrieved:" << displayName;
        return displayName;
    } else {
        qDebug() << "No user found for email:" << email;
    }

    return "Unknown User";
}

QString DataBaseManager::getUserName(const QString &email) {
    if (!db.isOpen()) {
        qDebug() << "Database is not open";
        return "";
    }
    QSqlQuery query;
    query.prepare("SELECT username FROM Users WHERE email = :email");
    query.bindValue(":email", email);

    if (!query.exec()) {
        qDebug() << "Query execution failed:" << query.lastError().text();
        return "Unknown User";
    }


    if (query.next()) {
        QString userName = query.value(0).toString();
        qDebug() << "Username Name Retrieved:" << userName;
        return userName;
    } else {
        qDebug() << "No user found for email:" << email;
    }

    return "Unknown User";
}

void DataBaseManager::setAboutMe(const QString &email, const QString &about_me) {
    if (!db.isOpen()) {
        qDebug() << "Database is not open";
        return;
    }

    QSqlQuery query;
    query.prepare("UPDATE Users SET about_me = :about_me WHERE email = :email");
    query.bindValue(":about_me", about_me);
    query.bindValue(":email", email);

    if (!query.exec()) {
        qDebug() << "Query execution failed: " << query.lastError().text();
        return;
    } else {
        qDebug() << "About added successfully";
    }
}

QString DataBaseManager::getAboutMe(const QString &email) {
    if (!db.isOpen()) {
        qDebug() << "Database is not open";
        return "";
    }
    QSqlQuery query;
    query.prepare("SELECT about_me FROM Users WHERE email = :email");
    query.bindValue(":email", email);

    if (!query.exec()) {
        qDebug() << "Query execution failed:" << query.lastError().text();
        return "Unknown User";
    }


    if (query.next()) {
        QString aboutMe = query.value(0).toString();
        qDebug() << "Username Name Retrieved:" << aboutMe;
        return aboutMe;
    } else {
        qDebug() << "No user found for email:" << email;
    }

    return "";
}

DataBaseManager::~DataBaseManager() {
    if(db.isOpen()) {
        db.close();
    }
}
