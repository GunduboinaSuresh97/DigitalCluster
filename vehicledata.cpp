#include "vehicledata.h"
#include <qdebug.h>

VehicleData::VehicleData(QObject *parent)
    : QObject{parent}
{
    setSpeed(80);
    setRpm(2500);
    setFuel(100);
    connect(&m_timer,
            &QTimer::timeout,
            this,
            [this]()
            {
                setSpeed(speed() + 1);
                setRpm(rpm() + 50);
                setFuel(fuel() - 1);
                qDebug() << "Timer expired";
            });
    m_timer.start(1000);
}

int VehicleData::speed()const{
    qDebug()<<" Current Speed: "<<m_speed;
    return m_speed;
}


void VehicleData::setSpeed(int value){
    if(value > 240)
        value= 0;
    if(m_speed == value)
        return;
    m_speed = value;

    emit speedChanged();
    emit speedChangedMessage();

}

int VehicleData::rpm()const{
    qDebug()<<" Current RPM: "<<m_rpm;
    return m_rpm;
}

void VehicleData::setRpm(int value){
    if(value > 8000)
        value= 1000;
    if(m_rpm == value)
        return;
    m_rpm = value;

    emit rpmChanged();

}

int VehicleData::fuel()const{
    qDebug()<<" Current Fuel: "<<m_fuel;
    return m_fuel;
}

void VehicleData::setFuel(int value){
    if(value < 1)
        value= 0;
    if(m_fuel == value)
        return;
    m_fuel = value;

    emit fuelChanged();

    if(m_fuel <= 20){
        qDebug() << "C++: Emitting fuelLow signal";
        emit fuelLow();

    }

}

void VehicleData::increaseSpeed( ){
    setSpeed(speed() + 10);


}

void VehicleData::changeSpeed(int value){
    setSpeed(value);

}

int VehicleData::getSpeedPercentage(){
    return speed() *100 /240;
}
