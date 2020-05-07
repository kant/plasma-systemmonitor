/*
 * SPDX-FileCopyrightText: 2020 Arjen Hiemstra <ahiemstra@heimr.nl>
 * 
 * SPDX-License-Identifier: LGPL-2.1-only OR LGPL-3.0-only OR LicenseRef-KDE-Accepted-LGPL
 */

#pragma once

#include <QObject>

class PageDataObject;
class QQuickItem;

// namespace KSysGuard { class SensorFaceController; }
class SensorFaceController;

class FaceLoader : public QObject
{
    Q_OBJECT
    Q_PROPERTY(PageDataObject *dataObject READ dataObject WRITE setDataObject NOTIFY dataObjectChanged)
    Q_PROPERTY(SensorFaceController *controller READ controller NOTIFY controllerChanged)

public:
    FaceLoader(QObject *parent = nullptr);

    PageDataObject *dataObject() const;
    void setDataObject(PageDataObject *newDataObject);
    Q_SIGNAL void dataObjectChanged();

    SensorFaceController *controller() const;
    Q_SIGNAL void controllerChanged();

private:
    PageDataObject *m_dataObject = nullptr;
    SensorFaceController *m_faceController = nullptr;
};
