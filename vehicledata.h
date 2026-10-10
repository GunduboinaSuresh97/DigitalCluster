#ifndef VEHICLEDATA_H
#define VEHICLEDATA_H
#include <QTimer>

#include <QObject>

class VehicleData : public QObject
{
    Q_OBJECT
    Q_PROPERTY(int speed READ speed WRITE setSpeed NOTIFY speedChanged)
    Q_PROPERTY(int rpm READ rpm WRITE setRpm NOTIFY rpmChanged)
    Q_PROPERTY(int fuel READ fuel WRITE setFuel NOTIFY fuelChanged)

public:
    explicit VehicleData(QObject *parent = nullptr);
    int speed()const;
    void setSpeed(int value);
    int rpm()const;
    void setRpm(int value);
    int fuel()const;
    void setFuel(int value);
    Q_INVOKABLE void increaseSpeed();
    Q_INVOKABLE void changeSpeed(int value);
    Q_INVOKABLE int getSpeedPercentage( );



signals:
    void speedChanged();
    void speedChangedMessage();
    void rpmChanged();
    void fuelChanged();
    void fuelLow();


private:
   int m_speed = 0;
   int m_rpm = 0;
   int m_fuel = 100;
    QTimer m_timer;
};

#endif // VEHICLEDATA_H
